<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>

</head>


<body>


<div align="center">
<div id="Content">
<h4>New Product Category</h4>

<div id="RightColumn">

<cfif isdefined("form.submit")>
<cftransaction>
<cfquery name="InsertProduct">
INSERT INTO InventoryCategory (CategoryID, Description, Creator, UpdateDate)
VALUES ('#form.CategoryID#', '#form.Description#', 'nathconcept', '#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#') 
</cfquery>
<cfquery>
delete from inventoryCategory
where categoryId = '#form.CategoryID#'
</cfquery>
</cftransaction>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.CategoryID# </strong></font>has been created successfully as a Product Category </cfoutput>
</div>
<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table cellpadding="5" class="font1">
<tr>
  <td height="24"><div align="left">Name:</div></td>
  <td><cfinput type="text" name="CategoryID" id="CategoryID" size="10" required="yes" class="bold_10pt_black" message="Enter A Product Name" autocomplete="off"></td>
</tr>
<tr>
  <td height="24"><div align="left">Description:</div></td>
  <td><cfinput type="text" name="Description" message="Enter A Description" required="yes" class="bold_10pt_black" id="Description" size="10" autocomplete="off"></td>
</tr>
<tr>
  <td height="26" colspan="2" align="right"><div align="right">
    <cfinput type="submit" name="submit" value="Create">
  </div></td>
</tr>
</table>
</cfform>
</cfif>
</div>
</div>
</div>
</body>
</html>