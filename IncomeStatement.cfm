<cfquery name="Revenue">
SELECT Sum(vwSalesDetails.Amt) AS Amount
FROM vwSalesDetails;
</cfquery>

<cfquery name="COG">
SELECT Sum(vwPurchaseDetails.Amt) AS Amount
FROM vwPurchaseDetails;
</cfquery>

<cfquery name="GP">
SELECT Sum(vwRevenue.Amount-vwCostOfSales.Amount) AS Amount
FROM vwCostOfSales, vwRevenue;
</cfquery>
<cfoutput>
<table>
<tr>
<td><strong>INCOME STATEMENT</strong></td><td></td>
</tr>
<tr>
<td>Revenue</td><td><div align="right">#numberformat(Revenue.Amount,",000.00")#</div></td>
</tr>
<tr>
<td>Cost of Goods</td><td><div align="right">#numberformat(COG.Amount,",000.00")#</div></td>
</tr>
<tr>
<td>Gross Profit</td><td><div align="right">#numberformat(GP.Amount,",000.00")#</div></td>
</tr>
</table>
</cfoutput>