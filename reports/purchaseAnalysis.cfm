<!doctype html>
<html>
<head>
<title><cfoutput>Purchase Analysis :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>

<style>
#salesDateId {
	background-color:#09C;
}
</style></head>

<body>



<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">

<h4>Purchase Analysis Report</h4>
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
<cfquery name="vendors">
select * from vendors
Order by vendorId
</cfquery>

<cfoutput>
<cfform  action="#cgi.SCRIPT_NAME#">
<table width="70%">
<tr>
<td width="125">
<label for="startDate">Start Date</label>
</td>
<td width="125">
<label for="endDate">End Date</label>
</td>
<td width="125">Supplier</td>
<td width="157">
<label for="bBranch">Branch</label>
</td>
<td width="63">
</td>
</tr>
<tr>
<td width="125">
<cfinput name="startDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" size="10" required="yes" mask="dd/mm/yyyy" message="Enter Starting Date">
</td>
<td width="125">
<cfinput name="endDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" size="10" required="yes" mask="dd/mm/yyyy" message="Enter Starting Date">
</td>
<td width="125">
<cfselect name="vendorId">
<option value="All">All</option>
<cfloop query="vendors">
<option value="#vendorId#">#vendorId#</option>
</cfloop>
</cfselect>
</td>
<td width="157">
<cfselect name="bBranch">
<option value="All">All</option>
<cfloop query="Branch">
<option value="#BranchID#">#BranchID#</option>
</cfloop>
</cfselect>
</td>
<td width="63">
<div align="right">
<cfinput name="search" value="Search" type="submit">
</div>
</td>
</tr>
</table>
</cfform>


<cfif isdefined(form.search)>
<cfset session.vendorId = '#form.vendorId#'>
<cfset session.branch = '#form.bBranch#'>
<cfset session.startDate = '#form.startDate#'>
<cfset session.endDate = '#form.endDate#'>

<cfquery name="calcNew">
Select ID, BranchId, VendorID, ReceiptID, ReceiptDate, ProductId, Description, Qty,UnitPrice, Amt
FROM vwPurchaseDetails
WHERE ReceiptDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #Session.vendorId# is "All">
        <cfelse>
        AND vendorId = '#session.vendorId#'
        </cfif>
		<cfif #Session.Branch# is "All">
        <cfelse>
        AND BranchID = '#session.branch#'
        </cfif>
        ORDER BY ReceiptID, ReceiptDate asc
</cfquery>

<cfquery name="calcDate">
Select distinct ReceiptDate
FROM vwPurchaseDetails
WHERE ReceiptDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
ORDER BY ReceiptDate
</cfquery>

<cfif #calcDate.recordCount# is 0>

<h1> No record Found! </h1>
<cfelse>

<table width="70%" id="titleTable">
<tr>
<td width="30%"><strong>Item</strong></td><td width="30%"><strong>Description</strong></td><td width="10%"><div align="right"><strong>Price</strong></div></td><td width="10%"><div align="right"><strong>Qty</strong></div></td><td width="10%"><div align="right"><strong>Amount</strong></div></td>
</tr>
</table>
<table width="70%">

<cfloop query="calcDate">
<tr>
<td align="left" colspan="6" id="salesDateId"><strong> Date: #dateformat(calcDate.ReceiptDate,"dd/mm/yyyy")# </strong></td>
</tr>
<tr>
<td>

<cfquery name="calcSalesId">
Select distinct ReceiptID, VendorID
FROM vwPurchaseDetails
WHERE ReceiptDate = <cfqueryparam value="#dateformat(calcDate.ReceiptDate,"mm/dd/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #Session.VendorID# is "All">
        <cfelse>
        AND VendorID = '#session.VendorID#'
        </cfif>
		<cfif #Session.Branch# is "All">
		<cfelse>
		AND BranchID = '#session.branch#'
		</cfif>
ORDER BY ReceiptID
</cfquery>
<cfloop query="calcSalesId">
<strong> #calcSalesId.currentRow#.&nbsp;
 Invoice No: #calcSalesId.ReceiptID# </strong>&nbsp;&nbsp;&nbsp;&nbsp;<strong> Supplier Id: #calcSalesId.VendorID# </strong>

<cfquery name="calc">
Select ID,BranchID,ReceiptID,ReceiptDate, ProductID, Description, UnitPrice, Qty,  Amt
FROM vwPurchaseDetails
WHERE ReceiptID = '#calcSalesId.ReceiptID#'
ORDER BY ReceiptID
</cfquery>

<cfquery dbtype="query" name="calcDtls">
SELECT  SUM(Amt) AS Amt
FROM calc
</cfquery>
<cfquery dbtype="query" name="calcDtls2">
SELECT  SUM(Amt) AS Amt2
FROM calcNew
</cfquery>

<table width="100%" id="detailTable">

<cfloop query="calc">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td width="30%">#calc.ProductID#</td><td width="30%">#calc.Description#</td><td width="10%"><div align="right">#numberformat(calc.UnitPrice,",999.00")#</div></td><td width="10%"><div align="right">#numberformat(calc.Qty,",999")#</div></td><td width="10%"><div align="right">#numberformat(calc.Amt,",999.00")#</div></td>
</tr>
</cfloop>
<tr>
<td></td><td></td><td><div align="right"><strong></strong></div></td><td><div align="right"></div></td><td><div align="right"><strong>#numberformat(calcDtls.Amt,",999.00")#</strong></div></td>
</tr>
</table>
</cfloop>



</td>
</tr>
</cfloop>
<table width="70%">
<tr>
<td colspan="5" width="300"><div align="right"><strong>Total:</strong></div></td><td><div align="right"><strong>#numberformat(calcDtls2.amt2,",999.00")#</strong></div></td>
</tr>
</table>

</table>
</cfif>
</cfif>
</cfoutput></div>
</div>
</div>
</body>
</html>