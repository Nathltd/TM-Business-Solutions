<!doctype html>
<html>
<head>
<title><cfoutput>Expenses  :: #request.title#</cfoutput></title>
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
<h4>Expenses</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Accountant'>
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
<cfset structdelete(session, 'todate')>

 <cftransaction>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery>
INSERT INTO Expenses
(AccountID,VendorID,expenseDate,ref,ExpenseID,details,amount,Creator)
VALUES ('#session.myInvoice[variables.counter].AccountID#', '#session.myInvoice[variables.counter].VendorID#',
'#lsDateFormat(CreateODBCDate(session.myInvoice[variables.counter].expenseDate), "dd/mm/yyyy")#',  '#session.myInvoice[variables.counter].ref#', '#session.myInvoice[variables.counter].expenseID#', '#session.myInvoice[variables.counter].details#', '#session.myInvoice[variables.counter].amount#','#GetAuthUser()#')
</cfquery>
</cfloop>
</cftransaction>
<br />
<br />

<cfoutput> Expenses have been posted successfully<a href="expenses.cfm"> New Posting</a></cfoutput><br>
<br>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'VendorID')>
<cfset structdelete(session, 'expenseDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'ExpenseID')>
<cfset structdelete(session, 'details')>
<cfset structdelete(session, 'amount')>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>

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
<cfset session.myInvoice[position].VendorID = #form.VendorID#>
<cfset session.myInvoice[position].expenseDate = #form.expenseDate#>
<cfset session.myInvoice[position].ref = #form.ref#>
<cfset session.myInvoice[position].Amount = #form.Amount#>
<cfset session.myInvoice[position].ExpenseID = #form.ExpenseID#>
<cfset session.myInvoice[position].Details = #form.Details#>
<cfset session.totalAmountSum = #form.totalAmount#>
<cfset todayDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset session.todate = #todayDate#>
<!--- Remove items from invoice list --->
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.myInvoice#,#url.id#)#>

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
<br />

<div align="center">
<cfoutput>


<cfform action="Expenses.cfm" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center"></div>
  <div align="center">
  <table width="90%" cellpadding="3" cellspacing="0">
<thead>
<tr align="center">
<td align="center" width="15%"><div align="left"><strong>Account</strong></div></td>
<td width="15%"><div align="left"><strong>Vendor</strong></div></td>
<td align="center" width="17%"> <div align="left"><strong>Date</strong></div></td>
<td align="center" width="8%"> <div align="left"><strong>Ref.</strong></div></td>
<td align="center" width="10%"> <div align="left"><strong> Type</strong></div></td>
<td align="center" width="15%"> <div align="left"><strong>Details</strong></div></td>
<td align="center" width="8%"> <strong>Amount</strong></td>
<td align="center" width="10%">&nbsp;</td>
</tr>
</thead>
<tbody>

<tr>

<td valign="top"><cfselect name="AccountID" id="AccountID" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.getBankAccount()" display="AccountID" value="AccountID" tabindex="1" bindonload="yes"  style="width:100%"> </cfselect></td>
            <td valign="top"><cfselect name="VendorID" id="VendorID" style="width:100%" required="yes"  message="Select Supplier" bind="cfc:#request.cfc#cfc.bind.Vendor()"
display="VendorID" value="VendorID" bindonload="yes" tabindex="2"> </cfselect></td>

<td>
<cfinput type="datefield" style="width:100%" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="expenseDate" id="expenseDate" tabindex="3" title="Expense Date" required="yes" message="Enter valid date"/>

 </td>
<td valign="top"> <cfinput type="text" name="ref" message="Ref. Number must be numeric" validate="integer" required="yes" id="ref" style="text-align:right; width:100%" tabindex="4" autosuggest="no">
					<span id="msg">&nbsp;Ref. ## Already exist</span> </td>
<td valign="top"><cfselect name="ExpenseID" id="ExpenseID" style="width:100%" required="yes"  message="Select an Account Type" bind="cfc:#request.cfc#cfc.bind.getExpenseAccounts()" display="AccountID" value="AccountID" bindonload="yes" class="stnd_10pt_style" tabindex="5"> </cfselect></td>
<td valign="top"> <cfinput type="text" name="Details" message="Enter Details" required="yes" style="text-align:left;width:100%" tabindex="6" autocomplete="on"> </td>
<td valign="top" align="center"> <div align="right">
  <cfinput type="text" name="Amount" validate="float" style="text-align:right; width:100%" required="yes" message="Enter Amount" autosuggest="no" tabindex="7">
</div></td>

<td valign="top" align="center">  <cfinput type="submit" name="AddInvoice" id="AddInvoice" value="Add" tabindex="8"></td>

</tr>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left" valign="top"> <div align="left">#session.myInvoice[variables.counter].AccountID# </div></td>
<td align="left" valign="top"> <div align="left">#session.myInvoice[variables.counter].VendorID# </div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].expenseDate# </div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].ref#</div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].ExpenseID# </div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].details# </div></td>
<td align="right" valign="top" style="text-align:right"> #LSNumberFormat(session.myInvoice[variables.counter].Amount,',999999999999999999.99')# </td>
<td> <div align="right" title="Remove this Item"><a href="#cgi.SCRIPT_NAME#?id=#counter#"><font color="##FF0000"><strong>X</strong></font></a>&nbsp; </div></td>
</tr>
</cfloop> 
<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.totalAmount,#form.Amount#)>
<cfset position = arraylen(session.totalAmount)>
<cfset session.totalAmount[position] = #form.Amount#>
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.totalAmount#,#url.id#)#>
</cfif>
<cfset Amount = #arraySum(session.totalAmount)#>
<cfset session.Amount = #Amount#>
<tr>
  <td colspan="6" align="right"><div align="right"><strong>Total:&nbsp;</strong></div></td>
  <td align="right"><div align="right">
   <strong>#LSNumberFormat(Amount,',99999999.99')#</strong>
    <cfinput type="hidden" name="totalAmount" id="totalAmount" class="stnd_10pt_style"  validate="float" value="#Amount#" style="text-align:right">
  </div></td>
  <td align="center"><a href="Expenses.cfm?reset=1"><font color="##FF0000"><strong>Reset</strong></font></a>&nbsp;<a href="Expenses.cfm?sales=yes"><font color="##000000"><strong>Post</strong></font></a></td>
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
</div>
</div>
</body>
</html>