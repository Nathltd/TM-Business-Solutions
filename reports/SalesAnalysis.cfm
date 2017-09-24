<!doctype html>
<html>
<head>
<title><cfoutput>Sales Analysis :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>

<style>
#salesDateId {
	background-color:#09C;
}
</style>
</head>


<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">

<h4>Sales Analysis Report</h4>
<div id="RightColumn">



<cfparam name="form.search" default="">
<div align="right">&nbsp;</div><br>
<cfquery name="months">
select * from Months
</cfquery>
<cfquery name="Branch">
select * from Branches
Order by BranchId
</cfquery>
<cfquery name="customers">
select * from customers
Order by CustomerId
</cfquery>

<cfoutput>
<cfform  action="#cgi.SCRIPT_NAME#">
<table width="71%" cellpadding="2">
<tr>
<td width="25%">
<label for="startDate">Start Date</label>
</td>
<td width="25%">
<label for="endDate">End Date</label>
</td>
<td width="20%">Customer</td>
<td width="15%">
<label for="bBranch">Branch</label>
</td>
<td width="5%">
</td>
<td width="15%">
</td>
</tr>
<tr>
<td valign="bottom">
<cfinput name="startDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" style="width:100%" required="yes" mask="dd/mm/yyyy" message="Enter Starting Date">
</td>
<td valign="bottom">
<cfinput name="endDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" style="width:100%" required="yes" mask="dd/mm/yyyy" message="Enter Starting Date">
</td>
<td valign="top">
<cfselect name="customerId" style="width:100%">
<option value="All">All</option>
<cfloop query="customers">
<option value="#customerId#">#customerId#</option>
</cfloop>
</cfselect>
</td>
<td valign="top">
<cfselect name="bBranch" style="width:100%">
<option value="All">All</option>
<cfloop query="Branch">
<option value="#BranchID#">#BranchID#</option>
</cfloop>
</cfselect>
</td>
<td valign="top">
<div align="right">
<cfinput name="search" value="Search" type="submit">
</div>
</td>
<td valign="top" align="right"><a href="?print=All"> Print </a> </td>
</tr>
</table>
<br>

</cfform>


<cfif isdefined(form.search)>
<cfset session.customerId = '#form.customerId#'>
<cfset session.branch = '#form.bBranch#'>
<cfset session.startDate = '#form.startDate#'>
<cfset session.endDate = '#form.endDate#'>

<cfquery name="calcNew">
Select ID,BranchID,SalesID,SalesDate, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit, customerId
FROM vwSalesDetails
WHERE SalesDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #Session.customerId# is "All">
        <cfelse>
        AND customerId = '#session.customerId#'
        </cfif>
		<cfif #Session.Branch# is "All">
        <cfelse>
        AND BranchID = '#session.branch#'
        </cfif>
        ORDER BY SalesID, SalesDate
</cfquery>

<cfquery name="calcDate">
Select distinct SalesDate
FROM vwSalesDetails
WHERE SalesDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #Session.Branch# is "All">
        <cfelse>
        AND BranchID = '#session.branch#'
        </cfif>
ORDER BY SalesDate
</cfquery>

<cfif #calcDate.recordCount# is 0>

<h1> No record Found! </h1>
<cfelse>

<table width="80%" id="titleTable">
</table>
<table width="90%">

<cfloop query="calcDate">
<tr>
<td align="left" colspan="6" id="salesDateId"><strong> Date: #dateformat(calcDate.SalesDate,"dd/mm/yyyy")# </strong></td>
</tr>
<tr>
<td>

<cfquery name="calcSalesId">
Select distinct SalesID, CustomerID, staffId, Phone
FROM vwSalesDetails
WHERE SalesDate = <cfqueryparam value="#dateformat(calcDate.SalesDate,"mm/dd/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #Session.customerId# is "All">
        <cfelse>
        AND customerId = '#session.customerId#'
        </cfif>
		<cfif #Session.Branch# is "All">
		<cfelse>
		AND BranchID = '#session.branch#'
		</cfif>
ORDER BY SalesID
</cfquery>


