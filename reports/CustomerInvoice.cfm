<!doctype html>
<html>
<head>
<title><cfoutput>Customers Invoice List :: #request.title#</cfoutput></title>
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

<br />
<h4>Customers' Invoice <cfif not isdefined(form.search)>(Last 100)</cfif></h4>
<br />
<div id="RightColumn">

<cfform>
<cfquery name="branch">
select branchid from branches
order by branchid
</cfquery>
<table width="65%" cellpadding="2">
<tr>
<td>Start Date:</td><td> <cfinput type="datefield" name="startDate" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"mm/dd/yyyy")#" style="width:100%" required="Yes"></td>
<td>End Date:</td><td> <cfinput type="datefield" name="endDate" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"mm/dd/yyyy")#" style="width:100%" required="Yes"></td>
<td>Branch:</td><td valign="top"> <cfselect name="Branch" style="width:100%">
						<option value="All">All</option>
						<cfoutput query="branch">
                        <option value="#branchId#">#branchid#</option>
                        </cfoutput>
                        </cfselect>
                        </td>
</tr>
<tr>
<td colspan="6" align="right"><cfinput type="submit" value="Search" name="Search"></td>
</tr>
</table>
</cfform>
  
    
<cfif isdefined(form.Search)>
<cfset startDate = #CreateODBCDate(dateformat(form.startDate,"dd/mm/yyyy"))#>
<cfset endDate = #CreateODBCDate(dateformat(form.endDate,"dd/mm/yyyy"))#>
<cfset datedif = #datediff("d",startDate,enddate)#>

<cfif #datedif# lt 0>
<h3>Range Less than 1 day. Please Adjust.</h3>
<cfabort>
</cfif>
<cfif #datedif# gt 31>
<h3>Range greater than 31 days. Please Adjust.</h3>
<cfabort>
</cfif>

<cfquery name="invoiceAll">
SELECT ID, SalesID, SalesDate, CustomerId, BranchId, TotalAmount, AmountPaid
FROM vwCustInvoiceTotalAmt
WHERE SalesDate between #startdate# and #endDate#
	<cfif #form.branch# is "All">
		<cfelse>AND branchId = '#form.branch#'</cfif>
ORDER BY SalesDate desc 
  </cfquery>
  <cfif #invoiceAll.RecordCount# eq 0>
<h3>No Invoice Avaliable For This Period.</h3>
<cfabort>
</cfif>
  <table width="90%" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td><strong>Date</strong></td><td><strong>Invoice No.</strong></td><td ><div><strong>Customer</strong></div></td><td ><div align="left"><strong>Branch</strong></div></td><td><div align="right"><strong>Total Amount</strong></div></td><td><div align="right"><strong>Amount Paid</strong></div></td>
</tr>
<cfoutput query="invoiceAll">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(salesDate,"dd/mm/yyyy")#</td><td><a href="../invoices/#request.invoiceFormat#.cfm?CFGRIDKEY=#salesid#">#salesId#</a></td><td><div align="left"><cfset Sales = #salesId#>
<cfset customer = #customerId#>

<cfquery name="genCustomer">
select customerId from CustomersGen
where salesid = #sales#
</cfquery>

<cfif #customerId# is 'general'>
<cfset customer = '#genCustomer.customerId#'>
</cfif>

#customer#</div></td><td><div align="left">#BranchId#</div></td><td><div align="right">#totalAmount#</div></td><td><div align="right">#amountPaid#</div></td>
</tr>
</cfoutput>

</table>
  
<cfelse>
<cfquery name="invoices" maxrows="100">
SELECT ID, SalesID, SalesDate, CustomerId, BranchId, TotalAmount, AmountPaid, type
FROM vwCustInvoiceTotalAmt
order by salesDate desc 
  </cfquery>
<div align="center">
<table width="90%" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td><strong>Date</strong></td><td><strong>Invoice No.</strong></td><td ><div><strong>Customer</strong></div></td><td ><div align="left"><strong>Branch</strong></div></td><td><div align="right"><strong>Total Amount</strong></div></td><td><div align="right"><strong>Amount Paid</strong></div></td>
</tr>
<cfoutput query="invoices">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(salesDate,"dd/mm/yyyy")#</td><td><cfif #type# is 'Order'><a href="../invoices/#request.invoiceFormat#.cfm?CFGRIDKEY=#salesid#&type=order">#salesId#</a>(Order)<cfelse> <a href="../invoices/#request.invoiceFormat#.cfm?CFGRIDKEY=#salesid#">#salesId#</a></cfif></td><td>
<div align="left">
  <cfset Sales = #salesId#>
<cfset customer = #customerId#>

<cfquery name="genCustomer">
select customerId from CustomersGen
where salesid = #sales#
</cfquery>

<cfif #customerId# is 'general'>
<cfset customer = '#genCustomer.customerId#'>
</cfif>

#customer#</div></td><td><div align="left">#BranchId#</div></td><td><div align="right">#totalAmount#</div></td><td><div align="right">#amountPaid#</div></td>
</tr>
</cfoutput>

</table>
</div>
</cfif>
</div>


</div>  
</div>
</body>
</html>