<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>

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
<table width="650">
<tr>
<td width="125">
<label for="startDate">Start Date</label>
</td>
<td width="125">
<label for="endDate">End Date</label>
</td>
<td width="125">Customer</td>
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
<cfselect name="customerId">
<option value="All">All</option>
<cfloop query="customers">
<option value="#customerId#">#customerId#</option>
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
<cfset session.customerId = '#form.customerId#'>
<cfset session.branch = '#form.bBranch#'>
<cfset session.startDate = '#form.startDate#'>
<cfset session.endDate = '#form.endDate#'>

<cfquery name="calcNew">
Select ID,BranchID,SalesDate, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit, customerId
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

</cfquery>

<cfquery name="calcProduct">
Select distinct ProductID, Description
FROM vwSalesDetails
WHERE SalesDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
ORDER BY ProductID asc
</cfquery>

<cfif #calcProduct.recordCount# is 0>

<h1> No record Found! </h1>
<cfelse>

<table width="623" cellpadding="5" cellspacing="5" id="titleTable">
<tr>
<td width="30" align="right"><strong>S/N</strong></td><td width="164"><strong>Item</strong></td><td width="205"><strong>Description</strong></td><td width="51"><div align="right"><strong>Price</strong></div></td><td width="55"><div align="right"><strong>Qty</strong></div></td>
<td width="45"><div align="right"><strong>Amount</strong></div></td>
</tr>

<cfloop query="calcProduct">
<tr>
<td width="30" align="right"><strong>#currentRow#</strong></td><td width="164"><strong>#productid#</strong></td><td width="205"><strong>#Description#</strong></td><td width="51"><div align="right"><strong>UnitPrice</strong></div></td><td width="55"><div align="right"><strong>Qty</strong></div></td>
<td width="45"><div align="right"><strong>Amount</strong></div></td>
</tr>
</cfloop>


</table>
</cfif>
</cfif>
</cfoutput></div>
</div>
</div>
</body>
</html>