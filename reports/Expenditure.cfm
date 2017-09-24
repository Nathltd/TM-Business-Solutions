<!doctype html>
<html>
<head>
<title><cfoutput>Expenditures :: #request.title#</cfoutput></title>
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

<h4><cfoutput><cfif isdefined(form.search)>#form.AccountID#</cfif></cfoutput>&nbsp;Expenditure Report</h4>
<div id="RightColumn">

<cfset thisyear=year(now())>
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

<cfquery name="months">
select * from Months
</cfquery>
<cfquery name="Account">
select * from Accounts
</cfquery>

<cfoutput>

<cfform  action="#cgi.SCRIPT_NAME#">
<table width="296">
<tr>
<td width="101">
<label for="dMonth">Month</label>
</td>
<td width="100">
<label for="bBranch">Branch</label>
</td>
<td width="79">
</td>
</tr>
<tr>
<td width="101">
<cfselect name="mMonth">
<cfloop query="months">
<option value="#ID#">#monthID#</option>
</cfloop>
</cfselect>
</td>
<td width="100">
<cfselect name="AccountID">
<option value="All">All</option>
<cfloop query="Account">
<option value="#AccountID#">#AccountID#</option>
</cfloop>
</cfselect>
</td>
<td width="79">
<div align="right">
<cfinput name="search" value="Search" type="submit">
</div>
</td>
</tr>
</table>
</cfform>
</cfoutput>

<cfif isdefined(form.search)>
<cfset session.mMonth = '#form.mMonth#'>
<cfset session.AccountID = '#form.AccountID#'>

<cfquery name="calc">
select Month(ExpenseDate) As mMonth, ExpenseID, Amount from vwexpenses
WHERE ExpenseDate >= #createODBCDate(request.StartYear)#
<cfif #Session.AccountID# is "All">
<cfelse>
AND AccountID = '#session.AccountID#'
</cfif>
order by ExpenseID
</cfquery>

<cfquery dbtype="query" name="calcDtls">
SELECT mMonth, ExpenseID, SUM(Amount) AS Amount
FROM calc
GROUP BY mMonth, ExpenseID
</cfquery>

<cfquery dbtype="query" name="CurrentProduct">
SELECT SUM(Amount) As Amt
FROM calcDtls
Where mMonth = #session.mMonth#
Group By mMonth, ExpenseID
ORDER BY mMonth Asc
</cfquery>

<cfquery dbtype="query" name="TotlAmount">
Select SUM(Amt) AS Ammt
FROM CurrentProduct
</cfquery>

<cfif #CurrentProduct.RecordCount# eq 0>
<h3>No Record Available For This (Financial Year) Period.</h3>
<cfabort>
</cfif>


<table width="426" cellpadding="3" cellspacing="3">
<tr>
<cfoutput>
<td><strong> Month: <br>
#MonthasString(session.mMonth)#</strong></td><td> <div align="right"><strong>Expenditure: <br>#numberformat(TotlAmount.Ammt,",999.99")# </strong></div></td>
</cfoutput>
</tr>
<tr>
<td colspan="2"></td>
</tr>
<tr>
<td width="238"><strong>Expenditure</strong></td> <td width="165"><div align="right"><strong>Amount in (N) </strong></div></td>
</tr>
<cfoutput query="CurrentProduct">
<tr>
<td>#ExpenseID#</td><td><div align="right">#numberformat(Amt,",999.99")#</div></td>
</tr>
</cfoutput>
</table>
</cfif>

</div>
</div>
</div>
</body>
</html>