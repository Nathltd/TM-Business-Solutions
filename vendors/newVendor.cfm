<!doctype html>
<html>
<head>
<title><cfoutput>New Supplier :: #request.title#</cfoutput></title>
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
<h4>New Supplier</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>
<cfif isdefined("form.submit")>
<cfquery>
INSERT INTO Vendors (Address, Company, email, VendorID, Phone, Creator, VendorType, OpeningBalance, dateUpdated)
VALUES (<cfqueryparam value="#form.address#" cfsqltype="cf_sql_char">, <cfqueryparam value="#form.company#" cfsqltype="cf_sql_char">, <cfqueryparam value="#form.Email#" cfsqltype="cf_sql_char">, <cfqueryparam value="#trim(form.Name)#" cfsqltype="cf_sql_char">,<cfqueryparam value="#form.Phone#" cfsqltype="cf_sql_char">, '#GetAuthUser()#', '#trim(form.VendorType)#', <cfqueryparam value="#trim(form.OpeningBal)#" cfsqltype="cf_sql_double">, <cfqueryparam value="#lsDateFormat(CreateODBCDate(form.opendate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date"> ) 
</cfquery>

<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.Name# </strong></font>has been created successfully <a href="newVendor.cfm">click here</a> to continue </cfoutput>

<cfelse>
<cfform action="newVendor.cfm" enctype="multipart/form-data">
<table cellpadding="5">
<tr>
<td width="50%" ><div align="right">Name:</div></td>
<td width="50%">
  <cfinput type="text" name="name" id="name" required="yes" message="Enter Supplier's Name" autosuggest="no">
</td>
</tr>
<tr>
<td><div align="right">Type:</div></td>
<td>
  <cfselect name="VendorType" id="VendorType" required="yes" message="Select Type">
  <option value="Supplier">Supplier</option>
  <option value="Expense">Expense</option>
  </cfselect>
</td>
</tr>
<tr>
<td><div align="right">Company:</div></td>
<td>
  <cfinput type="text" name="Company" id="Company" autosuggest="no">
</td>
</tr>
<tr>
<td><div align="right">Address:</div></td>
<td>
  <cftextarea name="Address" rows="3" id="Address"></cftextarea>
</td>
</tr>
<tr>
<td><div align="right">Phone:</div></td>
<td>
  <cfinput type="text" name="Phone" validate="integer" id="Phone" autosuggest="no">
</td>
</tr>
<tr>
<td><div align="right">Email:</div></td>
<td>
  <cfinput type="text" name="email" id="email" autosuggest="no" message="Enter a valid email">
</td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date">
</div></td>
</tr>
<tr>
<td><div align="right">Opening Balance:</div></td>
<td>
  <cfinput type="text" name="OpeningBal" validate="integer" autosuggest="no" id="OpeningBal" required="yes" message="Enter Opening Balance" style="text-align:right" placeholder="0">
</td>
</tr>
<tr>
<td></td>
<td align="right">
  <cfinput type="submit" name="submit" value="Create">
</td>
</tr>
</table>
</cfform>
</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html>