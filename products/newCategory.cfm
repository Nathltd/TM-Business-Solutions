<!doctype html>
<html>
<head>
<title><cfoutput>New Product Category :: #request.title#</cfoutput></title>
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
<h4>New Product Category</h4>

<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif isdefined("form.submit")>
<cfquery name="InsertProduct" datasource="#request.dsn#">
INSERT INTO InventoryCategory (CategoryID, Description, Creator, UpdateDate)
VALUES ('#form.CategoryID#', '#form.Description#', '#GetAuthUser()#', 
<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE">) 
</cfquery>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.CategoryID# </strong></font>has been created successfully as a Product Category <a href="newCategory.cfm"> click here</a> to continue </cfoutput>
</div>
<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table cellpadding="5" class="font1">
<tr>
  <td height="24"><div align="left">Name:</div></td>
  <td><cfinput type="text" name="CategoryID" id="CategoryID" required="yes" message="Enter A Product Name" autocomplete="off" autofocus></td>
</tr>
<tr>
  <td height="24"><div align="left">Description:</div></td>
  <td><cfinput type="text" name="Description" message="Enter A Description" required="yes" id="Description" autocomplete="off"></td>
</tr>
<tr>
  <td height="26" colspan="2" align="right"><div align="right">
    <cfinput type="submit" name="submit" value="Create">
  </div></td>
</tr>
</table>
</cfform>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>