<cfloop query="calcSalesId">
<cfset genCustomer = #calcSalesId.SalesID#>
<cfquery name="genInvoice">
SELECT CustomersGen.CustomerID, Sales.SalesID, CustomersGen.phone
FROM Sales INNER JOIN CustomersGen ON Sales.SalesID = CustomersGen.SalesID
Where Sales.SalesID = #genCustomer#
</cfquery>
<cfif genInvoice.Recordcount eq 1>
<cfset #calcSalesId.Phone# = #genInvoice.Phone#>
<cfset #calcSalesId.CustomerID# = #genInvoice.CustomerID#>
</cfif>
<strong> #calcSalesId.currentRow#.&nbsp;
 Invoice No: #calcSalesId.SalesID# </strong>&nbsp;&nbsp;&nbsp;&nbsp;<strong> Customer Id: #calcSalesId.CustomerID# </strong>&nbsp;&nbsp;&nbsp;&nbsp;<strong> Customer Phone: #calcSalesId.Phone# </strong>&nbsp;&nbsp;&nbsp;&nbsp;<strong> Staff Code: #calcSalesId.StaffId# </strong>

<cfquery name="calc">
Select ID,BranchID,SalesID,SalesDate, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit, discount
FROM vwSalesDetails
WHERE SalesID = #calcSalesId.SalesID#
ORDER BY SalesID
</cfquery>

<cfquery dbtype="query" name="calcDtls">
SELECT  SUM(CostAmt) AS CostAmt, SUM(Amt) AS Amt, SUM(discount) AS discount, SUM(Profit) AS Profit
FROM calc
</cfquery>
<cfquery dbtype="query" name="calcDtls2">
SELECT  SUM(CostAmt) AS CostAmt, SUM(Amt) AS Amt2, SUM(Profit) AS Profit
FROM calcNew
</cfquery>


<table width="100%" id="detailTable">
<tr>
<td width="30%">Product</td><td width="30%">Description</td><td width="10%"><div align="right">Unit Price</div></td><td width="10%"><div align="right">Quantity</div></td><td width="10%"><div align="right">Discount</div></td><td width="10%"><div align="right">Amount</div></td>
</tr>

<cfloop query="calc">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td width="100">#calc.ProductID#</td><td width="220">#calc.Description#</td><td width="50"><div align="right">#numberformat(calc.UnitPrice,",999.00")#</div></td><td width="50"><div align="right">#numberformat(calc.Qty,",999")#</div></td><td width="50"><div align="right">#numberformat(calc.discount,",999")#</div></td><td width="80"><div align="right">#numberformat(calc.Amt,",999.00")#</div></td>
</tr>
</cfloop>
<tr>
<td></td><td></td><td></td><td><div align="right"><strong></strong></div></td><td><div align="right"><strong>#numberformat(calcDtls.discount,",999.00")#</strong></div></td><td><div align="right"><strong>#numberformat(calcDtls.Amt,",999.00")#</strong></div></td>
</tr>
</table>
</cfloop>



</td>
</tr>
</cfloop>
<table width="90%">
<tr>
<td><div align="right"><strong>Total:</strong></div></td><td width="10%"><div align="right"><strong>#numberformat(calcDtls2.amt2,",999.00")#</strong></div></td>
</tr>
</table>

</table>
</cfif>
</cfif>
<cfparam name="url.print" default="">
</cfoutput>


<cfif #url.print# is "All">
<cfdocument format="flashpaper" unit="in" margintop=".3" marginleft=".3" marginright=".3" marginbottom=".3">
<style>
#row{
	font-size:11px;
}
</style>
<cfoutput>
<div align="left">
<img src="../shared/TMlogoSmall3.jpg" width="50" height="37"><br>

<font size="+4" face="Segoe UI">#request.Company#</font><br>
<font size="1">#request.CompanyAddress#</font><br>
<font size="1">Tel: #request.CompanyPhone#</font><br>
<br>
<br>
<cfquery name="calcDate">
Select distinct SalesDate
FROM vwSalesDetails
WHERE SalesDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #Session.Branch# is "All">
        <cfelse>
        AND BranchID = '#session.branch#'
        </cfif>
ORDER BY SalesDate
</cfquery>

<table width="100%">

