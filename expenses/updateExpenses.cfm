<!doctype html>
<html>
<head>
<title><cfoutput>Expense Modification :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../style.js"></script>
</head>


<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Expense Modification<cfif IsDefined("form.search") is True> for <cfoutput>#form.paymentDate#</cfoutput>
<cfset session.PaymentDate = #form.paymentDate#></cfif></h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Stock Keeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<p>
<cfif IsDefined("form.Update") is True>

<cftransaction>
<cfloop index = "counter" from = "1" to = #arraylen(Form.PaymentUpdate.rowstatus.action)#>
<cfif Form.PaymentUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertExpenseUpdate">
INSERT into Expenses (Ref,ExpenseDate,Amount,VendorID,ExpenseID,AccountID,Details,Creator,LastUpdate) 
VALUES ('#form.PaymentUpdate.Ref[counter]#',<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.paymentDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,'#Form.PaymentUpdate.Amount[counter]#','#Form.PaymentUpdate.VendorID[counter]#','#Form.PaymentUpdate.ExpenseID[counter]#','#Form.PaymentUpdate.AccountID[counter]#','#Form.PaymentUpdate.Details[counter]#','#GetAuthUser()#',<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">)
</cfquery>
<cfelseif  Form.PaymentUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdatePaymentUpdate">
UPDATE Expenses
SET
Ref = '#trim(Form.PaymentUpdate.Ref[counter])#',
ExpenseDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(session.paymentDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
VendorID = '#trim(Form.PaymentUpdate.VendorID[counter])#',
ExpenseID = '#trim(form.PaymentUpdate.ExpenseID[counter])#',
AccountID = '#trim(form.PaymentUpdate.AccountID[counter])#',
Amount = '#trim(form.PaymentUpdate.Amount[counter])#',
Details = '#trim(form.PaymentUpdate.Details[counter])#',
Creator = '#GetAuthUser()#',
LastUpdate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE ID = #trim(Form.PaymentUpdate.ID[counter])#
</cfquery>
<cfelseif Form.PaymentUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeletePaymentUpdate">
DELETE from Expenses
WHERE ID = #trim(Form.PaymentUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
</cftransaction>

<p>
<cfoutput> Expenses have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> New Expense </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>

<cfset form.newDate = #dateformat(form.PaymentDate,"dd/mm/yyyy")#>
<cfif #DateDiff("d", "#dateformat(request.clsDate,"dd/mm/yyyy")#","#dateformat(form.newDate,"dd/mm/yyyy")#" )# lte 0>

<h3>Posting for <cfoutput>#dateformat(form.newDate,"dd-mmm-yyyy")#</cfoutput> not Allowed. Please contact the administrator.</h3>
<cfabort>
</cfif>


<cfquery name="Payments">
SELECT ID,Ref,ExpenseDate,Amount,VendorID,ExpenseID,AccountID,Details,Creator
FROM Expenses
WHERE ExpenseDate = <cfqueryparam value="#dateformat(form.PaymentDate,"dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE">

<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Accountant1">
<cfelseif #GetUserRoles()# is "Alpha">
<cfelseif #GetUserRoles()# is "Manager">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>


  <cfquery name="Vendor">
SELECT VendorID
FROM Vendors
WHERE VendorType = 'Expense'
ORDER BY VendorID ASC 
  </cfquery>
  
    <cfquery name="ExpenseType">
SELECT AccountID FROM ExpenseAccount
where typeId = 0
ORDER BY AccountID
  </cfquery>

<div align="center">
<cfif #Payments.recordcount# eq 0>
<br />
There was no Expense on <cfoutput><strong> #form.PaymentDate#</strong> </cfoutput><br /><br />
Click <a href="?">here for another Expense Search</a>.

<cfelse>

<div>
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

  <div align="center">
  <table bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top"><cfgrid name="PaymentUpdate"  query="Payments"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="700" height="300" rowheaders="no">
<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "Ref" header = "Ref ##" width="90" headeralign="center">
<cfgridcolumn name = "VendorID" header = "Supplier" width="100" headeralign="center" values="#ValueList(Vendor.VendorID)#" valuesdelimiter=",">
<cfgridcolumn name = "AccountID" header = "Account" width="100" headeralign="center" values="#ValueList(Accounts.AccountID)#" valuesdelimiter=",">
<cfgridcolumn name = "ExpenseID" header = "Type" width="120" headeralign="right" values="#ValueList(ExpenseType.AccountID)#" valuesdelimiter=",">
<cfgridcolumn name = "Details" header = "Details" width="120" headeralign="center">
<cfgridcolumn name = "Amount" header = "Amount" width="100" headeralign="right"  dataalign="right">
</cfgrid>  <br></td>
<td width="56" valign="bottom">
    <cfinput type="submit" name="Update" value="Update" class="bold_10pt_button">
  </td>
</tr>
</thead>
  </table>
</div>

</cfform>
</cfoutput>
</div>
</cfif>
</div>
<cfelse>

<br />

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table>
 <tr>
<td align="right" >Expense Date:</td>
<td align="right" >
  <div align="right">
  <cfinput type="datefield" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="PaymentDate" id="PaymentDate" tabindex="1" title="Expense Date" required="yes" message="Enter valid date"/>

  </div>
</td>
    </tr>
    <tr>
    <td></td>
    <td align="right">
      <div align="right">
        <cfinput type="submit" name="Search" value="Search" class="bold_10pt_button">
      </div></td>
    </tr>
  </table>
  </cfform>
</cfif>
</cfif>
</p>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>