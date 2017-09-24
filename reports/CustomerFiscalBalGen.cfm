<!doctype html>
<html>
<head>
<title><cfoutput>General Customers Balance :: #request.title#</cfoutput></title>
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
<cfparam name="form.search" default="">


<h4><cfif isdefined(form.search)>
<cfquery name="CustomerName">
select customerId from customersGen
where salesId = #form.GenInv#
</cfquery>
<cfoutput>#CustomerName.customerId#</cfoutput> <cfelse>  Customer's </cfif>Cash Transactions</h4>

<div id="RightColumn">

<div align="right"><a href="?"> Return </a>&nbsp;&nbsp;<a href="?print=yes"> Print </a>&nbsp;&nbsp;</div>



<cfquery name="AllCustomer">
select CustomerId, Phone
from CustomersGen
ORDER BY CustomerId ASC
</cfquery>
<cfset customer = ValueList(AllCustomer.customerId)>
<cfset validCustomer = #Listlen(customer)#>

<cfif #validCustomer# eq 0>

<h3>You have no Item to update. Please contact the administrator.</h3>
<cfabort>
</cfif>

<cfform action="#cgi.SCRIPT_NAME#">
<table width="50%" cellpadding="2">
<tr>
<td width="35%">Customer:</td> <td width="30%">Phone Number:</td><td width="30%">Order Number:</td> 
</tr>
<tr>

<td><cfinput name="genName" type="text" placeholder="Customer's Name" required="yes" autosuggest="#customer#"  autosuggestminlength="2" autocomplete="off" message="Enter a valid general customer."></td>
<td><cfinput name="genPhone" type="text" placeholder="Phone Number" bind="cfc:#request.cfc#cfc.bind.getGenPhone({genName})" required="yes" readonly="yes" message="Customer selected not in record.">
</td>
<td>
<cfinput name="genInv" type="text" placeholder="Phone Number" bind="cfc:#request.cfc#cfc.bind.getGenInv({genName})" required="yes" readonly="yes" message="Customer selected not in record."></td>
<td valign="top"><cfinput name="Search" value="Search" type="submit"></td>
</tr>
</table>
</cfform>

<cfif isdefined(form.search)>
<cfset genName = #form.genName#>
<cfset genPhone = #form.genPhone#>
<cfset genInv = #form.genInv#>
<cfset maxrows = 200>
<cfelse>
<cfset maxrows = 30>
</cfif>
<cfquery name="CustomerDetails" maxrows="#maxrows#">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwCustomerFiscalTranstUnion
Where CustomerID = 'general'
<cfif isdefined(form.search)>
AND PaymentId = '#genInv#'
ORDER BY PaymentDate
<cfelse>
ORDER BY PaymentDate Desc
</cfif>
</cfquery>

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
Where CustomerID = 'general'
GROUP BY Type
</cfquery>
<cfif isdefined(form.search)>

<cfquery name="TotalAmt">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
WHERE PaymentId = '#genInv#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalAmt
WHERE Type = 'Invoice' or Type = 'Refund' or Type = 'Retained' or Type = 'Reimburse' or Type = 'Rebate'
</cfquery>

<cfquery dbtype="query" name="QtyIn">
SELECT  SUM(Qty1) AS Qty
FROM TotalAmt
WHERE Type = 'O/Balance' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'EFT'
</cfquery>

<cfif QtyIN.recordCount eq 0 AND QtyOUT.recordCount gt 0>
<cfset QtyIN = 0>
<cfset #QtyOUT# = #Valuelist(QtyOUT.Qty)#>
<cfelseif QtyOUT.recordCount eq 0  AND QtyIN.recordCount gt 0>
<cfset QtyOUT = 0>
<cfset #QtyIN# = #Valuelist(QtyIN.Qty)#>
<cfelseif QtyIN.recordCount eq 0 AND QtyOUT.recordCount eq 0>
<cfset QtyIN = 0>
<cfset QtyOUT = 0>
<cfelse>
<cfset #QtyIN# = #Valuelist(QtyIN.Qty)#>
<cfset #QtyOUT# = #Valuelist(QtyOUT.Qty)#>
</cfif>

<cfset PreviousBal = +#QtyIN#-(#QtyOUT#)>



<cfset name="qty2" = #PreviousBal#>

</cfif>
<div align="center">
<cfoutput>#CustomerDetails.RecordCount# Record(s) Available.</cfoutput><br>
<br />

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="60"><strong>Date</strong></td>
  <td width="60"><strong>Ref No.</strong></td>
  <td width="80"><strong>Name</strong></td>
  <td width="62"><strong>Type</strong></td>
  <td width="90"><strong>Account</strong></td>
  <td width="60"><div align="right"><strong>Debit</strong></div></td><td width="60"><div align="right"><strong>Credit</strong></div></td>
  <cfif isdefined(form.search)>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="60"><div align="right"><strong>Balance</strong></div></td>
  </cfif>
  </tr>
  <cfif isdefined(form.search)>
  <tr>
  <td width="60"></td>
  <td width="60"></td>
  <td width="80"></td>
  <td width="62"></td>
  <td width="90"></td>
  <td width="60"><div align="right"></div></td><td width="60"><div align="right"><strong>Previous Balance</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="60"><div align="right"><strong><cfoutput>#numberformat(PreviousBal,",000.00")#</cfoutput></strong></div></td>
  </tr>
  </cfif>
<cfoutput query="CustomerDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="60" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="60" align="left">#PaymentID#</td>
  <cfquery name="CustomerName">
select customerId from customersGen
where salesId = #PaymentID#
</cfquery>
  <td width="80">#CustomerName.customerId#</td>
  <td width="62" align="left">#Type#</td>
  <td width="90" align="left">#AccountID#</td>
  <td><div align="right"><cfif #Type# is "Invoice">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td><td><div align="right"><cfif #Type# is "Invoice">0<cfelseif #Type# is "Refund">0<cfelse>#numberformat(Qty,",000.00")#</cfif></div></td>
  <cfif isdefined(form.search)>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>


<cfif #CustomerDetails.Type# is "Invoice">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #CustomerDetails.Type# is "refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #CustomerDetails.Type# is "Retained">
<cfset qty2 = -(#qty#)+#val(qty2)#>

<cfelse>
<cfset qty2 = +(#qty#)+#val(qty2)#>
</cfif>
<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
</cfif>
  </tr>
</cfoutput>
</table>
</div>

</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>

</body>
</html>