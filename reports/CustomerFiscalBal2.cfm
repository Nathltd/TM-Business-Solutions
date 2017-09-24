<!doctype html>
<html>
<head>
<title><cfoutput>Customers Balance :: #request.title#</cfoutput></title>
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

<h4><cfif isdefined ("url.id")><cfoutput>#url.id#</cfoutput> Transactions<cfelse>Customer's Cash Balance</cfif></h4>

<div id="RightColumn">
<cfparam name="url.print" default="">
<cfif isdefined ("url.id")>
<cfset session.urlId = #url.id#>

<div align="right"><a href="?"> Return </a>&nbsp;&nbsp;<a href="?print=yes"> Print </a>&nbsp;&nbsp;</div>

<cfparam name="form.search" default="">

<cfform action="#cgi.SCRIPT_NAME#?id=#url.id#">
<table width="50%" cellpadding="2">
<tr>
<td width="40%">Starting:</td> <td width="40%">Ending:</td>
</tr>
<tr>
<td><cfinput name="StartDate" type="datefield" placeholder="#dateFormat(request.StartYear,"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td valign="top"><cfinput name="Search" value="Search" type="submit"></td>
</tr>
</table>
</cfform>

<cfif isdefined(form.search)>
<cfset StartDate = #form.StartDate#>
<cfset StartDate = #Dateformat(StartDate,"dd/mm/yyyy")#>
<cfset EndDate = #form.EndDate#>
<cfset EndDate = #Dateformat(EndDate,"dd/mm/yyyy")#>
<cfset yyear = '#request.StartYear#'>
<cfset yyear = #Dateformat(CreateODBCDate(request.StartYear))#>

<cfset session.StartDate = "#StartDate#">
<cfset session.EndDate = "#EndDate#">
</cfif>
<cfif isdefined(form.search)>
<cfset maxrows = 200>
<cfelse>
<cfset maxrows = 30>
</cfif>
<cfquery name="CustomerDetails" maxrows="#maxrows#">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwCustomerFiscalTranstUnion
Where CustomerID = '#url.id#'
<cfif isdefined(form.search)>
AND paymentdate >= #CreateODBCDate(StartDate)# AND paymentdate <= #CreateODBCDate(EndDate)#
ORDER BY PaymentDate asc,  PaymentID asc, Type desc
<cfelse>
ORDER BY PaymentID desc, Type desc, PaymentDate desc
</cfif>
</cfquery>

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
Where CustomerID = '#url.id#'
GROUP BY Type
</cfquery>
<cfif isdefined(form.search)>

<cfquery name="TotalAmt">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
WHERE paymentdate < #CreateODBCDate(StartDate)# AND CustomerID = '#url.id#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalAmt
WHERE Type = 'InvoicePd' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="QtyIn">
SELECT  SUM(Qty1) AS Qty
FROM TotalAmt
WHERE Type = 'O/Balance' or Type = 'Cheque' or Type = 'Cash' or Type = 'EFT' or Type = 'Rebate' or Type = 'Reimburse' or  Type = 'Retained'
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
<cfoutput> Last  #CustomerDetails.RecordCount# Record(s) Available.</cfoutput><br>
<br />

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="96"><strong>Date</strong></td>
  <td width="89"><strong>Ref No.</strong></td>
  <cfif #url.id# eq 'General'>
  <td width="183"><strong>Name</strong></td>
  </cfif>
  <td width="46"><strong>Type</strong></td>
  <td width="107"><strong>Account</strong></td>
  <td width="92"><div align="right"><strong>Debit</strong></div></td><td width="89"><div align="right"><strong>Credit</strong></div></td>
  <cfif isdefined(form.search)>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="106"><div align="right"><strong>Balance</strong></div></td>
  </cfif>
  </tr>
  <cfif isdefined(form.search)>
  <tr>
  <td width="96"></td>
  <td width="89"></td>
  <cfif #url.id# eq 'General'>
  <td width="183"></td>
  </cfif>
  <td width="46"></td>
  <td width="107"></td>
  <td width="92"><div align="right"></div></td><td width="89"><div align="right"><strong>Previous Balance</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="106"><div align="right"><strong><cfoutput>#numberformat(PreviousBal,",000.00")#</cfoutput></strong></div></td>
  </tr>
  </cfif>
