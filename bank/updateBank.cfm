<!doctype html>
<html>
<head>
<title><cfoutput>Bank Modification :: #request.title#</cfoutput></title>
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
<h4>Bank Modification</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.Update" default="">
<cfparam name="form.BankID" default="">
<cfparam name="form.BankID2" default="">
<cfparam name="form.search" default="">

<cfquery name="getBank">
SELECT AccountID
FROM Accounts
WHERE AccountType <> <cfqueryparam value='Rebate' cfsqltype="cf_sql_clob">
ORDER BY AccountID ASC
</cfquery>

<cfif isdefined(#form.Update#)>

<cftransaction>
<cfquery>
UPDATE Accounts
SET AccountID = '#Trim(form.BankID2)#',
    AccountName = '#Trim(form.AccountName)#',
    AccountNumber = '#Trim(form.AccountNumber)#',
    OpeningBalance = '#Trim(form.OpeningBalance)#',
    Creator = '#GetAuthUser()#',
    Description = '#Trim(form.Description)#',
    dateUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(form.openDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
    LastModified = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE AccountID='#form.BankID#'
</cfquery>
</cftransaction>
<p>
 <cfoutput>#form.BankID2#</cfoutput> Has been updated. Click <a href="updateBank.cfm">here to update</a> another Bank.
 </p>
<cfelseif isdefined (#form.search#)>
<cfquery name="getBank">
SELECT AccountID, AccountType, AccountName, AccountNumber, OpeningBalance, Description, dateUpdated
FROM Accounts
WHERE AccountID = <cfqueryparam value='#form.BankID#' cfsqltype="cf_sql_clob"> AND AccountType <> <cfqueryparam value='Rebate' cfsqltype="cf_sql_clob">
</cfquery>
<cfquery name="getAccountType">
SELECT AccountType
FROM AccountType
WHERE AccountType <> 'Rebate'
</cfquery>
 
<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<br>

<table cellpadding="5" class="font1">
<tr>
<td height="24"><div align="right">Bank Name:</div></td>
<td><div align="left">
  <cfinput type="text" name="BankID2" id="BankID2" value="#Trim(getBank.AccountID)#"  class="bold_10pt_black" >
  <cfinput name="BankID" id="BankID" type="hidden" value="#Trim(getBank.AccountID)#">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Bank Type:</div></td>
<td><div align="left">
  <cfselect  name="AccountType"  class="bold_10pt_black">
  <cfoutput query="getAccountType">
      <option value="#Trim(AccountType)#" <cfif getAccountType.AccountType is getBank.AccountType>
    selected </cfif>>#AccountType#
        </option>
      </cfoutput>
      </cfselect>
  </div></td>
</tr>
<tr>
<td height="24"><div align="right">Account Name:</div></td>
<td><div align="left">
  <cfinput type="text" name="AccountName" id="AccountName" value="#Trim(getBank.AccountName)#"  class="bold_10pt_black">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Account No.:</div></td>
<td><div align="left">
  <cfinput type="text" name="AccountNumber" message="Enter a Valid Bank Account Number" validate="integer" id="AccountNo" maxlength="10" value="#Trim(getBank.AccountNumber)#" >
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date" value="#dateformat(getBank.dateUpdated,"mm/dd/yyyy")#">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Balance:</div></td>
<td><div align="left">
  <cfinput type="text" name="OpeningBalance" id="OpeningBalance" class="bold_10pt_black" validate="float" required="yes" message="Enter Valid Number" value="#Trim(getBank.OpeningBalance)#">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Description:</div></td>
<td><div align="left">
  <cfinput type="text" name="Description" id="Description"  value="#Trim(getBank.Description)#" class="bold_10pt_black">
</div></td>
</tr>

<tr>
<td height="26" colspan="2" align="right"><div align="right">
  <cfinput type="Submit" name="Update" value="Update" class="bold_10pt_Button">
</div></td>
</tr>
</table>
</cfform>
<cfelse>
<strong>Select Bank to Update</strong>
<br>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5" class="font1">
<tr>
<td><div align="right">Bank Name:</div></td>
<td><div align="left">
  <cfselect name="BankID" bind="cfc:#request.cfc#cfc.bind.getAllBankAccounts()" display="AccountID" value="AccountID" bindonload="yes" class="bold_10pt_black">
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td></td>
    <td align="right"><div align="right">
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