<head>
<link href="css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>



<cfparam name="form.Search" default="">

<cfform action="#cgi.SCRIPT_NAME#">
<table width="567">
<tr>
<td width="154">Starting:</td> <td width="154">Ending:</td> <td width="78">Branch:</td> <td width="96">Product:</td><td width="61"></td>
</tr>
<tr>
<td><cfinput name="StartDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" class="bold_10pt_Date" mask="dd/mm/yyyy"></td>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" class="bold_10pt_Date" mask="dd/mm/yyyy"></td>
<td><cfselect name="BranchID" id="BranchID" required="yes" message="Select Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" class="bold_10pt_item"> </cfselect></td>
<td><cfselect name="ProductID" id="ProductID" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.AllProducts()" display="ProductID" value="ProductID" bindonload="yes" class="bold_10pt_black">
</cfselect></td>
<td><cfinput name="Search" value="Search" type="submit" class="bold_10pt_Button"></td>
</tr>
</table>
</cfform>

<cfif isdefined (form.Search)>
<cfset session.StartDate = "#Form.StartDate#">
<cfset session.EndDate = "#Form.EndDate#">
<cfset session.ProductID = "#form.ProductID#">
<cfset session.BranchID = "#form.BranchID#">

<cfset StartDate = #form.StartDate#>
<cfset StartDate = #Dateformat(StartDate,"dd/mm/yyyy")#>
<cfset EndDate = #form.EndDate#>
<cfset EndDate = #Dateformat(EndDate,"dd/mm/yyyy")#>
<cfset yyear = '#request.StartYear#'>
<cfset yyear = #Dateformat(CreateODBCDate(request.StartYear))#>

<cfquery name="Transact">
SELECT ProductID, Qty,dDate, TypeID, BranchID FROM vwProductTransactUnion
WHERE ddate >= #CreateODBCDate(StartDate)# AND ddate < #CreateODBCDate(EndDate)# AND ProductID = '#form.ProductID#' AND BranchID = '#form.BranchID#'
</cfquery>

<cfquery name="TotalQty">
SELECT TypeID, SUM(Qty) AS Qty FROM vwProductTransactUnion
WHERE ddate >= #request.StartYear# AND ddate < #CreateODBCDate(StartDate)# AND ProductID = '#form.ProductID#' AND BranchID = '#form.BranchID#'
GROUP BY TypeID
</cfquery>

<cfquery name="TotalQty2">
SELECT ProductID, Qty,dDate, TypeID, BranchID FROM vwProductTransactUnion
WHERE ddate >= #request.StartYear# AND ddate < #CreateODBCDate(StartDate)# AND ProductID = '#form.ProductID#' AND BranchID = '#form.BranchID#'
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty) AS Qty
FROM TotalQty
WHERE TypeID = 'Sales' or TypeID = 'Transfer Out'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty) AS Qty
FROM TotalQty
WHERE TypeID = 'Purchase' or TypeID = 'Transfer IN' or TypeID = 'Opening Balance'
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

<cfparam name="qty2" default="#PreviousBal#">

<cfdump var="#QtyIN#" label="QtyIN">
<cfdump var="#QtyOUT#" label="QtyOUT">
<cfdump var="#PreviousBal#" label="PreviousBal">
<cfdump var="#TotalQty2#" label="TotalQty2">
<cfdump var="#Transact#" label="Transact">
<cfdump var="#form.StartDate#" label="Start">
<cfdump var="#form.EndDate#" label="End">
<cfabort>


<cfif #Transact.recordCount# eq 0>
<table width="595">
<tr>
<td width="105"><strong>Date</strong></td>
<td width="121"><strong>Transaction Type</strong></td>
<td width="73"><div align="right"><strong>Qty</strong></div></td>
<td width="101" hidden="yes" ><div align="right"><strong>Cal</strong></div></td>
<td width="84"><div align="right"><strong>Balance</strong></div></td>
</tr>
<tr>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td><div align="right"><strong>Prev. Bal.</strong></div></td>
  <td hidden="yes"></td>
  <td><div align="right"><strong><cfoutput>#Qty2#</cfoutput></strong></div></td>
</tr>
<tr>
<td>N/A</td><td>N/A</td>
<td><div align="right">N/A</div></td>
<td hidden="yes"></td>
<td><div align="right">N/A</div></td>
</tr>
</table>
<cfelse>
<table width="595">
<tr>
<td width="105"><strong>Date</strong></td><td width="83"><strong>Branch</strong></td><td width="121"><strong>Transaction Type</strong></td><td width="73"><div align="right"><strong>Qty</strong></div></td><td width="101" hidden="yes" ><div align="right"><strong>Cal</strong></div></td><td width="84"><div align="right"><strong>Balance</strong></div></td>
</tr>
<tr>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td><div align="right"><strong>Prev. Bal.</strong></div></td>
  <td hidden="yes"><div align="right"></div></td>
  <td><div align="right"><strong>
    <cfoutput>#Qty2#</cfoutput>
  </strong></div></td>
</tr>
<cfoutput query="Transact">
<tr><td>#Dateformat(dDate,"dd/mm/yyyy")#</td><td>#BranchID#</td><td>#TypeID#</td><td><div align="right">#Qty#</div></td><td hidden="yes"><div align="right">
#Qty2#

<cfset Qty2 = #val(Qty2)#>


<cfif #Transact.TypeID# is "Sales">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #Transact.TypeID# is "Transfer Out">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

</div>
</td>
<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#newBalance#</div></td>
</tr>

</cfoutput>

</table>
</cfif>
</cfif>