<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>


<body>
<cfquery name="getBranch" datasource="#request.dsn#">
select BranchID
from Branches
</cfquery>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Opening Balance Modification</h4>

<div id="RightColumn">
<cfif IsDefined("form.Update") is True>
<cfloop index = "counter" from = "1" to = #arraylen(Form.OBgrid.rowstatus.action)#>
<cfif Form.OBgrid.rowstatus.action[counter] is "I">
<cfquery name="InsertOB">
INSERT into OpeningBalance (OpNo,ProductID,Qty,CostPrice,BranchID,OpeningDate,LastUpdated,Creator) 
                VALUES ('#session.OpNo#','#Form.OBgrid.ProductID[counter]#','#Form.OBgrid.Qty[counter]#','#Form.OBgrid.CostPrice[counter]#','#session.BranchID#','#dateformat(request.StartYear,"dd/mm/yyyy")#','#dateformat(now())#','#GetAuthUser()#')
</cfquery>

<cfelseif  Form.OBgrid.rowstatus.action[counter]is "U">
<cfquery name="UpdateOB">
UPDATE OpeningBalance
SET
ProductID = '#trim(Form.OBgrid.ProductID[counter])#',
Qty = '#trim(Form.OBgrid.Qty[counter])#',
CostPrice = '#trim(Form.OBgrid.CostPrice[counter])#',
OpeningDate = '#dateformat(request.StartYear)#',
LastUpdated = '#dateformat(now(),"dd/mm/yyyy")#',
Creator = '#GetAuthUser()#'
WHERE ID = #trim(Form.OBgrid.ID[counter])#
</cfquery>
<cfelseif Form.OBgrid.rowstatus.action[counter] is "D">
<cfquery name="DeleteOB">
DELETE from OpeningBalance
WHERE ID = #trim(Form.OBgrid.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
<p>     
<cfoutput>Openning Balance for <strong>#session.BranchID#</strong> have been Updated successfully.
<br>
<br />
Click here to Edit another <a href="../OpeningBalance/updateOpeningBalance.cfm">  Opening Balance </a></cfoutput>
</p>
<cfelse>

<cfif isdefined ("form.search")>
<cfquery name="getBranch" datasource="#request.dsn#">
select BranchID
from Branches
</cfquery>


<cfparam name="session.OPdate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchID" default="">
<cfif isdefined("form.search") is true>
<cfset session.BranchID = "#form.BranchID#">
</cfif>


<cfquery name="OPdetails" datasource="#request.dsn#">
SELECT ID,OpNo,BranchID,OpeningDate,ProductID,Qty, CostPrice, Creator
FROM OpeningBalance
WHERE BranchID = <cfqueryparam value="#Trim(form.BranchID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelse>
 AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
 </cfif>
</cfquery>
<cfquery name="Products" datasource="#request.dsn#">
SELECT ProductID
FROM Inventory
ORDER BY ProductID ASC
</cfquery>


<cfoutput><strong>#OPdetails.recordcount# Records Available for #Trim(form.BranchID)#</strong> </cfoutput><a href="../OpeningBalance/PrntUpdateOBDisplay.cfm"> Print </a>
<br />
<br />
<cfset session.OpNo = "#OPdetails.OpNo#">
<cfset session.OpeningDate = "#OPdetails.OpeningDate#">
<cfset session.BranchID = "#OPdetails.BranchID#">

<cfform action="#cgi.Script_Name#">
<table>
<tr>
<td>
<cfgrid name="OBgrid" width="380"query="OPdetails" insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes"
font = "Tahoma" selectcolor="##949494" selectmode = "Edit" >

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center">
<cfgridcolumn name = "ProductID" header = "Products" width="160" headeralign="center" values="#ValueList(Products.ProductID)#">
<cfgridcolumn name = "Qty" header = "Quantity" width="80" headeralign="center"  dataalign="right">
<cfgridcolumn name = "CostPrice" header = "Cost Price" width="80" headeralign="center"  dataalign="right">
</cfgrid>
</td>
</tr>
<tr>
<td align="right"><div align="right">
<cfinput type="submit" name="Update" value="Update"></div>
</td>
</tr>
</table>
</cfform>


<cfelse>
<p> Select Branch to Modify </p>
<cfform action="#cgi.Script_Name#" enctype="multipart/form-data">
<table width="30%">
 <tr>
<td width="40%"><div align="right">Branch Name:</div></td>
<td ><div align="left">
  <cfselect name="BranchID" required="yes" message="Choose a Branch" style="width:100%">
        <cfoutput query="getBranch">
      <option value="#Trim(BranchID)#">#Trim(BranchID)#</option>
      </cfoutput>
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td align="right"></td>
    <td align="right"><div >
      <cfinput type="submit" name="Search" value="Search">
    </div></td>
    
    </tr>
  </table>
    </div>

  </cfform>
</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html>