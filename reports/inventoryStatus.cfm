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
    <a href="#cgi.SCRIPT_NAME#?startRow=#previous#&endRow=#evaluate(next-51)#"><b>Previous #displayRow# Records</b></a>
    <cfelse>
    Previous Records
  </cfif>
  <b>|</b>
  <cfif #next# LTE #products.recordCount#>
    <a href="#cgi.SCRIPT_NAME#?startRow=#next#&endRow=#evaluate(next+49)#"><b>Next
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
<cfstoredproc procedure = "productTransact" >
<cfprocparam cfsqltype="cf_sql_varchar" type="in" value="#productid#">
<cfprocparam cfsqltype="cf_sql_varchar" type="in" value="#session.bBranch#">
<cfprocparam cfsqltype="cf_sql_date" type="in" value="#CreateODBCDate(session.stockEndDate)#">
<cfprocparam cfsqltype="cf_sql_integer" type="out" variable="QtyIN">
<cfprocparam cfsqltype="cf_sql_integer" type="out" variable="QtyOUT">
</cfstoredproc>

<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td width="5%">#products.currentRow#.</td><td width="30%">#productid#</td><td width="30%"> #description#</td><td width="15%"><div align="right"><strong>
    <cfoutput>#val(QtyOUT-QtyIN)#</cfoutput></strong></div></td>
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