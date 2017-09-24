<!doctype html>
<html>
<head>
<title><cfoutput>Re-Order List :: #request.title#</cfoutput></title>
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
<h4><strong>Choose a Branch to search from...</strong></h4>
<div id="RightColumn">

<p>&nbsp;
<cfquery name="Branch" datasource="#request.dsn#">
SELECT BranchID
FROM Branches
ORDER BY BranchID ASC
</cfquery>

<cfoutput>
<table>
<cfloop query="Branch">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onmouseover="this.bgColor='FFCCCC';" onmouseout="this.bgColor='#rowColor#';">
<td align="center">
<a href="../reports/AllBranchesReorderResult.cfm?BranchID=#BranchID#"><font size="+1" color="##333333">#BranchID#</font></a>
</td>
</tr>
</cfloop>
</table>
</cfoutput>
</p>
</div>
</div>
</div>
</body>
</html>