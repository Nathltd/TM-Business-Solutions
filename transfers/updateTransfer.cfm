<!doctype html>
<html>
<head>
<title><cfoutput>Transfer Modify :: #request.title#</cfoutput></title>
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
<h4>Product Transfer Modification</h4>
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

<cfquery datasource="#request.dsn#">

UPDATE Transfers
SET
TransferDate =<cfqueryparam value="#lsDateFormat(CreateODBCDate(form.myDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
Source = '#trim(form.SourceID)#',
Destination = '#trim(form.DestinationID)#',
StaffID = '#trim(form.RepName)#',
LastUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
Creator = '#GetAuthUser()#',
AccountId = '#trim(form.select)#',
TransferID = '#trim(Form.TransferID)#'
WHERE TransferID = #trim(Form.TransferIDa)#
</cfquery>

<cfloop index = "counter" from = "1" to = #arraylen(Form.TransferUpdate.rowstatus.action)#>
<cfif Form.TransferUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertTransferDetails">
INSERT into TransferDetails (TransferID,ProductID,Quantity,UnitPrice) 
VALUES ('#form.TransferID#', '#Form.TransferUpdate.ProductID[counter]#','#Form.TransferUpdate.Quantity[counter]#','#Form.TransferUpdate.UnitPrice[counter]#')
</cfquery>
<cfelseif  Form.TransferUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdateTransferDetails">
UPDATE TransferDetails
SET
ProductID = '#trim(Form.TransferUpdate.ProductID[counter])#',
Quantity = '#trim(Form.TransferUpdate.Quantity[counter])#',
UnitPrice = '#trim(Form.TransferUpdate.UnitPrice[counter])#',
TransferID = '#trim(form.TransferID)#'
WHERE ID = #trim(Form.TransferUpdate.ID[counter])#
</cfquery>
<cfelseif Form.TransferUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeleteTransferDetails">
DELETE from TransferDetails
WHERE ID = #trim(Form.TransferUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>

</cftransaction>
<p>

<cfoutput> Transfer No. <strong>#form.TransferID#</strong> have been Updated successfully<a href="UpdateTransfer.cfm"> New Transfer </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>

<cfquery name="TransferDay">
select TransferID, Creator, Transferdate
from Transfers
WHERE TransferID = <cfqueryparam value="#form.TransferID#" cfsqltype="cf_sql_clob"> AND Transferdate >= <cfqueryparam value="#CreateODBCDate(request.clsDate)#" cfsqltype="cf_sql_date">
</cfquery>

<cfset Transfer=ValueList(TransferDay.TransferID)>
<cfset validTransfer = #Listlen(Transfer)#>
<cfif #validTransfer# eq 0>


<h3>This Transfer have been closed. Please contact the administrator.</h3>
<cfabort>
</cfif>

<cfparam name="session.TransferID" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.SourceID" default="">
<cfparam name="session.DestinationID" default="">
<cfparam name="session.RepCode" default="">
<cfparam name="session.select" default="">
<cfparam name="url.reset" default="">

<cfquery name="Transfer">
SELECT Source,Destination,TransferID,AccountID,TransferDate,StaffID
FROM Transfers
WHERE TransferID = <cfqueryparam value="#Trim(form.TransferID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator" or #GetUserRoles()# is "Alpha" or #GetUserRoles()# is "Manager">
<cfelseif #GetUserRoles()# is "staff">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>

<cfquery name="TransferDetails">
SELECT ID,TransferID,ProductID,Quantity, UnitPrice
FROM TransferDetails
WHERE TransferID = <cfqueryparam value="#Trim(form.TransferID)#" cfsqltype="cf_sql_clob">
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
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
SELECT ProductID from Inventory
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

<div align="center">
<strong> Transfer Posting Modification</strong> - <a href="updateTransfer.cfm?reset"><font size="-1"> reset</font></a><br /><br />

<div align="center">
<cfoutput>


