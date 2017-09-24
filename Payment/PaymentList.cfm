<!doctype html>
<html>
<head>
<title><cfoutput>Payment List :: #request.title#</cfoutput></title>
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
<h4>Payment Search</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is 'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.StartDate" default="">
<cfparam name="form.EndDate" default="">
<cfparam name="form.CustomerID" default="">
<cfparam name="form.AccountID" default="">
<cfparam name="session.StartDate" default="">
<cfparam name="session.EndDate" default="">
<cfparam name="session.CustomerID" default="">
<cfparam name="session.AccountID" default="">

<div align="right"><cfif isdefined ("submit")><a href="?print=1"><font size="-1">Print</font></a></cfif>&nbsp;&nbsp;</div>
<br><br>
<cfquery name="Customers">
SELECT CustomerID FROM Customers
ORDER BY CustomerID
</cfquery>
<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>
<cfif isdefined ("submit")>
<cfset startDate = #form.StartDate#>
<cfset endDate = #form.endDate#>
<cfelse>
<cfset startDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset endDate = #dateformat(now(),"dd/mm/yyyy")#>
</cfif>


<cfquery name="PaymentSearch">
SELECT PaymentDate, PaymentID, CustomerID, AccountID, Amount, type, creator
FROM vwCustPayment
WHERE 	PaymentDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #session.AccountID# is "All">
		<cfelse>
        AND AccountID = <cfqueryparam value="#trim(session.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.CustomerID# is "All">
		<cfelse>
        AND CustomerID = <cfqueryparam value="#trim(session.CustomerID)#"cfsqltype="cf_sql_clob">
        </cfif>
        ORDER BY PaymentDate ASC
 </cfquery>
 
 <cfquery name="tsT">
SELECT SUM(Amount) AS Amt
FROM vwCustPayment

WHERE 	PaymentDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #session.AccountID# is "All">
		<cfelse>
        AND AccountID = <cfqueryparam value="#trim(session.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.CustomerID# is "All">
		<cfelse>
        AND CustomerID = <cfqueryparam value="#trim(session.CustomerID)#"cfsqltype="cf_sql_clob">
        </cfif>
 </cfquery>

<cfparam name="url.print" default="">
<cfif url.print is "yes">

<cfdocument format="flashpaper" unit="in" margintop=".1">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<p>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="577">
  <tr>
    <td colspan="2" valign="top"><font size="-1" face="Segoe UI">Payments Report</font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Account:</font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.AccountID#</font></strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2">Customer:</font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2">#session.CustomerID#</font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Date:</font></div></td><td width="127" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.startDate# - #session.endDate#</font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>

<cfif #PaymentSearch.recordCount# eq 0>
<h2> No Record Found! </h2>
<cfelse>
<table width="671" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="109"><strong>Date</strong></td>
<td width="99"><strong>Ref #</strong></td>
<td width="107"><strong>Customer</strong></td>
<td width="165"><strong>Account</strong></td>
<td width="45"><strong>Staff</strong></td>
<td width="86"><div align="right"><strong>Amount</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="PaymentSearch">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#dateformat(PaymentDate,"dd/mm/yyyy")#</td>
<td><div><a href="?print=yes">#PaymentID#</a>&nbsp;&nbsp;</div></td>
<td><div align="left">#CustomerID#</div></td>
<td align="right"><div align="left">#AccountID#</div></td>
<td align="right"><div align="left">#creator#</div></td>
<td align="right" width="86"><div align="right">#numberformat(Amount,",000.00")#</div></td>
</tr>
</cfloop>
<tr>
<td></td>
<td></td>
<td></td>
<td align="left">&nbsp;</td>
<td align="left"><strong>Total:</strong></td>
<td align="right" width="86"><div align="right"><strong>#numberformat(tsT.Amt,",000.00")#</strong></div></td>
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

<cfoutput>
<cfform action="#cgi.SCRIPT_NAME#" method="post">
<table width="90%">
<tr align="left">
  <td valign="top" ><div align="left">Starting:</div></td>
  <td valign="top"><div align="left">Ending:</div></td>
  <td valign="top"><div align="left">Customer:</div></td>
  <td valign="top" ><div align="left">Account:</div></td>
  <td valign="top"><div align="left"></div></td>
