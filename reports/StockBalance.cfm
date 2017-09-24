<cfparam name="form.productId" default="">
<cfparam name="form.search" default="">

<cfform action="#cgi.SCRIPT_NAME#">
<table width="567">
<tr>
<td width="154">Date:</td> <td width="78">Branch:</td> <td width="96">Product:</td><td width="61"><a href="?print=1">Print</a></td>
</tr>
<tr>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" class="bold_10pt_Date" mask="dd/mm/yyyy"></td>
<td><cfselect name="BranchID" id="BranchID" required="yes" message="Select Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" class="bold_10pt_item"> </cfselect></td>
<td>
<cfquery name="productList" datasource="tm001"  timeout="180">
select distinct productId from inventory
order by productid
</cfquery>

<cfselect name="ProductID" id="ProductID" required="yes"  message="Select A Product" class="bold_10pt_black">
<option value="All">All</option>
<cfoutput query="productList">
<option value="#productId#">#productId#</option>
</cfoutput>
</cfselect></td>
<td><cfinput name="Search" value="Search" type="submit" class="bold_10pt_Button"></td>
</tr>
</table>
</cfform>
<cfif isdefined(form.search)>



<cfset EndDate = #form.EndDate#>
<cfset EndDate = #Dateformat(EndDate,"dd/mm/yyyy")#>
<cfset yyear = '#request.StartYear#'>
<cfset yyear = #Dateformat(CreateODBCDate(request.StartYear))#>

<cfset session.EndDate = "#EndDate#">
<cfset session.ProductID = "#ProductID#">
<cfset session.BranchID = "#BranchID#">

<cfquery name="product" datasource="tm001"    maxrows="30" >
select distinct productId from inventory
<cfif #form.productId# is "All">
<cfelse> where  productid = '#form.productId#' </cfif>
order by productid
</cfquery>

<cfoutput>
<table width="600">
<cfloop query="product">

<!---Calculation for Opening Balance--->
<cfquery name="TotalQty">
SELECT TypeID, SUM(Qty) AS Qty1, ProductID FROM vwProductTransactUnion
WHERE ddate >= #CreateODBCDate(request.StartYear)# AND ddate <= #CreateODBCDate(EndDate)# AND ProductID = '#product.ProductID#' AND BranchID = '#form.BranchID#'
GROUP BY TypeID, ProductID
</cfquery>

<cfquery dbtype="query" name="QtyOut" >
SELECT  SUM(Qty1) AS Qty, ProductID
FROM TotalQty
WHERE TypeID = 'Sales' or TypeID = 'Transfer Out' or TypeID = 'Adj' AND ProductID = '#product.ProductID#'
GROUP BY ProductID
</cfquery>

<cfquery dbtype="query" name="QtyIN" >
SELECT  SUM(Qty1) AS Qty, ProductID
FROM TotalQty
WHERE TypeID = 'Purchase' or TypeID = 'Transfer IN' or TypeID = 'Opening Balance' AND ProductID = '#product.ProductID#'
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


<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td>#currentrow#</td>
  <td><strong>#productid#</strong></td><td></td><td><div align="right"><strong>
    <cfoutput>#Qty2#</cfoutput></strong></div></td>
</tr>
</cfloop>
</table>
</cfoutput>
</cfif>