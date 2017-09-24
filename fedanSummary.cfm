<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Untitled Document</title>
</head>

<body>

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
<cfquery name="Branch">
select * from Branches
</cfquery>
<cfform  action="#cgi.SCRIPT_NAME#">
<table width="196">
<tr>
<td width="101">
  <label for="dMonth">Month</label>
</td>
<td width="79">
</td>
</tr>
<tr>
<td width="101">
  <cfselect name="mMonth">
    <option value="All">All</option>
  <cfoutput query="months">
  <option value="#ID#">#monthID#</option>
  </cfoutput>
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
<cfparam name="form.search" default="">
<cfparam name="form.bBranch" default="">
<cfparam name="form.mMonth" default="">
<cfif isdefined(form.search)>

<cfquery name="LagTM" datasource="tm001">
SELECT Sum(vwSalesDetails.Amt) AS Amount
FROM vwSalesDetails
<cfif #form.mMonth# is "All">
<cfelse>
WHERE Month(SalesDate) = #form.mMonth#
</cfif>
</cfquery>
<cfquery name="lagTMexp" datasource="tm001">
SELECT SUM(Amount) AS Amount
FROM vwExpenses
<cfif #form.mMonth# is "All">
<cfelse>
WHERE Month(ExpenseDate) = #form.mMonth#
</cfif>
</cfquery>
<cfquery name="KanoTM" datasource="tm002">
SELECT Sum(vwSalesDetails.Amt) AS Amount
FROM vwSalesDetails
<cfif #form.mMonth# is "All">
<cfelse>
WHERE Month(SalesDate) = #form.mMonth#
</cfif>
</cfquery>
<cfquery name="kanoTMexp" datasource="tm002">
SELECT SUM(Amount) AS Amount
FROM vwExpenses
<cfif #form.mMonth# is "All">
<cfelse>
WHERE Month(ExpenseDate) = #form.mMonth#
</cfif>
</cfquery>

<cfoutput>
<table width="546">
<tr>
<td width="100"><strong>Branch</strong></td><td width="166"><strong> Revenue</strong></td><td width="232"><strong>Expenditure</strong></td><td width="11"></td><td width="13"></td>
</tr>
<tr>
<td>Lagos</td><td> N#numberformat(lagTM.amount,",000")#</td><td>N#numberformat(lagTMexp.amount,",000")#</td><td></td><td></td>
</tr>
<tr>
<td>Kano </td><td> N#numberformat(kanoTM.amount,",000")#</td><td>N#numberformat(kanoTMexp.amount,",000")#</td><td></td><td></td>
</tr>
</table>
</cfoutput>

</cfif>

</body>
</html>