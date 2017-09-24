<!doctype html>
<html>
<head>
<title><cfoutput>Refund from (Suppliers) :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDupV.js" type="application/javascript"></script>

</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Refund from Suppliers</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Procurement'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant2'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Manager'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="url.Sales" default="">
<cfif url.Sales is "yes">

<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'VendorID')>
<cfset structdelete(session, 'expenseDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'ExpenseID')>
<cfset structdelete(session, 'details')>
<cfset structdelete(session, 'amount')>

 <cftransaction>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery>
INSERT INTO refundVendors
(AccountID,VendorID,PaymentDate,PaymentID,Type,amount,Creator)
VALUES ('#session.myInvoice[variables.counter].AccountID#', '#session.myInvoice[variables.counter].VendorID#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.myInvoice[variables.counter].expenseDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,  '#session.myInvoice[variables.counter].ref#', '#session.myInvoice[variables.counter].expenseID#', '#session.myInvoice[variables.counter].amount#','#GetAuthUser()#')
</cfquery>
</cfloop>
</cftransaction>

<p>
<cfoutput> Refunds have been posted successfully <a href="#cgi.SCRIPT_NAME#"> New Posting</a></cfoutput>
</p>

<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmount" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmountSum" default="">
<cfparam name="form.AmountPaid" default="">
<cfparam name="session.AmountPaid" default="form.AmountPaid">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.AccountID" default="">
<cfparam name="url.reset" default="">

<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].AccountID = #form.AccountID#>
<cfset session.myInvoice[position].VendorID = #form.SupplierID#>
<cfset session.myInvoice[position].expenseDate = #form.expenseDate#>
<cfset session.myInvoice[position].ref = #form.ref#>
<cfset session.myInvoice[position].Amount = #form.Amount#>
<cfset session.myInvoice[position].ExpenseID = #form.ExpenseID#>
<cfset session.myInvoice[position].Details = #form.Details#>
<cfset session.totalAmountSum = #form.totalAmount#>
<cfset todayDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset session.todate = #todayDate#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'VendorID')>
<cfset structdelete(session, 'expenseDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'Amount')>
<cfset structdelete(session, 'ExpenseID')>
<cfset structdelete(session, 'Details')>
<cfset structdelete(session, 'totalAmountSum')>
</cfif>



<div align="center">

<div align="center">
<cfoutput>

<br>

<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center"></div>
  <div align="center">
  <table width="90%" bgcolor="##D5EAFF" border="0" cellpadding="3" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td width="18%"><div align="left"><strong>Account</strong></div></td>
<td width="17%"><div align="left"><strong>Supplier</strong></div></td>
<td width="20%"> <div align="left"><strong>Date</strong></div></td>
<td width="10%"> <div align="left"><strong>Ref. ##</strong></div></td>
<td width="15%"> <div align="left"><strong> Type</strong></div></td>
<td width="10%"> <div align="left"><strong>Supplier Balance</strong></div></td>
<td width="10%"> <strong>Amount</strong></td>
<td width="10%">&nbsp;</td>
</tr>
</thead>
<tbody>

<tr>

<td><cfselect name="AccountID" id="AccountID" required="yes" bind="cfc:#request.cfc#cfc.bind.getAllBankAccounts()" display="AccountID" value="AccountID" tabindex="1" bindonload="yes"  style="width:100%" > </cfselect></td>
            <td><cfselect name="SupplierID" id="SupplierID" required="yes" bind="cfc:#request.cfc#cfc.bind.Suppliers()" display="VendorID" value="VendorID" bindonload="yes"  tabindex="2" style="width:100%" > </cfselect></td>

<td>
<cfinput type="datefield" mask="dd/mm/yyyy" value="#lsdateformat(now(),"mm/dd/yyyy")#" name="expenseDate" id="expenseDate" tabindex="3" title="Payment Date" required="yes" message="Enter valid Date"/>

</td>
<td> <cfinput type="text" name="ref" validate="integer" message="Enter Cheque/Ref No., Figures only." required="yes" id="ref" style="text-align:right;width:100%" tabindex="4" autocomplete="off">
	<span id="msg">&nbsp;Ref ## Already exist</span> </td>
<td><cfselect name="ExpenseID" id="ExpenseID" required="yes"  message="Select Type" tabindex="5">
	<option value="Cash">Cash</option>
    <option value="Cheque">Cheque</option>
    </cfselect></td>
<td> <cfinput name="Details" id="Details" type="text" readonly="true" bind="cfc:#request.cfc#cfc.bind.VendorBalance({SupplierID})" bindonload="yes" tabindex="6" style="text-align:right"> </td>
<td align="center"> <div align="right">
  <cfinput type="text" name="Amount" validate="float" tabindex="7" style="text-align:right" required="yes" message="Enter Amount Paid" autocomplete="off">
</div></td>

<td align="center" valign="bottom">  <cfinput type="submit" name="addInvoice" id="addInvoice"value="Add" tabindex="8"></td>

</tr>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left" valign="top"> <div align="left">#session.myInvoice[variables.counter].AccountID# </div></td>
<td align="left" valign="top"> <div align="left">#session.myInvoice[variables.counter].VendorID# </div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].expenseDate# </div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].ref#</div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].ExpenseID#</div></td>
<td align="right" valign="top"> <div align="right">&nbsp;</div></td>
<td align="right" valign="top"><div align="right"> #LSNumberFormat(session.myInvoice[variables.counter].Amount,',999999999999999999.99')#</div> </td>
</tr>
</cfloop> 
<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.totalAmount,#form.Amount#)>
<cfset position = arraylen(session.totalAmount)>
<cfset session.totalAmount[position] = #form.Amount#>
</cfif>
<cfset Amount = #arraySum(session.totalAmount)#>
<cfset session.Amount = #Amount#>
<tr>
  <td colspan="6" align="right"><div align="right"><strong>Total:&nbsp;</strong></div></td>
  <td align="right"><div align="right">
   <strong>#LSNumberFormat(Amount,',99999999.99')#</strong>
    <cfinput type="hidden" name="totalAmount" id="totalAmount" class="stnd_10pt_style"  validate="float" value="#Amount#" style="text-align:right">
  </div></td>
  <td align="center"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##FF0000"><strong>Reset</strong></font></a>&nbsp;<a href="#cgi.SCRIPT_NAME#?sales=yes"><font color="##000000"><strong>Post</strong></font></a></td>
</tr>
</tbody>
</table>
</div>
<cfif url.reset is "1">
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'VendorID')>
<cfset structdelete(session, 'expenseDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'ExpenseID')>
<cfset structdelete(session, 'details')>
<cfset structdelete(session, 'amount')>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>
</cfif>

</cfform></cfoutput>
</div></div>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>