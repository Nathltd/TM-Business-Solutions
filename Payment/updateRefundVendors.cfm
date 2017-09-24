<!doctype html>
<html>
<head>
<title><cfoutput>Refund Modification :: #request.title#</cfoutput></title>
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
<h4>Supplier's Refund Modification<cfif IsDefined("form.search") is True> for <cfoutput>#form.paymentDate#</cfoutput>
<cfset session.PaymentDate = #form.paymentDate#></cfif></h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant2'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'StockKeeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelse>

<p>
<cfif IsDefined("form.Update") is True>

<cftransaction>
<cfloop index = "counter" from = "1" to = #arraylen(Form.PaymentUpdate.rowstatus.action)#>
<cfif Form.PaymentUpdate.rowstatus.action[counter] is "I">
<cfquery>
INSERT into RefundVendors (AccountID,paymentID,paymentDate,Amount,vendorID,Creator) 
VALUES ('#form.PaymentUpdate.AccountId[counter]#','#form.PaymentUpdate.paymentID[counter]#',<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.paymentDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,'#Form.PaymentUpdate.Amount[counter]#','#Form.PaymentUpdate.vendorId[counter]#','#GetAuthUser()#')
</cfquery>
<cfelseif  Form.PaymentUpdate.rowstatus.action[counter]is "U">
<cfquery>
UPDATE refundvendors
SET
AccountId = '#trim(Form.PaymentUpdate.AccountId[counter])#',
paymentId = '#trim(Form.PaymentUpdate.paymentId[counter])#',
VendorID = '#trim(Form.PaymentUpdate.vendorId[counter])#',
Amount = '#trim(form.PaymentUpdate.Amount[counter])#',
Creator = '#GetAuthUser()#',
LastUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE paymentId = '#trim(Form.PaymentUpdate.Original.paymentId[counter])#'
</cfquery>
<cfelseif Form.PaymentUpdate.rowstatus.action[counter] is "D">
<cfquery>
DELETE from refundvendors
WHERE paymentId = '#trim(Form.PaymentUpdate.Original.paymentId[counter])#'
</cfquery>
</cfif>
</cfloop>
</cftransaction>

<p>
<cfoutput> Refund have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> New refund </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>

<cfset form.newDate = #dateformat(form.PaymentDate,"dd/mm/yyyy")#>
<cfif #DateDiff("d", "#dateformat(request.clsDate,"dd/mm/yyyy")#","#dateformat(form.newDate,"dd/mm/yyyy")#" )# lte 0>

<h3>Posting for <cfoutput>#dateformat(form.newDate,"dd-mmm-yyyy")#</cfoutput> not Allowed. Please contact the administrator.</h3>
<cfabort>
</cfif>


<cfquery name="Payments">
SELECT ID,paymentId,AccountID,type,paymentDate,Amount,vendorId,Creator
FROM refundvendors
WHERE paymentDate = <cfqueryparam value="#dateformat(form.PaymentDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Accountant1">
<cfelseif #GetUserRoles()# is "Alpha">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
</cfquery>


  <cfquery name="Supplier">
SELECT vendorId
FROM vendors
ORDER BY vendorId ASC 
  </cfquery>
  <cfquery name="paymentType">
SELECT paymentType FROM paymentType
order by paymentType
  </cfquery>
  

<div align="center">
<cfif #Payments.recordcount# eq 0>
<br />
There was no Refund on <cfoutput><strong> #form.PaymentDate#</strong> </cfoutput><br /><br />
Click <a href="?">here for another Refund Search</a>.

<cfelse>

<div>
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

  <div align="center">
  <table bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999" width="70%">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top">
<cfgrid name="PaymentUpdate"  query="Payments"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="80%" rowheaders="no">
<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center">
<cfgridcolumn name = "paymentId" header = "Payment ##" width="60" headeralign="center">
<cfgridcolumn name = "AccountID" header = "Account" width="100" headeralign="center" values="#ValueList(Accounts.AccountID)#" valuesdelimiter=",">
<cfgridcolumn name = "vendorId" header = "Supplier" width="120" headeralign="center" values="#ValueList(Supplier.vendorId)#" valuesdelimiter=",">
<cfgridcolumn name = "type" header = "Payment Type" width="120" headeralign="center" values="#ValueList(paymentType.paymentType)#" valuesdelimiter=",">
<cfgridcolumn name = "Amount" header = "Amount" width="80" headeralign="right"  dataalign="right">
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


<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table>
 <tr>
<td align="right" >Refund Date:</td>
<td align="right" >
  <div align="right">
  <cfinput type="datefield" class="bold_10pt_Date" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="PaymentDate" id="PaymentDate" tabindex="1" title="Expense Date" required="yes" message="Enter valid date"/>

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