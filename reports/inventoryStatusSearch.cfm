<!doctype html>
<html>
<head>
<title><cfoutput>Previous Inventory Report :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>
<body>


<div align="center">
<cfinclude template="../shared/AllMenu.cfm">


<div id="Content">
<h4>Inventory Report</h4>
<div id="RightColumn">
<br>
<br>
<cfquery name="Branch">
select * from Branches
</cfquery>

<cfform action="inventoryStatus.cfm">
<table>
<tr>
<td> Branch</td>
<td>Date</td>
</tr>
<tr>
<cfoutput>
<td><cfselect name="bBranch">
<option value="All">All</option>
<cfloop query="Branch">
<option value="#BranchID#">#BranchID#</option>
</cfloop>
</cfselect></td>
</cfoutput>
<td><cfinput type="datefield" mask="dd/mm/yyyy" required="yes" name="endDate"></td>
</tr>
<tr>
<td colspan="2" align="right"><cfinput name="submit" type="submit" value="Search" ></td>
</tr>
</table>
</cfform>
</div>
</div>
</div>
</body>
</html>