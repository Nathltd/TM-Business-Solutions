<!doctype html>
<html>
<head>
<title><cfoutput>Cash Summary :: #request.title#</cfoutput></title>
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
<cfparam name="form.submit" default="">

<h4> Cash Summary <cfif isdefined(form.submit)><cfoutput> between #startdate# and #endDate# At #form.branch# </cfoutput></cfif> </h4>
<div id="RightColumn">
<cfquery name="branch">
select branchid from branches
order by branchid
</cfquery>
<cfform>
<table width="65%" cellpadding="2">
<tr>
<td>Start Date:</td><td> <cfinput type="datefield" name="startDate" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"mm/dd/yyyy")#" style="width:100%"></td><td>End Date:</td><td> <cfinput type="datefield" name="endDate" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"mm/dd/yyyy")#" style="width:100%"></td><td>Account:</td><td valign="top"> <cfselect name="Branch" style="width:100%" bind="cfc:#request.cfc#cfc.bind.getCashAccount()" display="AccountID" value="AccountID" bindonload="yes"> </cfselect>
                        </td>
</tr>
<tr>
<td colspan="6" align="right"><cfinput type="submit" value="Submit" name="submit"></td>
</tr>
</table>
</cfform>

<cfoutput>
<cfif isdefined(form.submit)>
<cfset startDate = #CreateODBCDate(dateformat(form.startDate,"dd/mm/yyyy"))#>
<cfset endDate = #CreateODBCDate(dateformat(form.endDate,"dd/mm/yyyy"))#>
<cfset datedif = #datediff("d",startDate,enddate)#>
<cfset branchid = '#form.branch#'>

<cfif #datedif# gt 31>
<h3>Range greater than 31 days. Please Adjust.</h3>
<cfabort>
</cfif>
<cfquery name="pay">
SELECT id,paymentId,accountid, type, Amount
FROM vwAccountFiscalTranstUnion
WHERE accountid = '#form.branch#' AND PaymentDate between #startdate# and #endDate#
</cfquery>

<cfset payment = #pay.Amount#>
<cfif pay.Amount eq ''>
<cfset payment = 0>
</cfif>

<cfquery name="SalesDay">
SELECT SalesDate, BranchID, SUM(TotalAmount) AS Amt
FROM vwSalesAmtPerDaySumry
WHERE BranchID = '#form.branch#' AND SalesDate between #startdate# and #endDate#
group by  SalesDate, BranchID
</cfquery>
 

<cfquery name="totalSales" dbtype="query">
select SUM(amt) as total from salesDay
</cfquery>
 
<cfquery name="InvoicePd" dbtype="query">
Select SUM(Amount) AS Amt from pay
where Type = 'InvoicePd'
</cfquery>
<cfquery name="TransferOut" dbtype="query">
Select SUM(Amount) AS Amt from pay
where Type = 'Transfer Out'
</cfquery>
<cfquery name="TransferIn" dbtype="query">
Select SUM(Amount) AS Amt from pay
where Type = 'Transfer In'
</cfquery>
<cfquery name="payments" dbtype="query">
Select SUM(Amount) AS Amt from pay
where Type = 'Cash' or Type = 'Cheque' or Type = 'EFT'
</cfquery>

<cfquery name="Expense" dbtype="query">
Select SUM(Amount) AS Amt from pay
where Type = 'Expense' or Type = 'Refund'
</cfquery>
<cfquery name="PurchasePd" dbtype="query">
Select SUM(Amount) AS Amt from pay
where Type = 'Purchase Pd'
</cfquery>
<cfquery name="Purchase" dbtype="query">
Select SUM(Amount) AS Amt from pay
where Type = 'Pd Supply'
</cfquery>
<cfquery name="SupRefund" dbtype="query">
Select SUM(Amount) AS Amt from pay
where  Type = 'Sup Refund' or Type = 'Exp Refund'
</cfquery>


<!--- Check For Previous Balance --->

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Amt FROM vwAccountFiscalTranstUnion
WHERE PaymentDate < #startdate# AND AccountID = '#form.branch#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Amt) AS Qty
FROM TotalQty
WHERE Type = 'Transfer Out' or Type = 'Refund' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Amt) AS Qty
FROM TotalQty
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'EFT' or Type = 'O/Balance' or Type = 'Sup Refund'
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

