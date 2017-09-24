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
<cfparam name="url.branchId" default="">

<cfquery name="InventoryByShop">
SELECT ProductID, Balance, Description, ReorderLevel
FROM vwInventoryReorderList
WHERE BranchID = <cfqueryparam value="#url.BranchID#" cfsqltype="cf_sql_clob">
ORDER BY ProductID ASC
 </cfquery>

<div align="center">
<cfinclude template="../shared/AllMenu.cfm">
<div id="Content">
<h4>Stock Re-Order List At <cfoutput> #url.BranchID# </cfoutput> </h4>
<div id="RightColumn">

<cfif #InventoryByShop.recordcount# eq 0>
<br />
<h2>There is no Item in <cfoutput><strong> #url.BranchID#</strong> </cfoutput>.</h2>

<cfelse>


<br />


<table width="90%" cellpadding="2" cellspacing="0">
<tr>
<td width="5%"><div align="left"><strong>S/N</strong></div></td>
<td width="31%"><div align="left"><strong>Product Name</strong></div></td>
<td width="44%"><div align="left"><strong>Description</strong></div></td> 
<td width="10%"><div align="right"><strong>Reorder Level</strong></div></td>
<td width="10%"><div align="right"><strong>Current Status</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput query="InventoryByShop">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td><div align="left">#currentRow#</div></td>
<td align="left"><div align="left">#ProductID#</div></td>
<td align="left"><div align="left">#Description#</div></td>
<td align="left"><div align="right">#numberformat(ReorderLevel)#</div></td>
<td align="right"><div align="right">#numberformat(balance)#</div></td>
</tr>
</cfoutput>
</table>
</cfif>
</div>
</div>
</div>
</body>
</html>