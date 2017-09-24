<!doctype html>
<html>
<head>
<title><cfoutput>Sales Profit Analysis :: #request.title#</cfoutput></title>
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
<h4>Sales Valuation<cfoutput> <cfif isdefined(form.search)> between #StartDate# and #endDate# for #branchId#</cfif></cfoutput></h4>
<div id="RightColumn">


<cfoutput>

<cfform action="#cgi.SCRIPT_NAME#">
<table width="70%" cellpadding="2" border="0" >
<tr>
<td width="30%">Starting:</td> <td width="30%">Ending:</td> <td width="30%">Branch:</td> <td width="10%"></td>
</tr>
<tr>
<td><cfinput name="StartDate" type="datefield" placeholder="#dateFormat(request.StartYear,"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td valign="top"><cfselect name="BranchID" id="BranchID" required="yes" message="Select Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" style="width:100%"> </cfselect></td>
<td valign="top"><cfinput name="Search" value="Search" type="submit"></td>
</tr>
</table>
</cfform>


<cfif isdefined(form.search)>

<cfset branchId = #form.branchId#>
<cfset StartDate = #createODBCDate(Dateformat(form.StartDate,"dd/mm/yyyy"))#>
<cfset EndDate = #createODBCDate(Dateformat(form.EndDate,"dd/mm/yyyy"))#>


<cfquery name="calc">
Select ID,BranchID,SalesID,SalesDate, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit
FROM vwSalesDetails
WHERE SalesDate >= #CreateODBCDate(StartDate)# AND SalesDate <= #CreateODBCDate(EndDate)# AND BranchID = '#BranchID#'
ORDER BY SalesID
</cfquery>

<cfquery name="Summ" dbtype="query">
select SUM(profit) AS TotalProfit
from calc
</cfquery>

<table width="95%">
<tr>
<td><strong>Invoice ##</strong></td><td><strong>Product</strong></td><td><strong>Description</strong></td><td><div align="right"><strong>C/Price (&##x20a6) </strong></div></td><td><div align="right"><strong>S/Price  (&##x20a6) </strong></div></td><td><div align="right"><strong>Qty</strong></div></td><td><div align="right"><strong>Cost  (&##x20a6) </strong></div></td><td><div align="right"><strong>Sales  (&##x20a6) </strong></div></td><td><div align="right"><strong>Profit  (&##x20a6) </strong></div></td>
</tr>
<cfloop query="calc">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<cfquery name="inventory">
select costPrice from inventory
where productId = '#calc.ProductId#'
</cfquery>
<cfset value = #inventory.costPrice# * #calc.Qty#>
<cfset totalAmt = #calc.Amt#>
<cfset gain = #totalAmt# - #value#>
<td>#calc.SalesID#</td><td>#calc.ProductID#</td><td>#calc.Description#</td><td><div align="right">#numberformat(CostPrice,",999.00")#</div></td><td><div align="right">#numberformat(calc.UnitPrice,",999.00")#</div></td><td><div align="right">#numberformat(calc.Qty,",999")#</div></td><td><div align="right">#numberformat(costAmt,",999.00")#</div></td><td><div align="right">#numberformat(calc.Amt,",999.00")#</div></td><td><div align="right">#numberformat(profit,",999.00")#</div></td>
</tr>
</cfloop>
<tr>
<td colspan="10"><div align="right"> <strong>&##x20a6 #numberformat(summ.TotalProfit,",999.00")#</strong></div></td>
</tr>
</table>

</cfif>
</cfoutput>
</div>
</div>
</div>
</body>
</html>