<cfform action="UpdateTransfer.cfm" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="60%" border="0">
    <tr>
      <td>&nbsp;</td>
      <td><div align="right">Transfer No.:</div></td>
      <td><div align="left">
        <cfinput type="text" name="TransferID" tooltip="Invoice Number" required="yes" class="bold_10pt_black" id="TransferID" value="#Transfer.TransferID#" autocomplete="yes">
        <cfinput type="hidden" name="TransferIDa" id="TransferIDa" value="#Transfer.TransferID#">
      </div></td>
      <td colspan="2" rowspan="3">&nbsp;</td>
      <td><div align="right">Date:</div></td>
      <td width="200"><div align="left">
      <cfinput type="datefield" class="bold_10pt_Date" mask="dd/mm/yyyy" value="#dateformat(Transfer.TransferDate,"mm/dd/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Date of Transfer" required="yes" message="Enter valid Date"/>
      
       
      </div>
             </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><div align="right">Account:</div></td>
      <td><div align="left">
        <cfselect name="select" class="bold_10pt_black" id="select">
          <cfloop query="Accounts">
            <option value="#AccountID#" <cfif Transfer.AccountID is #AccountID#>
    selected </cfif>>#AccountID#</option>
            </cfloop>
          </cfselect>
      </div></td>
      <td width="85"><div align="right">Source:</div></td>
      <td width="174"><div align="left">

        <cfselect name="SourceID" id="SourceID" class="bold_10pt_black">
            <cfloop query="BranchCode">
           <option value="#Trim(BranchID)#" <cfif Transfer.Source is #BranchID#>
    selected </cfif>>#BranchID#</option>
    </cfloop>
        </cfselect>
                    
        </div></td>
      </tr>
      
    <tr>
      <td width="10">&nbsp;</td>
      <td width="114"><div align="right">Authorised:</div></td>
      <td width="133"><div align="left">
        <cfselect name="RepName" class="bold_10pt_black" id="RepName2" tooltip="Employee that signed the invoice">
          <cfloop query="repCode">
            <option value="#Trim(Firstname)#" <cfif Transfer.StaffID is #Firstname#>
    selected </cfif>>#Firstname#</option>
            </cfloop>
          </cfselect>
        </div></td>
      <td><div align="right">Destination:</div></td>
      <td><div align="left">
        
        <cfselect name="DestinationID" class="bold_10pt_black" id="DestinationID" tooltip="Employee that signed the invoice">
          <cfloop query="BranchCode">
            <option value="#Trim(BranchID)#" <cfif Transfer.Destination is #BranchID#>
    selected </cfif>>#BranchID#</option>
            </cfloop>
          </cfselect>
        
        </div></td>
    </tr>
    </table></div><br>

  <div align="center">
  <table width="430" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top">
<cfgrid name="TransferUpdate"  query="TransferDetails"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="410">

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "ProductID" header = "Products" width="220" headeralign="center" values="#ValueList(Products.ProductID)#" valuesdelimiter=",">
<cfgridcolumn name = "Quantity" header = "Quantity" width="70" headeralign="right"  dataalign="right">
<cfgridcolumn name = "UnitPrice" header = "Unit Price" width="80" headeralign="right"  dataalign="right">
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
<cfquery name="Transfer" datasource="#request.dsn#">
select TransferID, Creator, Transferdate
from Transfers
<cfif #GetUserRoles()# is "Administrator" OR #GetUserRoles()# is "Manager" OR #GetUserRoles()# is "Alpha">
  <cfelse>
WHERE Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob"> AND Transferdate >= <cfqueryparam value="#CreateODBCDate(request.clsDate)#" cfsqltype="cf_sql_date">
</cfif>
ORDER BY TransferID ASC
</cfquery>
<cfset Transfer=ValueList(Transfer.TransferID)>
<cfset validTransfers = #Listlen(Transfer)#>

<cfif #validTransfers# eq 0>

<h3>You have no Item to update. Please contact the administrator.</h3>
<cfabort>
</cfif>

<br>
<br>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="23%">
 <tr>
<td width="40%" align="right" >Transfer No:</td>
<td width="60%">
  <cfinput type="text" name="TransferID" required="yes" autosuggest="#Transfer#" autosuggestminlength="2" style="width:100%">
</td>
    </tr>
    <tr>
    <td colspan="2" align="right">     
        <cfinput type="submit" name="Search" value="Search">
</td>
    </tr>
  </table>
  </cfform>
</cfif>
</cfif>
</cfif>
</div>
</div>
</div>
</body>