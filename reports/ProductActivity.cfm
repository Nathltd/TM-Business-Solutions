<!doctype html>
<html>
<head>
<title><cfoutput>Product Activities :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>
<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div>
<h4><cfif isdefined ("form.ProductID")><cfoutput>#form.ProductID# Transactions @ #form.BranchID#  (#form.StartDate# - #form.EndDate#)</cfoutput><cfelse>Product Activities</cfif></h4>
<div id="RightColumn">
<div align="right"> <a href="?">Reset</a>&nbsp;&nbsp;</div>

<cfparam name="form.productId" default="">
<cfparam name="form.search" default="">

<cfform action="#cgi.SCRIPT_NAME#">
<table width="90%" cellpadding="2">
<tr>
<td width="20%">Starting:</td> <td width="20%">Ending:</td> <td width="30%">Branch:</td> <td width="30%">Product:</td><td width="10%"></td>
</tr>
<tr>
<td><cfinput name="StartDate" type="datefield" placeholder="#dateFormat(request.StartYear,"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td valign="top"><cfselect name="BranchID" id="BranchID" required="yes" message="Select Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" style="width:100%"> </cfselect></td>
<td valign="top">
<cfquery name="productList">
select distinct productId from inventory
order by productid
</cfquery>

<cfselect name="ProductID" id="ProductID" required="yes"  message="Select A Product" style="width:100%">
<cfoutput query="productList">
<option value="#productId#">#productId#</option>
</cfoutput>
</cfselect></td>
<td valign="top"><cfinput name="Search" value="Search" type="submit"></td>
</tr>
</table>
</cfform>
<cfif isdefined(form.search)>

<cfset StartDate = #form.StartDate#>
<cfset StartDate = #Dateformat(StartDate,"dd/mm/yyyy")#>
<cfset EndDate = #form.EndDate#>
<cfset EndDate = #Dateformat(EndDate,"dd/mm/yyyy")#>
<cfset yyear = '#request.StartYear#'>
<cfset yyear = #Dateformat(CreateODBCDate(request.StartYear))#>

<cfset session.StartDate = "#StartDate#">
<cfset session.EndDate = "#EndDate#">
<cfset session.ProductID = "#ProductID#">
<cfset session.BranchID = "#BranchID#">

<cfquery name="product" timeout="300">
select distinct productId from vwProductTransactUnion
order by productid
</cfquery>
<cfquery name="Transact" timeout="300">
SELECT ProductID, Qty,dDate, TypeID, BranchID, salesId FROM vwProductTransactUnion
WHERE ddate >= #CreateODBCDate(StartDate)# AND ddate <= #CreateODBCDate(EndDate)# AND ProductID = '#form
.ProductID#' AND BranchID = '#form.BranchID#'
</cfquery>

<cfif #Transact.recordCount# eq 0>
<h2>No Record Found! </h2>
<cfelse>

<cfquery dbtype="query" name="QtyOut" timeout="300">
SELECT  SUM(Qty) AS Qty1, ProductID
FROM Transact
WHERE TypeID = 'Sales' or TypeID = 'Transfer Out' or TypeID = 'Adj' or TypeID = 'Returned' AND ProductID = '#form.ProductID#'
GROUP BY ProductID
</cfquery>

<cfquery dbtype="query" name="QtyIN" timeout="300">
SELECT  SUM(Qty) AS Qty1, ProductID
FROM Transact
WHERE TypeID = 'Purchase' or TypeID = 'Transfer IN' or TypeID = 'Opening Balance' or TypeID = 'Retained' AND ProductID = '#form.ProductID#'
GROUP BY ProductID
</cfquery>

<cfset newOut = #qtyOut.qty1#>
<cfset newIn = #qtyIn.qty1#>

<cfoutput>
<!---Calculation for Opening Balance--->
<cfquery name="TotalQty"  timeout="300">
SELECT TypeID, Qty, ProductID, branchId FROM vwProductTransactUnion
WHERE ddate < #CreateODBCDate(StartDate)# AND ProductID = '#form.ProductID#' AND BranchID = '#form.BranchID#'
</cfquery>

