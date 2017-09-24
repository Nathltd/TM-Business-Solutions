<!doctype html>
<html>
<head>
<title><cfoutput>Vendor's Cash Balance :: #request.title#</cfoutput></title>
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

<h4><cfif isdefined ("url.id")><cfoutput>#url.id#</cfoutput> Transactions<cfelse>Vendor's Cash Balance</cfif></h4>

<div id="RightColumn">
<cfparam name="url.print" default="">
<cfif isdefined ("url.id")>
<cfset session.urlId = #url.id#>
<div align="right"><a href="?"> return </a>&nbsp;&nbsp;&nbsp;<a href="?print=yes"> Print </a>&nbsp;&nbsp;</div>

<cfquery name="SupplierDetails">
Select VendorID, Type, (Amount) AS Qty, PaymentID, PaymentDate, AccountID
FROM vwVendorFiscalTranstUnion
Where VendorID = '#url.id#'
ORDER BY PaymentDate,  PaymentID, Type ASC
</cfquery>


<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwVendorFiscalTranstUnion
Where VendorID = '#url.id#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Invoice' or Type = 'Sup Refund' or Type = 'O/Balance'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'Expense' or Type = 'Pd Supply' or Type = 'Debit Note'
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
<cfoutput> #SupplierDetails.RecordCount# Record(s) Available.</cfoutput><br>
<br />

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="79"><strong>Date</strong></td>
  <td width="83"><strong>Ref No.</strong></td><td width="62"><strong>Type</strong></td>
  <td width="107"><strong>Account</strong></td>
  <td width="102"><div align="right"><strong>Debit</strong></div></td><td width="92"><div align="right"><strong>Credit</strong></div></td>
  <td width="33" hidden="yes">Calc</td><td width="98"><div align="right"><strong>Balance</strong></div></td>
  </tr>
<cfoutput query="SupplierDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="83" align="left">#PaymentID#</td><td width="62" align="left">#Type#</td>
  <td width="107" align="left">#AccountID#</td>
  <cfif #Qty# is 0>
  <cfset frmt = "0">
  <cfelse>
  <cfset frmt = ",000.00">
  </cfif>
  <td><div align="right"><cfif #Type# is "Invoice">0<cfelseif #Type# is "Sup Refund">0<cfelseif #Type# is "O/Balance">0<cfelse>#numberformat(Qty,"#frmt#")#</cfif></div></td>
  <td><div align="right"><cfif #Type# is "Invoice">#numberformat(Qty,"#frmt#")#<cfelseif #Type# is "Sup Refund">#numberformat(Qty,"#frmt#")#<cfelseif #Type# is "Expense">#numberformat(Qty,"#frmt#")#<cfelseif #Type# is "O/Balance">#numberformat(Qty,"#frmt#")#<cfelse>0</cfif></div></td>
  <td hidden="yes"><div align="right">
#Qty2#

<cfset Qty2 = #val(Qty2)#>

<cfif #SupplierDetails.Type# is "InvoicePd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Cheque">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Pd Supply">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Debit Note">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Cash">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Expense">
<cfset qty2 = -(#qty#)+#val(qty2)#+(#qty#)>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

</div>
</td>
<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
  </tr>
</cfoutput>
<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty) AS Qty1
FROM SupplierDetails
WHERE Type = 'Invoice' or Type = 'Sup Refund' or Type = 'O/Balance'
</cfquery>

<cfquery dbtype="query" name="QtyIn">
SELECT  SUM(Qty) AS Qty1
FROM SupplierDetails
WHERE Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'Expense' or Type = 'Pd Supply' or Type = 'Debit Note'
</cfquery>

<cfoutput>
  <tr>
  <td colspan="3"></td><td align="left"><div align="right"><strong>Total</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyIn.Qty1,",000.00")#</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyOut.Qty1,",000.00")#</strong></div></td>
  <td><div align="right"></div></td>
  </tr>
</cfoutput>
</table>
</div>


<cfelse>

    <cfquery name="VendorBalance">
SELECT VendorID, OpeningBalance, invAmount, TotalPaid, Balance
FROM vwVendorPayBalance
WHERE VendorType = 'Supplier'
ORDER BY VendorID ASC 
  </cfquery>

  <div align="right">
  <cfoutput>Vendors on Record =<strong> #VendorBalance.recordCount#</strong></cfoutput>&nbsp;
  </div>



  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="182"><strong>Vendor</strong></td>
  <td width="130"><div align="right"><strong>O/Balance</strong></div></td>
  <td width="130"><div align="right"><strong>Sales' Worth</strong></div></td>
  <td width="130"><div align="right"><strong>Amount Paid</strong></div></td>
  <td width="125"><div align="right"><strong>Balance</strong></div></td>
  </tr>