</tr>
<tr align="center">
  <td width="17%" valign="top"><div align="left">
    <cfinput name="startDate" type="datefield" required="yes" message="Enter Starting Date" placeholder="#startDate#" mask="dd/mm/yyyy">
  </div>
    <label>
  </label>
  </td>
  <td width="17%" valign="top">
    <div align="left">
      <cfinput name="endDate" type="datefield"  required="yes" message="Enter Ending Date" placeholder="#endDate#" mask="dd/mm/yyyy" style="width:100%">
      </div></td>
  <td width="20%" valign="top">
    <div align="left">
      <cfselect name="CustomerID" message="Choose Product"  required="yes" id="ProductID" style="width:100%">
        <option value="All" selected>All</option>
        <cfloop query="Customers">
          <option value="#CustomerID#" <cfif Customers.CustomerID is #form.CustomerID#> selected </cfif>>#CustomerID#</option>
          </cfloop>
        </cfselect>
      </div></td>
  <td width="20%" valign="top">
    <div align="left">
      <cfselect name="AccountID" message="Choose Source"  required="yes" id="Source" style="width:100%">
        <option value="All" selected>All</option>
        <cfloop query="Accounts">
          <option value="#AccountID#" <cfif Accounts.AccountID is #form.AccountID#>
    selected </cfif>>#AccountID#</option>
          </cfloop>
        </cfselect>
    </div></td>
  <td width="10%" valign="top"><div align="left">
    <cfinput name="Submit" value="Search" type="submit" >
  </div></td>
</tr>
<tr>
  <td colspan="4">
    <div align="center"></div></td>
</tr>
</table>
</cfform>
</cfoutput>

<cfif isdefined ("submit")>

<cfset session.StartDate = "#Form.StartDate#">
<cfset session.EndDate = "#Form.EndDate#">
<cfset session.CustomerID = "#form.CustomerID#">
<cfset session.AccountID = "#form.AccountID#">

<cfquery name="PaymentSearch">
SELECT PaymentDate, PaymentID, CustomerID, AccountID, Amount, type, creator
FROM vwCustPayment
WHERE 	PaymentDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #session.AccountID# is "All">
		<cfelse>
        AND AccountID = <cfqueryparam value="#trim(session.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.CustomerID# is "All">
		<cfelse>
        AND CustomerID = <cfqueryparam value="#trim(session.CustomerID)#"cfsqltype="cf_sql_clob">
        </cfif>
        ORDER BY PaymentDate ASC
 </cfquery>
 
 <cfquery name="tsT">
SELECT SUM(Amount) AS Amt
FROM vwCustPayment

WHERE 	PaymentDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #session.AccountID# is "All">
		<cfelse>
        AND AccountID = <cfqueryparam value="#trim(session.AccountID)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.CustomerID# is "All">
		<cfelse>
        AND CustomerID = <cfqueryparam value="#trim(session.CustomerID)#"cfsqltype="cf_sql_clob">
        </cfif>
 </cfquery>

<cfif #PaymentSearch.recordCount# eq 0>
  <h2> No Record Found! </h2>
  <cfelse>
<table width="90%" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="5%"><strong>Date</strong></td>
<td width="10%"><strong>Type</strong></td>
<td width="10%"><strong>Ref #</strong></td>
<td width="15%"><strong>Customer</strong></td>
<td width="20%"><strong>Account</strong></td>
<td width="10%"><strong>Staff</strong></td>
<td width="10%"><div align="right"><strong>Amount</strong></div></td>
</tr>
<tr>
<td colspan="2"></td>
</tr>
<cfoutput>
<cfloop query="PaymentSearch">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#dateformat(PaymentDate,"dd/mm/yyyy")#</td>
<td>#type#</td>
<td><a href="../Reports/CustomerPayment.cfm">#PaymentID#</a></td>
<td><div align="left">#CustomerID#</div></td>
<td align="right"><div align="left">#AccountID#</div></td>
<td align="right"><div align="left">#creator#</div></td>
<td align="right" width="80"><div align="right">#numberformat(Amount,",000.00")#</div></td>
</tr>
</cfloop>
<tr>
<td colspan="2"></td>
<td></td>
<td></td>
<td align="left">&nbsp;</td>
<td align="left"><strong>Total:</strong></td>
<td align="right" width="80"><div align="right"><strong>#numberformat(tsT.Amt,",000.00")#</strong></div></td>
</tr>
</cfoutput>

</table>
</cfif>
<cfelse>
</cfif>
</cfif>
</cfif>
</div>

</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html> 