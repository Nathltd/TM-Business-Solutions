<cfquery name="ShopSales_Date" datasource="#request.dsn#">
SELECT ProductId, ReceiptNo, Qty
FROM ShopSales_Date
WHERE BranchID = <cfqueryparam value='#form.Shop#' cfsqltype="cf_sql_clob">
AND ReceiptDate = <cfqueryparam value='#form.SalesDate#' cfsqltype="cf_sql_clob">
 </cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>

</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div class="mainBody">
<p>&nbsp;

</p>

<div class="font1">
 Items Sold @ <cfoutput><strong> #form.shop#</strong> on <strong>#form.salesDate#</strong> </cfoutput>
<p>&nbsp;
<cfif #shopsales_date.recordcount# eq 0>
There is no sales record for <cfoutput><strong> #form.shop#</strong> on <strong>#form.salesDate#</strong> </cfoutput><br /><br />

</p>
<cfelse>
<table width="256" border="0" class="font1">
<tr>
<td width="133"><strong>Invoice No.</strong></td><td width="10"></td> <td width="109"><strong>Item Name</strong></td><td><strong>Quantity</strong></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="ShopSales_Date">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onmouseover="this.bgColor='FFCCCC';" onmouseout="this.bgColor='#rowColor#';">
<td>#ReceiptNo#</td><td></td><td>#ProductID#</td><td align="right">#Qty#</td>
</tr>

</cfloop>
</cfoutput>
</table>
</cfif>
</div><br />
Click <a href="AllSales.cfm">here</a> for another Sales Report.
</div>
</div>
</body>
</html>