<!doctype html>
<html>
<head>
<title><cfoutput>Previous Stock Balance :: #request.title#</cfoutput></title>
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


<cfparam name="startRow" default="1">
<cfparam name="endRow" default="50">
<cfparam name="displayRow" default="50">

<cfquery name="products">
select productid, description from vwInventory
order by productid
</cfquery>

<cfif isdefined('form.submit')>
<cfset session.stockEndDate = #dateformat(form.endDate,"dd/mm/yyyy")#>
<cfset session.bBranch = #form.bBranch#>
</cfif>

<cfoutput>
<h4>Stock Status in #session.bBranch# as at #dateformat(session.stockEndDate,"dd/mmm/yyyy")#</h4>
<div id="RightColumn">
<br>


<cfset next = #startRow#+50>
<cfset previous = #startRow#-50>
<cfset lastRow = #next#+7>

<table width="75%">
<tr>
<td colspan="4" align="right"><a href="inventoryStatusSearch.cfm">Reset</a></td>
</tr>
<tr>
<td colspan="2" align="left">Record #startRow# to #endRow# of #products.recordCount#</td>
<td colspan="2" align="right">
  <cfif #previous# GTE 1>
    <a href="#cgi.SCRIPT_NAME#?startRow=#previous#&endRow=#evaluate(next-31)#"><b>Previous #displayRow# Records</b></a>
    <cfelse>
    Previous Records
  </cfif>
  <b>|</b>
  <cfif #next# LTE #products.recordCount#>
    <a href="#cgi.SCRIPT_NAME#?startRow=#next#&endRow=#evaluate(next+29)#"><b>Next
      <cfif (#products.recordCount#-#next#) LT #displayRow#> #evaluate((products.recordCount-next)+1)# 
        <cfelse> #displayRow#
        </cfif> Records</b></a>
    <cfelse>
    Next Records
  </cfif></td>
</tr>
<tr>
<td>
</td>
</tr>
<tr>
<td><strong>S/N</strong></td><td><strong>PRODUCT ID</strong></td><td><strong>DESCRIPTION</strong></td><td><div align="right"><strong>QUANTITY</strong></div></td>
</tr>

<cfloop query="products" startrow="#startRow#" endrow="#endRow#">
<!---Calculation for Opening Balance--->
<cfquery name="TotalQty" cachedwithin="#CreateTimeSpan(0, 0, 20, 0)#" timeout="300">
SELECT TypeID, SUM(Qty) AS Qty1, ProductID FROM vwProductTransactUnion
WHERE ProductID = '#products.ProductID#' AND ddate >= #CreateODBCDate(request.StartYear)# AND ddate <= #CreateODBCDate(session.stockEndDate)# AND BranchId = '#session.bBranch#'
GROUP BY TypeID, ProductID
</cfquery>

<cfquery dbtype="query" name="QtyOut" cachedwithin="#CreateTimeSpan(0, 0, 20, 0)#">
SELECT  SUM(Qty1) AS Qty, ProductID
FROM TotalQty
WHERE TypeID = 'Sales' or TypeID = 'Transfer Out' or TypeID = 'Adj' AND ProductID = '#products.ProductID#'
GROUP BY ProductID
</cfquery>

<cfquery dbtype="query" name="QtyIN" cachedwithin="#CreateTimeSpan(0, 0, 20, 0)#">
SELECT  SUM(Qty1) AS Qty, ProductID
FROM TotalQty
WHERE TypeID = 'Purchase' or TypeID = 'Transfer IN' or TypeID = 'Opening Balance' AND ProductID = '#products.ProductID#'
GROUP BY ProductID
</cfquery>

<cfif QtyIN.recordCount eq 0 AND QtyOUT.recordCount gt 0>
<cfset QtyIN = 0>
<cfset #QtyOUT# = #Valuelist(QtyOUT.Qty)#>
<cfelseif QtyOUT.recordCount eq 0  AND QtyIN.recordCount gt 0>
<cfset QtyOUT = 0>
<cfset #QtyIN# = #Valuelist(QtyIN.Qty)#>
<cfelseif QtyIN.recordCount eq 0 AND QtyOUT.recordCount eq 0>
<cfset QtyIN = 0>
<cfset QtyOUT = 0>
<cfelse>
<cfset #QtyIN# = #Valuelist(QtyIN.Qty)#>
<cfset #QtyOUT# = #Valuelist(QtyOUT.Qty)#>
</cfif>

<cfset PreviousBal = +#QtyIN#-(#QtyOUT#)>

<cfset name="qty2" = #PreviousBal#>
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td width="5%">#products.currentRow#.</td><td width="30%">#productid#</td><td width="30%"> #description#</td><td width="15%"><div align="right"><strong>
    <cfoutput>#Qty2#</cfoutput></strong></div></td>
</tr>
</cfloop>
</table>
<br>
</cfoutput>
</div>
</div>
</div>
</body>
</html>