<!doctype html>
<html>
<head>
<title><cfoutput>Expense Account Modification :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Expense Account Modification</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Stock Keeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<p>
<cfparam name="form.Update" default="">
<cfparam name="form.AccountID" default="">
<cfparam name="form.AccountID2" default="">
<cfparam name="form.search" default="">

<cfif isdefined(#form.Update#)>

<cftransaction>
<cfquery>
UPDATE expenseAccount
SET AccountID = '#Trim(form.AccountID2)#',
    Creator = '#GetAuthUser()#',
    Description = '#Trim(form.Description)#',
    DateUpdate = <cfqueryparam value="#dateformat(form.opendate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE AccountID='#form.AccountID#'
</cfquery>
</cftransaction>

 <cfoutput>#form.AccountID2#</cfoutput> Has been updated. Click <a href="updateExpenseAcct.cfm">here to update</a> another Account.
 
<cfelseif isdefined (#form.search#)>
<cfquery name="getAccount">
SELECT AccountID, Description, dateUpdate
FROM ExpenseAccount
WHERE AccountID = <cfqueryparam value="#form.AccountID#" cfsqltype="cf_sql_clob"> 
</cfquery>
 
<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellpadding="2" >
<tr>
<td><div align="right">Account Name:</div></td>
<td><div align="left">
  <cfinput type="text" name="AccountID2" id="AccountID2" value="#Trim(getAccount.AccountID)#">
  <cfinput name="AccountID" id="AccountID" type="hidden" value="#Trim(getAccount.AccountID)#">
</div></td>
</tr>
<tr>
  <td><div align="right">Description:</div></td>
  <td><div align="left">
    <cfinput type="text" name="Description" id="Description"  value="#Trim(getAccount.Description)#">
  </div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date" value="#dateformat(getAccount.dateUpdate,"mm/dd/yyyy")#">
</div></td>
</tr>
<tr>
<td></td>
<td align="right"><div align="right">
  <cfinput type="Submit" name="Update" class="bold_10pt_black" value="Update">
</div></td>
</tr>
</table>
</cfform>
<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="2">
<tr>
<td><div align="right">Expense Account:</div></td>
<td><div align="left">
  <cfselect name="AccountID" bind="cfc:#request.cfc#cfc.bind.getExpenseAccounts()" display="AccountID" value="AccountID" bindonload="yes" class="bold_10pt_item">
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td></td>
    <td align="right"><div align="right">
      <cfinput type="submit" name="Search" class="bold_10pt_Button" value="Search">
    </div></td>
    </tr>
  </table>
  </cfform>
  </cfif>
  </p>
  </cfif>
  </div>
  </div>
  </div>
  </body>
  </html>