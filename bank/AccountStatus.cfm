<!doctype html>
<html>
<head>
<title><cfoutput>Account Status :: #request.title#</cfoutput></title>
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
<h4>Account Status</h4>

<div id="RightColumn">

<cfif #GetUserRoles()# is 'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfquery name="Accounts">
SELECT * FROM vwAccntBalance
</cfquery>
<p>
<table width="90%">
<tr bgcolor="#999999">
<td width="40%"><font color="#F4F4F4">Account</font></td><td width="20%"><div align="right"><font color="#F4F4F4">Amount In</font></div></td><td width="20%"><div align="right"><font color="#F4F4F4">Amount Out</font></div></td><td width="20%"><div align="right"><font color="#F4F4F4">Balance</font></div></td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<cfoutput query="Accounts">
<tr  bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#AccountID#</td><td><div align="right">#numberformat(AmountIn,",000.00")#</div></td><td><div align="right">#numberformat(AmountOut,",000.00")#</div></td><td><div align="right">#numberformat(Balance,",000.00")#</div></td>
</tr>
</cfoutput>
</table>
</p>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>