<cfquery dbtype="query" name="QtyOut" timeout="300">
SELECT  SUM(Qty) AS Qty1, ProductID
FROM TotalQty
WHERE TypeID = 'Sales' or TypeID = 'Transfer Out' or TypeID = 'Adj' or TypeID = 'Returned'
GROUP BY ProductID
</cfquery>

<cfquery dbtype="query" name="QtyIN" timeout="300">
SELECT  SUM(Qty) AS Qty1, ProductID
FROM TotalQty
WHERE TypeID = 'Purchase' or TypeID = 'Transfer IN' or TypeID = 'Opening Balance' or TypeID = 'Retained'
GROUP BY ProductID
</cfquery>

<cfif QtyIN.recordCount eq 0 AND QtyOUT.recordCount gt 0>
<cfset QtyIN2 = 0>
<cfset #QtyOUT2# = #Valuelist(QtyOUT.Qty1)#>
<cfelseif QtyOUT.recordCount eq 0  AND QtyIN.recordCount gt 0>
<cfset QtyOUT2 = 0>
<cfset #QtyIN2# = #Valuelist(QtyIN.Qty1)#>
<cfelseif QtyIN.recordCount eq 0 AND QtyOUT.recordCount eq 0>
<cfset QtyIN2 = 0>
<cfset QtyOUT2 = 0>
<cfelse>
<cfset #QtyIN2# = #Valuelist(QtyIN.Qty1)#>
<cfset #QtyOUT2# = #Valuelist(QtyOUT.Qty1)#>
</cfif>

<cfset PreviousBal = +#QtyIN2#-(#QtyOUT2#)>

<cfset name="qty2" = #PreviousBal#>

<table width="90%">

<tbody>

<tr>
<td>
<table width="95%">
<tbody>
<tr>
<td width="10%"><strong>
S/N.</strong>
</td>
<td width="20%"><strong>Date</strong></td><td width="20%"><strong>Type</strong></td>
<td width="10%"><strong>Ref Id:</strong></td>
<td width="15%"><div align="right"><strong>IN</strong></div></td><td width="15%"><div align="right"><strong>OUT</strong></div></td><td width="30%"><div align="right"><strong>Balance</strong></div></td>
</tr>

<tr bgcolor="##C0C0C0">
  <td><strong>B/F.</strong></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td><td>&nbsp;</td><td><div align="right"><strong>
    <cfoutput>#Qty2#</cfoutput></strong></div></td>
</tr>

<cfloop query="Transact">
<cfif #typeID# is "Order"><cfset rowColor="##FB0209"><cfelseif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#currentrow#.</td>
<td>#Dateformat(dDate,"dd/mm/yyyy")#</td><td>#TypeID#</td>
<td>#salesid#</td>
<td><div align="right"><cfif #TypeID# is "Sales">0<cfelseif #TypeID# is "Order">0<cfelseif #TypeID# is "Transfer Out">0<cfelseif #TypeID# is "Adj">0<cfelseif #TypeID# is "returned">0<cfelse>#numberformat(Qty,",")#</cfif></div></td><td><div align="right"><cfif #TypeID# is "Sales">#numberformat(Qty,",")#<cfelseif #TypeID# is "Order">#numberformat(Qty,",")#<cfelseif #TypeID# is "Transfer Out">#numberformat(Qty,",")#<cfelseif #TypeID# is "Adj">#numberformat(Qty,",")#<cfelseif #TypeID# is "returned">#numberformat(Qty,",")#<cfelse>0</cfif></div></td>

<cfset Qty2 = #val(Qty2)#>
<cfif #Transact.TypeID# is "Sales">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #Transact.TypeID# is "Transfer Out">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #Transact.TypeID# is "Adj">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #Transact.TypeID# is "returned">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #Transact.TypeID# is "Order">
<cfset qty2 = 0+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>



<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>

<div align="right">#numberformat(newBalance,",")#</div>
</td>
</tr>
</cfloop>
<cfif not isNumeric(#newOut#)>
<cfset #newOut# = 0>
</cfif>
<cfif not isNumeric(#newIn#)>
<cfset #newIn# = 0>
</cfif>
<tr>
<td colspan="2"></td><td></td><td><strong>Total</strong></td><td><div align="right"><strong>#numberformat(NewIn)#</strong></div></td><td><div align="right"><strong>#numberformat(NewOut,",")#</strong></div></td>
<td>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>

</cfoutput>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>