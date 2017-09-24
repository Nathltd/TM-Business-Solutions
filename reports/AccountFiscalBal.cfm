<!doctype html>
<html>
<head>
<title><cfoutput>Transact. Details :: #request.title#</cfoutput></title>
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
<cfif #GetUserRoles()# is  'Procurement'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant2'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<h4><cfif isdefined ("url.id")><cfoutput>#url.id#</cfoutput> Transactions<cfelse>Bank/Cash Account Balance</cfif></h4>

<div id="RightColumn">

<cfif isdefined ("url.id")>

<div align="right"><a href="?"> return </a>&nbsp;</div>

<cfquery name="AccountDetails">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwAccountFiscalTranstUnion
Where AccountID = '#url.id#'
ORDER BY PaymentDate,  PaymentID, Type ASC
</cfquery>

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwAccountFiscalTranstUnion
Where AccountID = '#url.id#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer Out' or Type = 'Refund' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense' or Type = 'Rebate'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'O/Balance' or Type = 'Sup Refund' or Type = 'Exp Refund' or Type = 'EFT'
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
<cfoutput> #AccountDetails.RecordCount# Record(s) Available.</cfoutput><br>
<br />

  <table width="80%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="10%"><strong>Date</strong></td>
  <td width="10%"><strong>Ref No.</strong></td><td width="15%"><strong>Type</strong></td>
  <td width="25%"><strong>Account</strong></td>
  <td width="20%"><div align="right"><strong>Debit</strong></div></td><td width="20%"><div align="right"><strong>Credit</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="98"><div align="right"><strong>Balance</strong></div></td>
  </tr>
<cfoutput query="AccountDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="83" align="left">#PaymentID#</td><td width="62" align="left">#Type#</td>
  <cfset customer = '#AccountDetails.CustomerID#'>
  <cfif #Type# is 'Invoicepd'>
  <cfquery name="general">
select customerId, SalesId from customersGen
where salesId = #PaymentID#
</cfquery>
  <cfif #general.RecordCount# eq 1 AND #AccountDetails.Type# is 'Invoicepd'>
  <cfset customer = #general.CustomerID#>
  </cfif>  
  </cfif>
  <td width="107" align="left">#Customer#</td>
  <td><div align="right"><cfif #Type# is "Transfer Out">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Expense">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Rebate">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Pd Supply">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Purchase Pd">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td><td><div align="right"><cfif #Type# is "Transfer Out">0<cfelseif #Type# is "Refund">0<cfelseif #Type# is "Expense">0<cfelseif #Type# is "Rebate">0<cfelseif #Type# is "Pd Supply">0<cfelseif #Type# is "Purchase Pd">0<cfelse>#numberformat(Qty,",000.00")#</cfif></div></td>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>

<cfif #AccountDetails.Type# is "Transfer Out">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Purchase Pd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Pd Supply">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Expense">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Rebate">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
  </tr>
</cfoutput>
<cfoutput>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td align="left">&nbsp;</td>
  <td align="left">&nbsp;</td>
  <td align="left">&nbsp;</td>
  <td align="left"><div align="right"><strong>Total</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyOUT,",000.00")#</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyIN,",000.00")#</strong></div></td>
  <td><div align="right"><strong>#numberformat(PreviousBal,",000.00")#</strong></div></td>
</tr>
</cfoutput>
</table>
</div>

<cfelse>

<cfquery name="Accounts">
SELECT * FROM vwAccntBalance
</cfquery>

  <div align="right">
  <cfoutput>Accounts on Record =<strong> #Accounts.recordCount#</strong></cfoutput>&nbsp;
  </div>



  <table width="645" cellpadding="0" cellspacing="5">
  <tr>
  <td width="182"><strong>Account</strong></td>
  <td width="130"><div align="right"><strong>Amount In</strong></div></td>
  <td width="130"><div align="right"><strong>Amount Out</strong></div></td>
  <td width="125"><div align="right"><strong>Balance</strong></div></td>
  </tr>
<cfoutput query="Accounts">

  <cfif #Accounts.Balance# gte 0>
<cfset Bcolor="009900"><!---Green--->
<cfelse>
<cfset Bcolor="FF0000"><!---Red--->
</cfif>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="182" align="left"><font color="#Bcolor#"><a href="AccountFiscalBal.cfm?id=#AccountID#">#AccountID#</a></font></td><td width="130"><div align="right"><font style="font-weight: normal">#numberformat(AmountIn,",000.00")#</font></div></td><td width="130"><div align="right"><font style="font-weight: normal">#numberformat(AmountOut,",000.00")#</font></div></td><td width="125"><div align="right"><font color="#Bcolor#">#numberformat(Balance,",000.00")#</font></div></td>
  </tr>
</cfoutput>
      <cfquery name="AccountBalanceTotal">
SELECT SUM(AmountIn) AS TotalIN, SUM(AmountOut) AS TotalOUT, SUM(Balance) AS Bal
FROM vwAccntBalance 
  </cfquery>
<cfoutput>
  <tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="182" align="left"><strong>Total</strong></td><td width="130"><div align="right"><strong>#numberformat(AccountBalanceTotal.TotalIN,",000.00")#</strong></div></td><td width="130"><div align="right"><strong>#numberformat(AccountBalanceTotal.TotalOUT,",000.00")#</strong></div></td><td width="125" align="right"><div align="right"><strong>#numberformat(AccountBalanceTotal.Bal,",000.00")#</strong></div></td>
  </tr>
  </cfoutput>
</table>
</cfif>
</div>
</cfif>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>

</body>
</html>