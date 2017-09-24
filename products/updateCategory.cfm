<!doctype html>
<html>
<head>
<title><cfoutput>Product Category Modification :: #request.title#</cfoutput></title>
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
<h4>Product Category Modification</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<p>
<cfparam name="form.Update" default="">
<cfparam name="form.Category" default="">
<cfparam name="form.Category2" default="">
<cfparam name="form.search" default="">

<cfif isdefined (#form.update#)>
<cftransaction>
<cfquery datasource="#request.dsn#">
UPDATE InventoryCategory
SET CategoryID = '#Trim(form.Category2)#',
	Creator = '#GetAuthUser()#',
    Description = '#Trim(form.Description)#',
    UpdateDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE">
WHERE CategoryID='#Trim(form.Category)#'
</cfquery>
</cftransaction>

 <cfoutput>#form.Category2#</cfoutput> Has been updated. Click <a href="">here to update</a> another item

<cfelseif isdefined (#form.search#)>
<cfquery name="getCategory" datasource="#request.dsn#">
SELECT CategoryID,Description,Creator
FROM InventoryCategory
WHERE CategoryID = <cfqueryparam value="#Trim(form.CategoryID)#" cfsqltype="cf_sql_clob"> 
</cfquery>

<div class="font1">

<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellspacing="5" class="font1">
<tr>
<td><div align="right">Category Name:</div></td>
<td><div align="left">
  <cfinput name="Category2" id="Category2" value="#Trim(getCategory.CategoryID)#" autocomplete="off" style="width:100%">
    <cfinput name="Category" id="Category" type="hidden" value="#Trim(getCategory.CategoryID)#">
</div></td>
</tr>
<tr>
<td><div align="right">Description:</div></td>
<td><div align="left">
  <cfinput name="Description" id="Description" value="#Trim(getCategory.Description)#" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
  <td colspan="2" align="right"><div align="right">
    <cfinput name="Update" type="submit" value="Update" class="bold_10pt_Button">
  </div></td>
</table>
</cfform>
</div>
<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5">
<tr>
<td><div align="right">Category Name:</div></td>
<td><div align="left">
  <cfselect name="CategoryID" class="bold_10pt_black" bind="cfc:#request.cfc#cfc.bind.getProductCategory()" display="CategoryID" value="CategoryID" bindonload="yes" style="width:100%">
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td colspan="2" align="right"><div align="right">
      <cfinput type="submit" name="Search" value="Search">
    </div></td>
    </tr>
  </table>  
  </cfform>
</cfif>
</cfif>
</p>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>