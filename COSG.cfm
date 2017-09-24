<cfquery name="COgs">
select ReceiptID, qty, UnitPrice, SUM(qty*UnitPrice) AS Total  from vwCostOfGoodsUnion
where productid ='AMINODYN CAPSULE' 
group by ReceiptID, qty, UnitPrice
</cfquery>

<cfquery name="sumAmount" dbtype="query">
select SUM(Total) AS totalAmt, sum(qty) as totalQty  from COgs

</cfquery>
<cfquery name="sumQty">
select SUM(qty) AS totalQty  from vwCostOfGoodsUnion
where productid ='AMINODYN CAPSULE'
</cfquery>
<cfdump var="#COgs#">

<cfdump var="#sumAmount#">

<cfoutput>
Total Amount = #sumAmount.totalAmt#
<br>
Total Qty = #sumQty.totalQty#
<br>
<cfset AvgCost = #sumAmount.totalAmt# / #sumQty.totalQty# >
Avg Cost = #avgCost#
</cfoutput>
