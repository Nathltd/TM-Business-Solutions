<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Product Activities</h4>
<div id="RightColumn">
<p>
<cfparam name="url.print" default="">
<cfif url.print is "yes">
<cfdocument format="flashpaper" unit="in" margintop=".1">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<p>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="577">
  <tr>
    <td colspan="2" valign="top"><font size="-1" face="Segoe UI">Product Activities Report</font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Branch:</font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.BranchID#</font></strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2">Item:</font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2">#session.ProductID#</font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Date:</font></div></td><td width="127" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.startDate# - #session.endDate#</font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>

<cfquery name="Transact">
SELECT ProductID, Qty,dDate, TypeID, BranchID FROM vwProductTransactUnion
WHERE ddate >= #CreateODBCDate(Session.StartDate)# AND ddate <= #CreateODBCDate(Session.EndDate)# AND ProductID = '#Session.ProductID#' AND BranchID = '#Session.BranchID#'
</cfquery>

<cfquery name="TotalQty">
SELECT TypeID, SUM(Qty) AS Qty FROM vwProductTransactUnion
WHERE ddate >= #request.StartYear# AND ddate < #CreateODBCDate(Session.StartDate)# AND ProductID = '#Session.ProductID#' AND BranchID = '#Session.BranchID#'
GROUP BY TypeID
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


<cfif #Transact.recordCount# eq 0>
<table width="595" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="105"><strong>Date</strong></td>
<td width="121"><strong>Transaction</strong></td>
<td width="73"><div align="right"><strong>Qty</strong></div></td>
<td width="84"><div align="right"><strong>Balance</strong></div></td>
</tr>
<tr>
</tr>
<tr bgcolor="#C0C0C0">
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td><div align="right"><strong>B/F</strong></div></td>
  <td hidden="yes"></td>
</tr>
<tr>
<td>N/A</td><td>N/A</td>
<td><div align="right">N/A</div></td>
<td><div align="right">N/A</div></td>
</tr>
</table>
<cfelse>
<table width="456" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td width="105"><strong>Date</strong></td><td width="121"><strong>Transaction</strong></td><td width="73"><div align="right"><strong>IN</strong></div></td><td width="73"><div align="right"><strong>OUT</strong></div></td><td width="84"><div align="right"><strong>Balance</strong></div></td>
</tr>
<tr bgcolor="#C0C0C0">
  <td>&nbsp;</td>
  <td><div align="left"><strong>B/F.</strong></div></td><td>&nbsp;</td>
  <td>&nbsp;</td>
  <td><div align="right"><strong>
    <cfoutput>#Qty2#</cfoutput>
  </strong></div></td>
</tr>
<cfoutput query="Transact">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(dDate,"dd/mm/yyyy")#</td><td>#TypeID#</td><td><div align="right"><cfif #TypeID# is "Sales">0<cfelseif #TypeID# is "Transfer Out">0<cfelse>#numberformat(Qty)#</cfif></div></td><td><div align="right"><cfif #TypeID# is "Sales">#numberformat(Qty)#<cfelseif #TypeID# is "Transfer Out">#numberformat(Qty)#<cfelse>0</cfif></div></td>
<td>
  
  <cfset newBalance = +#Qty#+#Qty2#-#Qty#>
  
  
  
  <div align="right">#numberformat(newBalance)#</div></td>
</tr>

</cfoutput>

</table>
</cfif>
</div>
<cfoutput>
<cfdocumentitem type="footer">
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>

<cfelse>

<cfparam name="form.Search" default="">
<cfparam name="session.StartDate" default="">
<cfparam name="session.EndDate" default="">
<cfparam name="session.ProductID" default="">
<cfparam name="session.BranchID" default="">

