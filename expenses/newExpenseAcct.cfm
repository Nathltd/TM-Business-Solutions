<!doctype html>
<html>
<head>
<title><cfoutput>Expenses Account  :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDupl.js" language="javascript" type="application/javascript"></script>
</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4><strong>New Expense Account</strong></h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is 'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif isdefined("form.submit")>
<cftransaction>
<cfquery>
INSERT INTO ExpenseAccount (AccountID, Description, Creator, DateUpdate, branchid)
VALUES ('#form.AccountID#','#form.Description#', '#GetAuthUser()#',<cfqueryparam value="#dateformat(form.openDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_timestamp">, '#session.001BranchID#') 
</cfquery>
</cftransaction>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.AccountID# </strong></font>has been created successfully <a href="#cgi.SCRIPT_NAME#">click here</a> to continue </cfoutput>
</div>
<cfelse>

<cfform action="newExpenseAcct.cfm" enctype="multipart/form-data">
<br>

<table cellpadding="5" class="font1">
<tr>
<td height="24"><div align="right">Account Name:</div></td>
<td><div align="left">
  <cfinput type="text" name="accountId" id="accountId" required="yes" message="Enter Account Name">
  <span id="msg">&nbsp;Account Already exist</span>
</div></td>
</tr>
<tr>
  <td height="24"><div align="right">Description:</div></td>
  <td><div align="left">
    <cfinput type="text" name="Description" id="Description"  required="yes" message="Enter Description">
  </div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date">
</div></td>
</tr>

<tr>
<td></td>
<td align="right"><div align="right">
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