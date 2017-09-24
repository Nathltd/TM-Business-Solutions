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

<cfset session.branchId = #form.branchId#>
<cfset session.StartDate = #createODBCDate(Dateformat(form.StartDate,"dd/mm/yyyy"))#>
<cfset session.EndDate = #createODBCDate(Dateformat(form.EndDate,"dd/mm/yyyy"))#>


<cfquery name="calc">
Select ProductID, UnitPrice, SUM(Qty) AS sumQty, SUM(Amt) As sumAmt
FROM vwSalesDetails2
WHERE SalesDate >= #CreateODBCDate(session.StartDate)# AND SalesDate <= #CreateODBCDate(session.EndDate)# AND BranchID = '#session.BranchID#'
GROUP BY ProductId, UnitPrice
</cfquery>
<cfquery name="calcTotal">
Select SUM(Amt) As sumAmt
FROM vwSalesDetails2
WHERE SalesDate >= #CreateODBCDate(session.StartDate)# AND SalesDate <= #CreateODBCDate(session.EndDate)# AND BranchID = '#session.BranchID#'
</cfquery>


<table width="95%">
<tr>
<td><strong>Product</strong></td><td><div align="right"><strong>Qty</strong></div></td><td><div align="right"><strong>Sales  (&##x20a6) </strong></div></td>
</tr>
<cfloop query="calc">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<cfquery name="inventory">
select costPrice from inventory
where productId = '#calc.ProductId#'
</cfquery>
<td>#calc.ProductID#</td><td><div align="right">#numberformat(calc.sumQty,",999")#</div></td><td><div align="right">#numberformat(calc.sumAmt,",999.00")#</div></td>
</tr>
</cfloop>
<tr>
<td colspan="5"><div align="right"> <strong>&##x20a6 #numberformat(calctotal.sumAmt,",999.00")#</strong></div></td>
</tr>
</table>

</cfif>
</cfoutput>
</div>
</div>
</div>
</body>
</html>