<!doctype html>
<html>
<head>
<title><cfoutput>Refund Activities :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../style.js"></script>
</head>


<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<cfparam name="form.customerID" default="">
<cfparam name="form.accountID" default="">
<cfparam name="form.StartDate" default="">
<cfparam name="form.EndDate" default="">


<div id="Content">
<h4><cfif isdefined ("form.search")><cfoutput>#form.CustomerID# Refunds on #form.AccountID# Account(s) (#form.StartDate# - #form.EndDate#)</cfoutput><cfelse>Refund Activities</cfif></h4>
<div id="RightColumn">
<div align="right"> <a href="?">Reset</a>&nbsp;&nbsp;</div>
<p>
<cfparam name="url.print" default="">
<cfif url.print is "yes">
<cfdocument format="flashpaper" unit="in" margintop=".1" marginleft=".1" marginright=".3">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<style>
#row{
	font-size:11px;
}
</style>
<p>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="90%">
  <tr>
    <td colspan="2" valign="top"><font size="-1" face="Segoe UI"><strong>Refund Activities Report</strong></font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Account:</font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.AccountID#</font></strong></div></td>
  </tr>
  <tr>
    <td width="68" valign="top"><div align="left"><font face="Segoe UI" size="-2">Customer:</font></div></td>
    <td width="107" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2">#session.customerId#</font></strong></div></td>
    <td width="210"></td><td width="40" valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Date:</font></div></td><td width="128" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#Dateformat(session.startDate,"dd/mm/yyyy")# - #Dateformat(session.endDate,"dd/mm/yyyy")#</font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>
<br>
<br>
<br>


<cfquery name="Transact">
SELECT customerID, ID, Ref, refundDate, AccountID, ExpenseID, Amount, creator FROM vwRefund
WHERE refundDate >= #CreateODBCDate(session.StartDate)# AND refundDate <= #CreateODBCDate(session.EndDate)#
<cfif #session.AccountID# is "All">
		<cfelse> AND AccountID = <cfqueryparam value="#trim(session.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
<cfif #session.customerID# is "All">
		<cfelse> AND customerID = <cfqueryparam value="#trim(session.customerID)#"cfsqltype="cf_sql_clob">
        </cfif>
Order by refundDate
        </cfquery>

<cfquery name="TotalQty">
SELECT SUM(Amount) AS Amount1 FROM vwRefund
WHERE refundDate >= #CreateODBCDate(session.StartDate)# AND refundDate <= #CreateODBCDate(session.EndDate)# 
<cfif #session.AccountID# is "All">
		<cfelse> AND AccountID = <cfqueryparam value="#trim(session.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
<cfif #session.customerID# is "All">
		<cfelse> AND customerID = <cfqueryparam value="#trim(session.customerID)#"cfsqltype="cf_sql_clob">
        </cfif>
</cfquery>


<cfif #Transact.recordCount# eq 0>
  <h2>No Record Found! </h2>
  <cfelse>
  <table width="90%" border="0" cellpadding="1">
<tr id="row" bgcolor="#C0C0C0">
  <td width="10%"><strong>Date</strong></td>
  <td width="10%%"><strong>Ref.</strong></td>
  <td width="15%"><strong>Customer</strong></td>
  <td width="20%"><strong>Account</strong></td>
  <td width="25%"><strong>Expense</strong></td>
  <td width="5%"><strong>Staff</strong></td>
  <!--<td width="101" hidden="yes" ><div align="right"><strong>Cal</strong></div></td>--><td width="15%"><div align="right"><strong>Amount</strong></div></td>
</tr>
<cfoutput query="Transact">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr id="row" bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(RefundDate,"dd/mm/yyyy")#</td>
<td>#Ref#</td>
<td>#CustomerID#</td>
<td>#AccountID#</td>
<td>#expenseId#</td>
<td>#creator#</td>
<!--<td hidden="yes"><div align="right">

</div>
</td>-->
<td><div align="right">#numberformat(Amount,",000.00")#</div></td>
</tr>
</cfoutput>
<cfoutput>
<tr id="row">
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td><div align="right"><strong>#numberformat(TotalQty.Amount1,",000.00")#</strong></div></td>
</tr>

</cfoutput>

</table>
</cfif>
</div>
<cfoutput>
<cfdocumentitem type="footer">
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>

<cfelse>

<cfparam name="form.Search" default="">
<cfparam name="session.StartDate" default="">
<cfparam name="session.EndDate" default="">
<cfparam name="session.customerID" default="">
<cfparam name="session.AccountID" default="">

<cfif isdefined (form.Search)>
<cfset session.StartDate = "#Form.StartDate#">
<cfset session.EndDate = "#Form.EndDate#">
<cfset session.AccountID = "#form.AccountID#">
<cfset session.customerId = "#form.customerId#">
</cfif>

