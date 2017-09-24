<!doctype html>
<html>
<head>
<title><cfoutput>Profit & Loss :: #request.title#</cfoutput></title>
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

<h4>Profit &amp; Loss Report</h4>
<div id="RightColumn">

<cfset thisyear=year(#request.clsDate#)>
<cfset curmonth=Month(now())>
<cfif #curmonth# eq 1>
  <cfset prevmonth=12>
  <cfset prev2month=11>
<cfelse>
  <cfset prevmonth=#curmonth# - 1>
  <cfset prev2month=#curmonth# - 2>
</cfif>
<cfset curyear=Year(now())>
<cfset prevyear=#curyear# - 1>



<cfparam name="url.print" default="">
<cfif url.print is "yes">


<cfquery name="calc">
Select ID,BranchID,SalesID,Month(SalesDate) AS mMonth, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit
FROM vwSalesDetails
WHERE SalesDate >= #CreateODBCDate(request.StartYear)#
<cfif #Session.Branch# is "All">
<cfelse>
AND BranchID = '#session.branch#'
</cfif>
ORDER BY SalesDate
</cfquery>

<cfquery dbtype="query" name="calcDtls">
SELECT  SUM(CostAmt) AS CostAmt, SUM(Amt) AS Amt, SUM(Profit) AS Profit
FROM calc
WHERE mMonth = #session.mMonth#
</cfquery>

<cfquery name="expense">
SELECT VendorID, ID, Type, Ref, Month(ExpenseDate) AS mMonth, ExpenseID, AccountID, Amount, Details
FROM vwExpenses
WHERE ExpenseDate >= #CreateODBCDate(request.StartYear)#
<cfif #session.Branch# is "All">
<cfelse>
AND AccountID = '#session.branch#'
</cfif>
</cfquery>

<cfquery dbtype="query" name="calcExp">
SELECT  SUM(Amount) AS Amount
FROM expense
WHERE mMonth = #session.mMonth#
</cfquery>

<cfset netProfit = #Val(calcDtls.Profit)#-#Val(calcExp.Amount)#>

<cfdocument format="flashpaper" unit="in" margintop=".1">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="577">
  <tr>
    <td colspan="2" valign="top"><font size="-1" face="Segoe UI">Profit &amp; Loss Report</font></td>
    <td></td>
    <td valign="baseline">&nbsp;</td>
    <td valign="baseline">&nbsp;</td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2">Branch:</font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2">#session.Branch#</font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline">&nbsp;</td><td width="127" valign="baseline">&nbsp;</td>
</tr>
  <tr>
    <td valign="top"><div align="left"><font face="Segoe UI" size="-2">Month:</font></div></td>
    <td valign="top"><div align="left"><strong><font face="Segoe UI" size="-2">#monthasstring(session.mMonth)#</font></strong></div></td>
    <td></td>
    <td valign="baseline">&nbsp;</td>
    <td valign="baseline">&nbsp;</td>
  </tr>
</table>



<table width="286">
<tr height="30" valign="top">
<td colspan="2" ><div align="right">Amount in Naira</div></td>
</tr>
<tr>
<td  colspan="2"></td>
</tr>
<tr>
<td width="105"><strong>Revenue:</strong></td><td width="154"> <div align="right">#numberformat(calcDtls.Amt,",999.99")#</div></td>
</tr>
<tr>
<td><strong>COGS: </strong></td><td> <div align="right">#numberformat(calcDtls.CostAmt,",999.99")#</div></td>
</tr>
<tr>
<td><strong>Gross Profit:</strong></td><td> <div align="right">#numberformat(calcDtls.Profit,",999.99")#</div></td>
</tr>
<tr>
<td><strong>Expense:</strong></td><td> <div align="right">#numberformat(calcExp.Amount,",999.99")#</div></td>
</tr>
<tr>
<td><strong>Net Profit:</strong></td><td> <div align="right">#numberformat(netProfit,",999.99")#</div></td>
</tr>
</table>
</cfoutput>
</div>
<cfoutput>
<cfdocumentitem type="footer">
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>

<cfelse>

<cfparam name="form.search" default="">
<div align="right"><a href="?print=1">Print</a>&nbsp;</div>
<cfquery name="months">
select * from Months
</cfquery>
<cfquery name="Branch">
select * from Branches
</cfquery>

<cfoutput>
<cfform  action="#cgi.SCRIPT_NAME#">
<table width="40%" cellpadding="2">
<tr>
<td width="10%">
<label for="dMonth">Month</label>
</td>
<td width="40%">
<cfselect name="mMonth" style="width:100%">
<cfloop query="months">
<option value="#ID#">#monthID#</option>
</cfloop>
</cfselect>
</td>
<td width="10%">
<label for="bBranch">Branch</label>
</td>
<td width="40%">
<cfselect name="bBranch" style="width:100%">
<option value="All">All</option>
<cfloop query="Branch">
<option value="#BranchID#">#BranchID#</option>
</cfloop>
</cfselect>
</td>
</tr>
<tr>
<td colspan="5" width="15%">
<div align="right">
<cfinput name="search" value="Search" type="submit">
</div>
</td>
</tr>
</table>
</cfform>


<cfparam name="form.search" default="">
<cfif isdefined(form.search)>
<cfset session.branch = '#form.bBranch#'>
<cfset session.mMonth = '#form.mMonth#'>


<cfquery name="calc">
Select ID,BranchID,SalesID,Month(SalesDate) AS mMonth, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit
FROM vwSalesDetails
WHERE SalesDate >= #CreateODBCDate(request.StartYear)#
<cfif #Session.Branch# is "All">
<cfelse>
AND BranchID = '#session.branch#'
</cfif>
ORDER BY SalesDate
</cfquery>

<cfquery dbtype="query" name="calcDtls">
SELECT  SUM(CostAmt) AS CostAmt, SUM(Amt) AS Amt, SUM(Profit) AS Profit
FROM calc
WHERE mMonth = #session.mMonth#
</cfquery>

<cfquery name="expense">
SELECT VendorID, ID, Type, Ref, Month(ExpenseDate) AS mMonth, ExpenseID, AccountID, Amount, Details
FROM vwExpenses
WHERE ExpenseDate >= #CreateODBCDate(request.StartYear)#
<cfif #session.Branch# is "All">
<cfelse>
AND AccountID = '#session.branch#'
</cfif>
</cfquery>

<cfquery dbtype="query" name="calcExp">
SELECT  SUM(Amount) AS Amount
FROM expense
WHERE mMonth = #session.mMonth#
</cfquery>

<cfset netProfit = #Val(calcDtls.Profit)#-#Val(calcExp.Amount)#>

<cfoutput>
<table width="36%" cellpadding="2">
<tr bgcolor="FFFFFF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >
<td width="200" >Month: <strong>#monthasstring(session.mMonth)#</strong></td><td ><div align="right">Branch: <strong>#session.branch#</strong></div></td>
</tr>
<tr bgcolor="FFFFFF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >
<td  colspan="2"></td>
</tr>
<tr bgcolor="D5D5FF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='D5D5FF';" >
<td>Revenue:</td><td width="179"> <div align="right">#numberformat(calcDtls.Amt,",999.99")#</div></td>
</tr>
<tr bgcolor="FFFFFF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >
<td>COGS: </td><td> <div align="right">#numberformat(calcDtls.CostAmt,",999.99")#</div></td>
</tr>
<tr bgcolor="D5D5FF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='D5D5FF';" >
<td>Gross Profit:</td><td> <div align="right">#numberformat(calcDtls.Profit,",999.99")#</div></td>
</tr>
<tr bgcolor="FFFFFF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='FFFFFF';" >
<td>Expense:</td><td> <div align="right">#numberformat(calcExp.Amount,",999.99")#</div></td>
</tr>
<tr bgcolor="D5D5FF" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='D5D5FF';" >
<td>Net Profit:</td><td> <div align="right">#numberformat(netProfit,",999.99")#</div></td>
</tr>
</table>
</cfoutput>
</cfif>
</cfoutput>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>