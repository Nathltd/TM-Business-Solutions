<!doctype html>
<html>
<head>
<title><cfoutput>New Customer ::: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDupl.js" language="javascript" type="application/javascript"></script>

</head>


<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>New Customer</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif isdefined("form.submit")>
<cfquery name="InsertProduct">
INSERT INTO Customers (Address, Company, customerEmail,CustomerID,customerPhone,OpeningBalance,Creator, dateUpdated, CurrentDate, creditLimit)
VALUES (<cfqueryparam value="#form.Address#" cfsqltype="cf_sql_char">, <cfqueryparam value="#form.Company#" cfsqltype="cf_sql_char">, <cfqueryparam value="#form.customerEmail#" cfsqltype="cf_sql_char">,<cfqueryparam value="#trim(form.CustomerName)#" cfsqltype="cf_sql_char">,<cfqueryparam value="#form.customerPhone#" cfsqltype="cf_sql_char">, <cfqueryparam value="#trim(form.OpeningBalance)#" cfsqltype="cf_sql_double">,<cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_char">,<cfqueryparam value="#lsDateFormat(CreateODBCDate(form.opendate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,<cfqueryparam value="#form.creditLimit#" cfsqltype="cf_sql_double">) 
</cfquery>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.CustomerName# </strong></font>has been created successfully <a href="newCustomer.cfm">click here</a> to continue </cfoutput>
</div>
<cfelse>
<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellpadding="5">
<tr>
<td><div align="right">Customer Name:</div></td>
<td><div align="left">
  <cfinput type="text" name="CustomerName" id="CustomerName" style="width:100%" required="yes" message="Enter Customer Name" autocomplete="off">
<span id="msg">&nbsp;Customer Already exist</span></div></td>
</tr>
<tr>
<td ><div align="right">Company:</div></td>
<td><div align="left" id="vendorCompany" name="vendorCompany">
  <cfinput type="text" name="Company" id="Company" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
<td height="24" valign="top"><div align="right">Address:</div></td>
<td><div align="left">
  <cftextarea name="Address" rows="2" id="Address" style="width:100%"></cftextarea>
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Phone:</div></td>
<td><div align="left">
  <cfinput type="text" name="customerPhone" validate="integer" id="customerPhone" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Email:</div></td>
<td><div align="left">
  <cfinput type="text" name="customerEmail" id="customerEmail" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Credit Limit:</div></td>
<td><div align="left">
  <cfinput type="text" name="creditLimit" validate="integer" id="creditLimit" style="width:100%;text-align:right" required="yes" autocomplete="off" placeholder="0">
</div></td>
</tr>
<td height="24"><div align="right">Opening Balance:</div></td>
<td><div align="left">
  <cfinput type="text" name="OpeningBalance" validate="integer" id="OpeningBalance" style="width:100%;text-align:right" required="yes" autocomplete="off" placeholder="0">
</div></td>
</tr>
<tr>
<td></td>
<td height="26" align="right"><div align="right">
  <cfinput type="submit" name="submit" id="submit" value="Create">
</div></td>
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