<cfif isdefined (form.Search)>
<cfset session.StartDate = "#Form.StartDate#">
<cfset session.EndDate = "#Form.EndDate#">
<cfset session.ProductID = "#form.ProductID#">
<cfset session.BranchID = "#form.BranchID#">
</cfif>
<cfform action="#cgi.SCRIPT_NAME#">
<table width="567">
<tr>
<td width="154">Starting:</td> <td width="154">Ending:</td> <td width="78">Branch:</td> <td width="96">Product:</td><td width="61"><a href="?print=1">Print</a></td>
</tr>
<tr>
<td><cfinput name="StartDate" type="datefield" placeholder="#request.StartYear#" required="yes" message="Enter valid date" class="bold_10pt_Date" mask="dd/mm/yyyy"></td>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" class="bold_10pt_Date" mask="dd/mm/yyyy"></td>
<td><cfselect name="BranchID" id="BranchID" required="yes" message="Select Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" class="bold_10pt_item"> </cfselect></td>
<td><cfselect name="ProductID" id="ProductID" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.AllProducts()" display="ProductID" value="ProductID" bindonload="yes" class="bold_10pt_black">
</cfselect></td>
<td><cfinput name="Search" value="Search" type="submit" class="bold_10pt_Button"></td>
</tr>
</table>
</cfform>

<cfif isdefined (form.Search)>

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

<cfquery name="Transact">
SELECT ProductID, Qty,dDate, TypeID, BranchID FROM vwProductTransactUnion
WHERE ddate >= #CreateODBCDate(StartDate)# AND ddate <= #CreateODBCDate(EndDate)# AND ProductID = '#form.ProductID#' AND BranchID = '#form.BranchID#'
</cfquery>

<cfquery name="TotalQty">
SELECT TypeID, SUM(Qty) AS Qty1 FROM vwProductTransactUnion
WHERE ddate >= #request.StartYear# AND ddate < #CreateODBCDate(StartDate)# AND ProductID = '#form.ProductID#' AND BranchID = '#form.BranchID#'
GROUP BY TypeID
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE TypeID = 'Sales' or TypeID = 'Transfer Out'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
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

<!---<cfdump var="#QtyIN#" label="QtyIN">
<cfdump var="#QtyOUT#" label="QtyOUT">
<cfdump var="#PreviousBal#" label="PreviousBal">
<cfdump var="#TotalQty2#" label="TotalQty2">
<cfdump var="#Transact#" label="Transact">--->


<cfif #Transact.recordCount# eq 0>
<table width="595" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="105"><strong>Date</strong></td>
<td width="121"><strong>Transaction</strong></td>
<td width="73"><div align="right"><strong>Qty</strong></div></td>
<td width="101" hidden="yes" ><div align="right"><strong>Cal</strong></div></td>
<td width="84"><div align="right"><strong>Balance</strong></div></td>
</tr>
<tr>
</tr>
<tr bgcolor="#C0C0C0">
  <td>&nbsp;</td>
  <td><div align="left"><strong>B/F</strong></div></td>
  <td>&nbsp;</td>
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
<table width="595" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td width="105"><strong>Date</strong></td><td width="121"><strong>Transaction</strong></td><td width="73"><div align="right"><strong>IN</strong></div></td><td width="73"><div align="right"><strong>OUT</strong></div></td><!--<td width="101" hidden="yes" ><div align="right"><strong>Cal</strong></div></td>--><td width="84"><div align="right"><strong>Balance</strong></div></td>
</tr>
<tr bgcolor="#C0C0C0">
  <td>&nbsp;</td>
  <td><div align="left"><strong>B/F.</strong></div></td><td>&nbsp;</td>
  <td>&nbsp;</td>
  <!--<td hidden="yes"><div align="right"></div></td>-->
  <td><div align="right"><strong>
    <cfoutput>#Qty2#</cfoutput>
    </strong></div></td>
</tr>
<cfoutput query="Transact">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(dDate,"dd/mm/yyyy")#</td><td>#TypeID#</td><td><div align="right"><cfif #TypeID# is "Sales">0<cfelseif #TypeID# is "Transfer Out">0<cfelse>#numberformat(Qty)#</cfif></div></td><td><div align="right"><cfif #TypeID# is "Sales">#numberformat(Qty)#<cfelseif #TypeID# is "Transfer Out">#numberformat(Qty)#<cfelse>0</cfif></div></td><!--<td hidden="yes"><div align="right">
#Qty2#
</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>


<cfif #Transact.TypeID# is "Sales">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #Transact.TypeID# is "Transfer Out">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>



<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance)#</div></td>
</tr>

</cfoutput>

</table>
</cfif>
</cfif>
</cfif>
</p>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>