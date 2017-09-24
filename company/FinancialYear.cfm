<!doctype html>
<html>
<head>
<title><cfoutput>Financial Year  :: #request.title#</cfoutput></title>
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
<h4>Financial Year</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.submit" default="">
<cfif isdefined (form.submit)>
<cfset newDate = "#form.Startmonth#/01/#form.StartYear#">
<cfset newDate = #LSDateformat(newDate)#>
<cfset newEndDate = #LSdateformat((newDate)+364)#>


<cfquery name="UpdateFinYear">
UPDATE FinancialYear
SET
StartDate = '#newDate#',
EndDate = '#newEndDate#'
WHERE ID = 1
</cfquery>
<p>
<h2>Financial Year Created Successfully!</h2>&nbsp;<a href="../Index/index.cfm">Home</a>
</p>
<cfelse>

<cfquery name="inYear">
SELECT StartDate FROM FinancialYear
</cfquery>
<cfquery name="Years">
SELECT YearID FROM Years
ORDER by YearID
</cfquery>
<cfquery name="Months">
SELECT * FROM Months
</cfquery>

<cfform action="#cgi.SCRIPT_NAME#">
<h3>Current Financial Year</h3>
<table width="40%">
<tr>
<td>Starting:</td>
<td><cfinput type="text" value="#Dateformat((inYear.StartDate),"mmmm")#" name="curStartMonth" readonly="yes" style="width:100%">
</td>
<td><cfinput type="text" value="#Dateformat((inYear.StartDate),"yyyy")#"name="curStartYear" readonly="yes" style="width:100%"></td>
</tr>
<tr>
<td>Ending:</td>
<td><cfinput type="text" value="#Dateformat((inYear.StartDate)+360,"mmmm")#" name="curEndMonth" readonly="yes" style="width:100%"></td>
<td><cfinput type="text" value="#Dateformat((inYear.StartDate)+360,"yyyy")#"name="curEndYear" readonly="yes" style="width:100%"></td>
</tr>
</table>
<cfif #GetUserRoles()# is 'Alpha' OR  #GetUserRoles()# is 'Administrator'>
<h3>Enter New Financial Year</h3>
<table width="40%">
<tr>
<td width="18%">Starting</td>
<td width="41%"><cfselect name="Startmonth" style="width:100%">
      <cfoutput query="Months">
      <option value="#ID#" <cfif Months.MonthID is #Dateformat(inYear.StartDate,"mmmm")#>
    selected </cfif>>#MonthID#</option>
    </cfoutput>
    </cfselect>
</td>
<td width="41%"><cfselect name="StartYear" style="width:100%">
      <cfoutput query="Years">
      <option value="#YearID#" <cfif Years.YearID is #Dateformat(inYear.StartDate,"yyyy")#>
    selected </cfif>>#YearID#</option>
    </cfoutput>
    </cfselect>
</td>
</tr>
<tr>
<td></td>
<td></td>
<td><div align="right"><cfinput type="submit" value="Submit" name="Submit"></div></td>
</tr>
</table>
</cfif>
</cfform>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>