<!--- Nulls to zero --->
<cfset sales = #totalSales.total#>
<cfif SalesDay.Amt eq ''>
<cfset sales = 0>
</cfif>
<cfset InvoicePdAmt = #InvoicePd.Amt#>
<cfif InvoicePd.Amt eq ''>
<cfset InvoicePdAmt = 0>
</cfif>
<cfset supRefundAmt = #supRefund.Amt#>
<cfif supRefund.Amt eq ''>
<cfset supRefundAmt = 0>
</cfif>
<cfset ExpenseAmt = #Expense.Amt#>
<cfif Expense.Amt eq ''>
<cfset ExpenseAmt = 0>
</cfif>
<cfset TransferOutAmt = #TransferOut.Amt#>
<cfif TransferOut.Amt eq ''>
<cfset TransferOutAmt = 0>
</cfif>
<cfset TransferInAmt = #TransferIn.Amt#>
<cfif TransferIn.Amt eq ''>
<cfset TransferInAmt = 0>
</cfif>
<cfset PurchasePdAmt = #PurchasePd.Amt#>
<cfif PurchasePd.Amt eq ''>
<cfset PurchasePdAmt = 0>
</cfif>
<cfset PurchaseAmt = #Purchase.Amt#>
<cfif Purchase.Amt eq ''>
<cfset PurchaseAmt = 0>
</cfif>
<cfset paymentsAmt = #payments.Amt#>
<cfif payments.Amt eq ''>
<cfset paymentsAmt = 0>
</cfif>



<table width="40%" border="0" cellpadding="3" cellspacing="0">

<cfif IsDefined("rowColor")Is False or rowColor is "D5D5FF"><cfset rowColor="FFFFFF"><cfelse><cfset rowColor="D5D5FF"></cfif>
<tr bgcolor="D5D5FF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='D5D5FF';" >
<td width="62%">Transaction Type</td><td width="38%" align="right">Amount</td>
</tr>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >

<td width="62%">Balance B/F:</td><td width="38%" align="right"><div align="right">#numberformat(PreviousBal,",0.00")#</div></td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td width="62%">Total Sales:</td><td align="right">#numberformat(totalSales.total,",0.00")#</td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >

<td>Amount Paid(Cash):</td><td align="right"><div align="right">#numberformat(InvoicePdAmt,",0.00")#</div></td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >
<cfset creditSales = #sales# - #InvoicePdAmt#>
<td>Sales On Credit:</td><td align="right">#numberformat(creditSales,",0.00")#</td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td>Payments from Prev. Sales:</td><td align="right"><div align="right">#numberformat(payments.Amt,",0.00")#</div></td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td>Refunds from Suppliers/Vendors:</td><td align="right"><div align="right">#numberformat(supRefundAmt,",0.00")#</div></td>
</tr>
<tr  onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td>Purchases:</td><td><div align="right">#numberformat(PurchasePdAmt,"0.00")#</div></td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td>Payments to Prev. Purchase:</td><td align="right"><div align="right">#numberformat(PurchaseAmt,",0.00")#</div></td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >
<td>Expenses:</td><td><div align="right">#numberformat(ExpenseAmt,",0.00")#</div></td>
</tr>
<tr  onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td>Payment From Other Bank(s):</td><td><div align="right">#numberformat(TransferInAmt,",0.00")#</div></td>
</tr>
<tr  onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td>Payment to Other Bank(s):</td><td><div align="right">#numberformat(TransferOutAmt,",0.00")#</div></td>
</tr>
<tr onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >
<cfset cashHand =#PreviousBal# + #InvoicePdAmt# + #paymentsAmt# + #supRefundAmt# + #TransferInAmt# - #ExpenseAmt# - #TransferOutAmt# - #PurchasePdAmt# - #PurchaseAmt#>
<td>Cash At Hand:</td><td><div align="right">#numberformat(cashHand,",0.00")#</div></td>
</tr>
</table>
</cfif>
</cfoutput>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>