<!doctype html>
<html>
<head>
<title><cfoutput>New Bank :: #request.title#</cfoutput></title>
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
<h4>New Bank</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>
<cfif isdefined("form.submit")>
<cftransaction>
<cfquery>
INSERT INTO Accounts (AccountID, AccountType, AccountName, AccountNumber, OpeningBalance, Description, Creator,DateUpdated, lastModified)
VALUES ('#trim(form.BankID)#', '#trim(form.AccountType)#', '#form.AccountName#', '#form.AccountNumber#', '#form.OpeningBalance#', '#form.Description#', '#GetAuthUser()#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(form.openDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">) 
</cfquery>
</cftransaction>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.BankID# </strong></font>has been created successfully <a href="newBank.cfm">click here</a> to continue </cfoutput>
</div>
<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<br>

<table cellpadding="5">
<tr>
<td height="24"><div align="right">Bank Name:</div></td>
<td><div align="left">
  <cfinput type="text" name="BankID" id="BankID" required="yes" message="Enter Bank Name"  autosuggest="no">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Bank Type:</div></td>
<td><div align="left">
  <cfselect enabled="Yes" name="AccountType" required="yes" bind="cfc:#request.cfc#cfc.bind.getAccountType()" display="AccountType" value="AccountType" bindonload="yes">      
  </cfselect>
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Account Name:</div></td>
<td><div align="left">
  <cfinput type="text" name="AccountName" id="AccountName"  class="bold_10pt_date" autosuggest="no">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Account No.:</div></td>
<td><div align="left">
  <cfinput type="text" name="AccountNumber" validate="integer" id="AccountNo" maxlength="10"  class="bold_10pt_date" autosuggest="no" required="yes" message="Enter Account Number">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Description:</div></td>
<td><div align="left">
  <cfinput type="text" name="Description" id="Description"  autosuggest="no">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Balance:</div></td>
<td><div align="left">
  <cfinput type="text" name="OpeningBalance" id="OpeningBalance" validate="integer" message="Enter Opening Balance" style="text-align:right" autosuggest="no" required="yes">
</div></td>
</tr>

<tr>
<td></td>
<td height="26" align="right"><div align="right">
  <cfinput type="submit" name="submit" value="Create">
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