<cfloop query="calcDate">
<tr id="row">
<td align="left" colspan="6" id="salesDateId"><strong> Date: #dateformat(calcDate.SalesDate,"dd/mm/yyyy")# </strong></td>
</tr>
<tr id="row">
<td>
<cfquery name="calcNew">
Select ID,BranchID,SalesID,SalesDate, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit, customerId
FROM vwSalesDetails
WHERE SalesDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #Session.customerId# is "All">
        <cfelse>
        AND customerId = '#session.customerId#'
        </cfif>
		<cfif #Session.Branch# is "All">
        <cfelse>
        AND BranchID = '#session.branch#'
        </cfif>
        ORDER BY SalesID, SalesDate
</cfquery>

<cfquery name="calcSalesId">
Select distinct SalesID, CustomerID,phone, staffId
FROM vwSalesDetails
WHERE SalesDate = <cfqueryparam value="#dateformat(calcDate.SalesDate,"mm/dd/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #Session.customerId# is "All">
        <cfelse>
        AND customerId = '#session.customerId#'
        </cfif>
		<cfif #Session.Branch# is "All">
		<cfelse>
		AND BranchID = '#session.branch#'
		</cfif>
ORDER BY SalesID
</cfquery>
<cfloop query="calcSalesId">
<strong> #calcSalesId.currentRow#.&nbsp;
 Invoice No: #calcSalesId.SalesID# </strong>&nbsp;&nbsp;&nbsp;&nbsp;<strong> Customer Id: #calcSalesId.CustomerID# </strong>&nbsp;&nbsp;&nbsp;&nbsp;<strong> Customer Phone: #calcSalesId.Phone# </strong>&nbsp;&nbsp;&nbsp;&nbsp;<strong> Staff Code: #calcSalesId.StaffId# </strong>

<cfquery name="calc">
Select ID,BranchID,SalesID,SalesDate, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit, discount
FROM vwSalesDetails
WHERE SalesID = #calcSalesId.SalesID#
ORDER BY SalesID
</cfquery>

<cfquery dbtype="query" name="calcDtls">
SELECT  SUM(CostAmt) AS CostAmt, SUM(Amt) AS Amt, SUM(discount) AS discount, SUM(Profit) AS Profit
FROM calc
</cfquery>
<cfquery dbtype="query" name="calcDtls2">
SELECT  SUM(CostAmt) AS CostAmt, SUM(Amt) AS Amt2, SUM(Profit) AS Profit
FROM calcNew
</cfquery>

<table width="100%" id="detailTable">
<tr id="row">
<td width="30%">Product</td><td width="30%">Description</td><td width="10%"><div align="right">Unit Price</div></td><td width="10%"><div align="right">Quantity</div></td><td width="10%"><div align="right">Discount</div></td><td width="10%"><div align="right">Amount</div></td>
</tr>

<cfloop query="calc">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr id="row" bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td width="100">#calc.ProductID#</td><td width="220">#calc.Description#</td><td width="50"><div align="right">#numberformat(calc.UnitPrice,",999.00")#</div></td><td width="50"><div align="right">#numberformat(calc.Qty,",999")#</div></td><td width="50"><div align="right">#numberformat(calc.discount,",999")#</div></td><td width="80"><div align="right">#numberformat(calc.Amt,",999.00")#</div></td>
</tr>
</cfloop>
<tr id="row">
<td></td><td></td><td></td><td><div align="right"><strong></strong></div></td><td><div align="right"><strong>#numberformat(calcDtls.discount,",999.00")#</strong></div></td><td><div align="right"><strong>#numberformat(calcDtls.Amt,",999.00")#</strong></div></td>
</tr>
</table>
</cfloop>



</td>
</tr>
</cfloop>
<table width="97%">
<tr id="row">
<td width="100%"><div align="right"><strong>Total:</strong></div></td><td><div align="right"><strong>#numberformat(calcDtls2.amt2,",999.00")#</strong></div></td>
</tr>
</table>


</table>
</div>
</div>
<cfdocumentitem type="footer">

Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#

</cfdocumentitem><br>
</cfoutput>
</cfdocument>
</cfif>

</div>
</div>
</div>
</body>
</html>