<cfoutput query="CustomerDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="96" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="89" align="left">#PaymentID#</td>
  <cfif #url.id# eq 'General'>
  <cfquery name="CustomerName">
select customerId from customersGen
where salesId = #PaymentID#
</cfquery>
  <td width="183">#CustomerName.customerId#</td>
  </cfif>
  <td width="46" align="left">#Type#</td>
  <td width="107" align="left">#AccountID#</td>
  
  <td><div align="right"><cfif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelseif #Type# is "InvoicePd">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td>


 
  <td><div align="right"><cfif #Type# is "O/Balance">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Cheque">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Cash">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Rebate">#numberformat(Qty,",000.00")#<cfelseif #Type# is "EFT">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Reimburse">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Retained">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td>
  <cfif isdefined(form.search)>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>



<cfif #CustomerDetails.Type# is "Refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #CustomerDetails.Type# is "InvoicePd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = #Qty2#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
</cfif>
  </tr>

</cfoutput>
<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty) AS Qty1
FROM CustomerDetails
WHERE Type = 'Invoicepd' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="QtyIn">
SELECT  SUM(Qty) AS Qty1
FROM CustomerDetails
WHERE Type = 'O/Balance' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'EFT'  or Type = 'Rebate' or Type = 'Retained' or Type = 'Reimburse'
</cfquery>

<cfoutput>
  <tr>
  <td colspan="3"></td><td align="left"><div align="right"><strong>Total</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyOUT.Qty1,",000.00")#</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyIN.Qty1,",000.00")#</strong></div></td>
  <td><div align="right"></div></td>
  </tr>
</cfoutput>  
 

</table>
</div>

<cfelse>

    <cfquery name="CustomerBalance">
SELECT CustomerID, OpeningBalance, Total, TotalPaid, Rebate, Reimburse, Balance, creditLimit
FROM vwCustomerPayBalance
ORDER BY CustomerID ASC 
  </cfquery>
  
    <cfif CustomerBalance.recordCount is 0>
<h2> No Record Found! </h2>
<cfelse>

  <table width="90%">
  <tr>
  <td width="40%"></td>
  <td width="30%"></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="30%"><div align="right"><cfoutput>Customers on Record:<strong> #CustomerBalance.recordCount#</strong></cfoutput></div></td>
  </tr>
  <tr>
  <td width="40%"><strong>Customer</strong></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="30%"><div align="right"><strong>Credit Limit</strong></div></td>
  <td width="30%"><div align="right"><strong>Balance</strong></div></td>
  
  </tr>
<cfoutput query="CustomerBalance">

  <cfif #CustomerBalance.Balance# gte 0>
<cfset Bcolor="009900"><!---Green--->
<cfelse>
<cfset Bcolor="FF0000"><!---Red--->
</cfif>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td align="left"><font color="#Bcolor#"><cfif #customerId# is 'General'><a href="CustomerFiscalBalGen.cfm">#CustomerID#</a>
  <cfelse><a href="#cgi.SCRIPT_NAME#?id=#customerID#">#CustomerID#</a></cfif></font></td><td><div align="right">#numberformat(creditLimit,",000.00")#</div></td><td><div align="right"><font color="#Bcolor#">#numberformat(Balance,",000.00")#</font></div></td>
  </tr>
</cfoutput>
      <cfquery name="CustomerBalanceTotal">
SELECT SUM(OpeningBalance) AS OpeningBal, SUM(Total) AS Totl, SUM(TotalPaid) AS Paid, SUM(Balance) AS Bal, SUM(Rebate) AS Reb, SUM(Reimburse) AS Reimb
FROM vwCustomerPayBalance 
  </cfquery>
<cfoutput>
  <tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td></td>
  <td align="right"><strong>Total: </strong></td><td align="right"><div align="right"><strong>#numberformat(CustomerBalanceTotal.Bal,",000.00")#</strong></div></td>
  </tr>
  </cfoutput>
</table>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>

</body>
</html>