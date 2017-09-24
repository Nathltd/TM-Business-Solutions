<!doctype html>
<html>
<head>
<title><cfoutput>Adjustment Modification :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>
<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Adjustment Modification</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif IsDefined("form.Update") is True>

<cftransaction>
<cfquery>
UPDATE AdjInventory
SET
AdjDate = <cfqueryparam value="#CreateODBCDate(session.myDate)#" cfsqltype="cf_sql_date">,
BranchId = '#trim(form.BranchID)#',
StaffID = '#trim(form.StaffID)#',
Comment = '#trim(form.Comment)#',
LastUpdated = <cfqueryparam value="#CreateODBCDate(Now())#" cfsqltype="cf_sql_date">,
Creator = '#GetAuthUser()#',
AdjID = '#trim(form.AdjID)#'
WHERE AdjID = '#trim(Form.AdjIDb)#'
</cfquery>

<cfloop index = "counter" from = "1" to = #arraylen(Form.SalesUpdate.rowstatus.action)#>
<cfif Form.SalesUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertAdjDetails">
INSERT into AdjInvtryDetails (AdjID,ProductID,CurQty,NewQty) 
    VALUES ('#form.AdjID#','#Form.SalesUpdate.ProductID[counter]#','#Form.SalesUpdate.CurQty[counter]#','#Form.SalesUpdate.NewQty[counter]#')
</cfquery>
<cfelseif  Form.SalesUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdateAdjDetails">
UPDATE AdjInvtryDetails
SET
ProductID = '#trim(Form.SalesUpdate.ProductID[counter])#',
CurQty = '#trim(Form.SalesUpdate.CurQty[counter])#',
NewQty = '#trim(Form.SalesUpdate.NewQty[counter])#'
WHERE ID = #trim(Form.SalesUpdate.ID[counter])#
</cfquery>
<cfelseif Form.SalesUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeleteAdjDetails">
DELETE from AdjInvtryDetails
WHERE ID = #trim(Form.SalesUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
</cftransaction>
<p>

<cfoutput> Invoice No. <strong>#form.AdjID#</strong> have been Updated successfully<a href="?"> New Invoice </a></cfoutput>

</p>
<cfelse>
<cfif isdefined("form.search") or ("url.SalesID") is true>

<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="form.AmountPaid" default="">
<cfparam name="session.AmountPaid" default="form.AmountPaid">
<cfparam name="session.CustomerCode" default="">
<cfparam name="session.InvoiceNo" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchCode" default="">
<cfparam name="session.RepCode" default="">
<cfparam name="session.select" default="">
<cfparam name="url.SalesID" default="">
<cfparam name="url.reset" default="">
<cfif isdefined (#url.SalesID#)>
<cfset #form.SalesID# = #url.SalesID#>
</cfif>
<cfquery name="Adj">
SELECT ID,BranchID,AdjID,AdjDate,BranchID,comment,StaffID,Creator
FROM AdjInventory
WHERE AdjID = <cfqueryparam value="#Trim(form.AdjID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "staff">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>

<cfquery name="AdjDetails">
SELECT ID,AdjID,ProductID,CurQty,NewQty
FROM AdjInvtryDetails
WHERE AdjID = <cfqueryparam value="#Trim(form.AdjID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "staff">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>

<cfquery name="BranchCode">
SELECT BranchID, Description
FROM Branches
ORDER BY BranchID ASC 
</cfquery>
<cfquery name="RepCode">
SELECT FirstName, BranchID FROM Users
WHERE Designation <> 'Alpha'
ORDER BY FirstName

</cfquery>


<cfquery name="Products">
SELECT ProductID  FROM Inventory
ORDER BY ProductID
</cfquery>

<script> 


function checkKeyCode(evt)
{

var evt = (evt) ? evt : ((window.event) ? window.event : "");
var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
if(event.keyCode==116)
{
event.keyCode=0;
return false
}
}
document.onkeydown=checkKeyCode;
</script>

<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">
<div align="center">
  <table width="60%" border="0">
    <tr>
      <td><div align="left">Ref No:</div></td>
      <td><div align="left">
        
          <cfinput type="text" name="AdjID" size="6" required="yes" class="bold_10pt_black" value="#Adj.AdjID#" tooltip="Ref No." autosuggest="off">
          <cfinput type="hidden" name="AdjIDb" value="#Adj.AdjID#">
          
      </div></td>
      <td width="60"><div align="left">Date:</div></td>
      <td width="180"><div align="left">
      <cfinput type="datefield" class="bold_10pt_Date" mask="dd/mm/yyyy" value="#dateformat(Adj.AdjDate,"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Adjustment Date" required="yes" message="Enter valid Date"/>
      
        
          
      </div></td>
    </tr>
    <tr>
      <td width="61"><div align="left">Authorised:</div></td>
      <td width="360"><div align="left">
        
          <cfselect name="StaffID" class="bold_10pt_black" id="StaffID" tooltip="Staff that signed the invoice" required="yes" message="Select Authorised">
          <cfloop query="repCode">
           <option value="#Trim(Firstname)#" <cfif Adj.StaffID is #Firstname#>
    selected </cfif>>#Firstname#</option>
    </cfloop>
    </cfselect>
        
      </div></td>
      <td><div align="left">Branch:</div></td>
      <td><div align="left">
        
          <cfselect name="BranchID" id="BranchID" required="yes" class="bold_10pt_black" message="Choose Location">
          <cfloop query="BranchCode">
           <option value="#Trim(BranchID)#" <cfif Adj.BranchID is #BranchID#>
    selected </cfif>>#BranchID#</option>
    </cfloop> </cfselect>
              </div></td>
    </tr>
    <tr>
      <td><div align="left">Comment:</div></td>
      <td><div align="left">
          <cfinput type="text" name="Comment" size="15" required="yes" class="bold_10pt_black" value="#Adj.Comment#" title="Comment" autosuggest="off" >
          
      </div></td>
      <td></td>
      <td><label> </label></td>
    </tr>
  </table>
</div>
<br>

  <div align="center" id="formGrid">
  <table width="471" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top">
<cfgrid name="SalesUpdate"  query="AdjDetails"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="400">

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "ProductID" header = "Products" width="220" headeralign="center" values="#ValueList(Products.ProductID)#" valuesdelimiter=",">
<cfgridcolumn name = "CurQty" header = "Current" width="60" headeralign="right"  dataalign="right">
<cfgridcolumn name = "NewQty" display="Yes" header = "New" headeralign="right" width="70" dataalign="right">
</cfgrid><br></td>
<td width="56" valign="bottom">
    <cfinput type="submit" name="Update" value="Update">
  </td>
</tr>
</thead>
  </table>
</div>

</cfform>
</cfoutput>

<cfelse>
<cfquery name="AdjInventory" datasource="#request.dsn#">
select AdjID, Creator
from AdjInventory
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Manager">
  <cfelse>
WHERE Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
ORDER BY AdjID ASC
</cfquery>
<cfset AdjInvent=ValueList(AdjInventory.AdjID)>

<br />
<cfif #AdjInventory.Recordcount# gte 1>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table>
 <tr>
<td align="right" >Ref No:</td>
<td align="left" >
  <cfinput type="text" name="AdjID" required="yes" autosuggest="#AdjInvent#" autosuggestminlength="2" style="width:100%">
</td>
    </tr>
    <tr>
    <td colspan="2" align="right">
      <div align="right">
        <cfinput type="submit" name="Search" value="Search">
      </div></td>
    </tr>
  </table>
  </cfform>
<cfelse>
<h3> No Adjustment Record Found </h3>
</cfif>
</cfif>
</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html>