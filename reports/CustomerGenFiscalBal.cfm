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

<cfquery name="CustomerDetails">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwCustomerFiscalTranstUnion
Where CustomerID = '#url.id#' OR CustomerID = 'General' AND paymentId = '#url.inv#'
ORDER BY PaymentDate,  PaymentID, Type ASC
</cfquery>



<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
Where CustomerID = '#url.id#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Invoice' or Type = 'Refund' or Type = 'Retained' or Type = 'Reimburse' or Type = 'Rebate'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
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

<cfparam name="qty2" default="0">


<div align="center">
<cfoutput> Last #CustomerDetails.RecordCount# Record(s) Available.</cfoutput><br>
<br />

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="79"><strong>Date</strong></td>
  <td width="83"><strong>Ref No.</strong></td><td width="62"><strong>Type</strong></td>
  <td width="107"><strong>Account</strong></td>
  <td width="102"><div align="right"><strong>Debit</strong></div></td><td width="92"><div align="right"><strong>Credit</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="98"><div align="right"><strong>Balance</strong></div></td>
  </tr>
<cfoutput query="CustomerDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="83" align="left">#PaymentID#</td><td width="62" align="left">#Type#</td>
  <td width="107" align="left">#AccountID#</td>
  <td><div align="right"><cfif #Type# is "Invoice">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td><td><div align="right"><cfif #Type# is "Invoice">0<cfelseif #Type# is "Refund">0<cfelse>#numberformat(Qty,",000.00")#</cfif></div></td>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>


<cfif #CustomerDetails.Type# is "Invoice">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #CustomerDetails.Type# is "refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
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
  <td align="left"><font color="#Bcolor#"><a href="#cgi.SCRIPT_NAME#?id=#customerID#">#CustomerID#</a></font></td><td><div align="right">#numberformat(creditLimit,",000.00")#</div></td><td><div align="right"><font color="#Bcolor#">#numberformat(Balance,",000.00")#</font></div></td>
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
<cfif #url.print# is "yes">

<cfdocument format="flashpaper" unit="in" margintop=".3" marginleft=".3" marginright=".3" marginbottom=".3">
<div align="left">
<img src="../shared/TMlogoSmall3.jpg" width="50" height="37"><br>
<cfoutput>
<font size="+4" face="Segoe UI">#request.Company#</font><br>
<font size="1">#request.CompanyAddress#</font><br><br>
<font size="3"><strong>#session.urlId# Transactions</strong></font>
</cfoutput>
<style>
#row{
	font-size:11px;
}
</style>
<cfquery name="CustomerDetails">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwCustomerFiscalTranstUnion
Where CustomerID = '#session.urlId#'
ORDER BY PaymentDate,  PaymentID, Type ASC
</cfquery>


<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
Where CustomerID = '#session.urlId#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Invoice' or Type = 'Refund' or Type = 'Retained' or Type = 'Reimburse' or Type = 'Rebate'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
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

<cfparam name="qty2" default="0">


<div align="right">
<cfoutput><font size="1"> #CustomerDetails.RecordCount# Record(s) Available.</font></cfoutput><br>
<br />

  <table width="100%">
  <tr id="row">
  <td width="96"><strong>Date</strong></td>
  <td width="117"><strong>Ref No.</strong></td><td width="99"><strong>Type</strong></td>
  <td width="178"><strong>Account</strong></td>
  <td width="170"><div align="right"><strong>Debit</strong></div></td>
  <td width="167"><div align="right"><strong>Credit</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="196"><div align="right"><strong>Balance</strong></div></td>
  </tr>
<cfoutput query="CustomerDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr id="row" bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="96" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="117" align="left">#PaymentID#</td><td width="99" align="left">#Type#</td>
  <td width="178" align="left">#AccountID#</td>
  <td><div align="right"><cfif #Type# is "Invoice">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td><td><div align="right"><cfif #Type# is "Invoice">0<cfelse>#numberformat(Qty,",000.00")#</cfif></div></td>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>


<cfif #CustomerDetails.Type# is "Invoice">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #CustomerDetails.Type# is "refund">
<cfset qty2 = -(#qty#)+#val(qty2)#+(#qty#)>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
  </tr>
</cfoutput>
</table>
</div>
</div>
<cfdocumentitem type="footer">
<cfoutput>
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfoutput>
</cfdocumentitem>
</cfdocument>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>

</body>
</html>