<cfoutput query="VendorBalance">

  <cfif #VendorBalance.Balance# gte 0>
<cfset Bcolor="009900"><!---Green--->
<cfelse>
<cfset Bcolor="FF0000"><!---Red--->
</cfif>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="182" align="left"><font color="#Bcolor#"><a href="#cgi.SCRIPT_NAME#?id=#VendorID#">#VendorID#</a></font></td><td width="130"><div align="right"><font style="font-weight: normal">#numberformat(OpeningBalance,",000.00")#</font></div></td><td width="130"><div align="right"><font style="font-weight: normal">#numberformat(invAmount,",000.00")#</font></div></td><td width="130"><div align="right"><font style="font-weight: normal">#numberformat(TotalPaid,",000.00")#</font></div></td><td width="125"><div align="right"><font color="#Bcolor#">#numberformat(Balance,",000.00")#</font></div></td>
  </tr>
</cfoutput>
      <cfquery name="VendorBalanceTotal">
SELECT SUM(OpeningBalance) AS OpeningBal, SUM(invAmount) AS invAmt, SUM(TotalPaid) AS Paid, SUM(Balance) AS Bal
FROM vwVendorPayBalance
WHERE VendorType = 'Supplier' 
  </cfquery>
<cfoutput>
  <tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="182" align="left"><strong>Total</strong></td><td width="130"><div align="right"><strong>#numberformat(VendorBalanceTotal.OpeningBal,",000.00")#</strong></div></td><td width="130"><div align="right"><strong>#numberformat(VendorBalanceTotal.invAmt,",000.00")#</strong></div></td><td width="130" align="right"><div align="right"><strong>#numberformat(VendorBalanceTotal.Paid,",000.00")#</strong></div></td><td width="125" align="right"><div align="right"><strong>#numberformat(VendorBalanceTotal.Bal,",000.00")#</strong></div></td>
  </tr>
  </cfoutput>
</table>
</cfif>
<cfif #url.print# is "yes">


<cfdocument format="flashpaper" unit="in" margintop=".3" marginleft=".3" marginright=".3" marginbottom=".3">
<div align="left">
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

<cfquery name="SupplierDetails">
Select VendorID, Type, (Amount) AS Qty, PaymentID, PaymentDate, AccountID
FROM vwVendorFiscalTranstUnion
Where VendorID = '#session.urlId#'
ORDER BY PaymentDate,  PaymentID, Type ASC
</cfquery>


<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwVendorFiscalTranstUnion
Where VendorID = '#session.urlId#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Invoice' or Type = 'Refund' or Type = 'O/Balance'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'Expense' or Type = 'Pd Supply' or Type = 'Debit Note'
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
<cfoutput> #SupplierDetails.RecordCount# Record(s) Available.</cfoutput><br>
<br />

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="79"><strong>Date</strong></td>
  <td width="83"><strong>Ref No.</strong></td><td width="62"><strong>Type</strong></td>
  <td width="107"><strong>Account</strong></td>
  <td width="102"><div align="right"><strong>Debit</strong></div></td><td width="92"><div align="right"><strong>Credit</strong></div></td>
  <td width="33" hidden="yes">Calc</td><td width="98"><div align="right"><strong>Balance</strong></div></td>
  </tr>
<cfoutput query="SupplierDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="83" align="left">#PaymentID#</td><td width="62" align="left">#Type#</td>
  <td width="107" align="left">#AccountID#</td>
  <cfif #Qty# is 0>
  <cfset frmt = "0">
  <cfelse>
  <cfset frmt = ",000.00">
  </cfif>
  <td><div align="right"><cfif #Type# is "Invoice">0<cfelseif #Type# is "Sup Refund">0<cfelseif #Type# is "O/Balance">0<cfelse>#numberformat(Qty,"#frmt#")#</cfif></div></td>
  <td><div align="right"><cfif #Type# is "Invoice">#numberformat(Qty,"#frmt#")#<cfelseif #Type# is "Sup Refund">#numberformat(Qty,"#frmt#")#<cfelseif #Type# is "Expense">#numberformat(Qty,"#frmt#")#<cfelseif #Type# is "O/Balance">#numberformat(Qty,"#frmt#")#<cfelse>0</cfif></div></td>
  <td hidden="yes"><div align="right">
#Qty2#

<cfset Qty2 = #val(Qty2)#>

<cfif #SupplierDetails.Type# is "InvoicePd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Cheque">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Pd Supply">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Debit Note">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Cash">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #SupplierDetails.Type# is "Expense">
<cfset qty2 = -(#qty#)+#val(qty2)#+(#qty#)>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

</div>
</td>
<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
  </tr>
</cfoutput>
</table>
</div>

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