<cfquery name="account">
select accountID from accounts
order by accountID
</cfquery>
<cfquery name="customer">
select customerID from customers
order by customerID
</cfquery>
<cfform action="#cgi.SCRIPT_NAME#">
<table width="80%">
<tr>
<td width="20%">Starting:</td> <td width="20%">Ending:</td> <td width="25%">Customer:</td> <td width="25%">Account:</td><td width="10%"><a href="?print=1">Print</a></td>
</tr>
<tr>
<td><cfinput name="StartDate" type="datefield" placeholder="#dateformat(request.StartYear,"dd/mm/yyyy")#" required="yes" message="Enter valid date" mask="dd/mm/yyyy"></td>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" mask="dd/mm/yyyy"></td>
<td valign="top"><cfselect name="customerID" id="customerID" required="yes" message="Select Account">
<option value="All" selected>All</option>
<cfoutput query="customer">
      <option value="#customerID#">#customerID#</option>
      </cfoutput> </cfselect></td>
<td valign="top"><cfselect name="accountID" id="accountID">
<option value="All" selected>All</option>
<cfoutput query="account">
      <option value="#accountID#">#accountID#</option>
      </cfoutput>
</cfselect></td>
<td valign="top"><cfinput name="Search" value="Search" type="submit"></td>
</tr>
</table>
</cfform>

<cfif isdefined (form.Search)>

<cfset StartDate = #form.StartDate#>
<cfset StartDate = #Dateformat(StartDate,"dd/mm/yyyy")#>
<cfset EndDate = #form.EndDate#>
<cfset EndDate = #Dateformat(EndDate,"dd/mm/yyyy")#>
<cfset yyear = '#request.StartYear#'>
<cfset yyear = #Dateformat(CreateODBCDate(request.StartYear))#>

<cfset session.StartDate = "#StartDate#">
<cfset session.EndDate = "#EndDate#">
<cfset session.AccountID = "#form.AccountID#">
<cfset session.customerID = "#form.customerID#">

<cfquery name="Transact">
SELECT customerID, ID, Ref, refundDate, AccountID, ExpenseID, Amount, creator FROM vwRefund
WHERE refundDate >= #CreateODBCDate(StartDate)# AND refundDate <= #CreateODBCDate(EndDate)#
<cfif #form.AccountID# is "All">
		<cfelse> AND AccountID = <cfqueryparam value="#trim(form.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
<cfif #form.customerID# is "All">
		<cfelse> AND customerID = <cfqueryparam value="#trim(form.customerID)#"cfsqltype="cf_sql_clob">
        </cfif>
Order by refundDate
        </cfquery>

<cfquery name="TotalQty">
SELECT SUM(Amount) AS Amount1 FROM vwRefund
WHERE refundDate >= #CreateODBCDate(StartDate)# AND refundDate <= #CreateODBCDate(EndDate)# 
<cfif #form.AccountID# is "All">
		<cfelse> AND AccountID = <cfqueryparam value="#trim(form.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
<cfif #form.customerID# is "All">
		<cfelse> AND customerID = <cfqueryparam value="#trim(form.customerID)#"cfsqltype="cf_sql_clob">
        </cfif>
</cfquery>


<cfif #Transact.recordCount# eq 0>
  <h2> No Record Found!</h2>
  <cfelse>
<table width="90%" border="0" cellpadding="3">
<tr bgcolor="#C0C0C0">
  <td width="10%"><strong>Date</strong></td>
  <td width="10%%"><strong>Ref.</strong></td>
  <td width="15%"><strong>Customer</strong></td>
  <td width="20%"><strong>Account</strong></td>
  <td width="25%"><strong>Expense</strong></td>
  <td width="5%"><strong>Staff</strong></td>
  <!--<td width="101" hidden="yes" ><div align="right"><strong>Cal</strong></div></td>--><td width="15%"><div align="right"><strong>Amount</strong></div></td>
</tr>
<cfoutput query="Transact">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(RefundDate,"dd/mm/yyyy")#</td>
<td>#Ref#</td>
<td>#CustomerID#</td>
<td>#AccountID#</td>
<td>#expenseId#</td>
<td>#creator#</td>
<!--<td hidden="yes"><div align="right">

</div>
</td>-->
<td><div align="right">#numberformat(Amount,",000.00")#</div></td>
</tr>
</cfoutput>
<cfoutput>
<tr >
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td><div align="right"><strong>#numberformat(TotalQty.Amount1,",000.00")#</strong></div></td>
</tr>

</cfoutput>

</table>
</cfif>
</cfif>
</cfif>
</p>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>