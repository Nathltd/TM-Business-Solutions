<!doctype html>
<html>
<head>
<title><cfoutput>purchase Search :: #request.title#</cfoutput></title>
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
<cfparam name="url.print" default="">
<cfparam name="form.supplierId" default="">
<h4>purchase Search <cfoutput><cfif isdefined("form.Submit")> For #form.supplierId#</cfif></cfoutput></h4>
<div id="RightColumn">
<cfparam name="url.print" default="">
<cfif url.print is "yes">
<cfdocument format="flashpaper" unit="in" margintop=".1">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<p>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="90%">
  <tr>
    <td colspan="2" valign="top"><font size="-1" face="Segoe UI">purchase Report</font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2">supplier:</font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.supplierId#</font></strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2">Item:</font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2">#session.ProductID#</font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Date:</font></div></td><td width="127" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.startDate# - #session.endDate#</font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>

<cfquery name="purchaseSearch">
SELECT receiptDate, receiptId, ProductID, BranchID, Qty, Amt, vendorId
FROM vwpurchaseDetails
WHERE receiptDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #session.supplierId# is "All">
		<cfelse>
		AND vendorId = <cfqueryparam value="#trim(session.supplierId)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(session.ProductID)#"cfsqltype="cf_sql_clob">
         </cfif>
         ORDER BY receiptDate ASC
 </cfquery>

 
 <cfquery name="tsT">
SELECT SUM(Qty) AS Quantity, SUM(Amt) AS Amount
FROM vwpurchaseDetails
WHERE  receiptDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #session.supplierId# is "All">
		<cfelse>
		AND vendorId = <cfqueryparam value="#trim(session.supplierId)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(session.ProductID)#"cfsqltype="cf_sql_clob">
        </cfif> 		
</cfquery>

<cfif #purchaseSearch.recordCount# eq 0>
<h2>No record found! </h2>
<cfelse>

<table width="95%" border="0" cellpadding="5" cellspacing="0">
<tr>
<td ><strong><font face="Segoe UI" size="-2">Date</font></strong></td>
<td><strong><font face="Segoe UI" size="-2">Invoice No.</font></strong></td>
<td><strong><font face="Segoe UI" size="-2">Item</font></strong></td>
<td><strong><font face="Segoe UI" size="-2">Branch</font></strong></td>
<td align="right"><div align="right"><strong><font face="Segoe UI" size="-2">Quantity</font></strong></div></td>
<td align="right"><div align="right"><strong><font face="Segoe UI" size="-2">Value</font></strong></div></td>
</tr>
<tr>
<td></td>
</tr>

<cfoutput>
<cfloop query="purchaseSearch">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td><font face="Segoe UI" size="-1">#dateformat(receiptDate,"dd/mm/yyyy")#</font></td>
<td><font face="Segoe UI" size="-1">#receiptId#</font></td>
<td><div align="left"><font face="Segoe UI" size="-1">#ProductID#</font></div></td>
<td align="left"><div align="left"><font face="Segoe UI" size="-1">#BranchID#</font></div></td>
<td align="right" width="59"><div align="right"><font face="Segoe UI" size="-1">#numberformat(Qty)#</font></div></td>
<td align="right" width="59"><div align="right"><font face="Segoe UI" size="-1">#numberformat(Amt,",000.00")#</font></div></td>
</tr>
</cfloop>
<tr>
<td></td>
<td></td>
<td></td>
<td align="right"><strong><font face="Segoe UI" size="-1">Total:</font></strong></td>
<td align="right" width="59"><strong><font face="Segoe UI" size="-1">#numberformat(tsT.Quantity)#</font></strong></td>
<td align="right" width="59"><strong><font face="Segoe UI" size="-1">#numberformat(tsT.Amount,",000.00")#</font></strong></td>
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


<cfparam name="form.supplierId" default="">
<cfparam name="form.ProductID" default="">
<div align="right"><a href="?print=1">Print</a>&nbsp;</div><br>
<cfquery name="AllProducts">
SELECT ProductID FROM Inventory
ORDER BY ProductID
</cfquery>
<cfquery name="Allsuppliers">
SELECT vendorId FROM vendors
WHERE VendorType = 'Supplier'
ORDER BY vendorId
</cfquery>

<cfoutput>
<cfform action="#cgi.SCRIPT_NAME#" method="post">
<table width="90%">
<tr align="left" valign="top">
  <td valign="top" ><div align="left">Starting:</div></td>
  <td valign="top"><div align="left">Ending:</div></td>
  <td valign="top"><div align="left">Product:</div></td>
  <td valign="top"><div align="left">supplier:</div></td>
  
</tr>
<tr align="center" valign="top">
  <td width="120" valign="top" ><div align="left">
    <cfinput name="startDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" size="10" required="yes" mask="dd/mm/yyyy" message="Enter Starting Date" class="bold_10pt_black">
  </div>
    <label>
  </label>
  </td>
  <td width="120" valign="top">
    <div align="left">
      <cfinput name="endDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" size="10" required="yes" mask="dd/mm/yyyy" message="Enter Ending Date">
      </div></td>
  <td width="100" valign="top">
    <div align="left">
      <cfselect name="ProductID" message="Choose Product"  required="yes" id="ProductID" style="width:100">
      <option value="All" selected>All</option>
      <cfloop query="AllProducts">
      <option value="#ProductID#" <cfif AllProducts.ProductID is #form.ProductID#>
    selected </cfif>>#ProductID#</option>
      </cfloop>
        </cfselect>
    </div></td>
  <td width="100"valign="top">
    <div align="left">
      <cfselect name="supplierId" message="Choose supplier"  required="yes" id="supplierId" style="width:100">
      <option value="All" selected>All</option>
      <cfloop query="Allsuppliers">
      <option value="#vendorId#" <cfif Allsuppliers.vendorId is #form.supplierId#>
    selected </cfif>>#vendorId#</option>
      </cfloop>
        </cfselect>
    </div></td>
  <td width="56" valign="top"><div align="left">
    <cfinput name="Submit" value="Search" type="submit">
  </div></td>
</tr>
<tr>
  <td colspan="4">
    <div align="center"></div></td>
</tr>
</table>
</cfform>
</cfoutput>

<cfif isdefined ("submit")>
<cfset session.StartDate = "#Form.StartDate#">
<cfset session.EndDate = "#Form.EndDate#">
<cfset session.ProductID = "#form.ProductID#">
<cfset session.supplierId = "#form.supplierId#">


<cfquery name="purchaseSearch">
SELECT receiptDate, receiptID, ProductID, BranchID, Qty, Amt, vendorId
FROM vwpurchaseDetails
WHERE receiptDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #form.supplierId# is "All">
		<cfelse>
		AND vendorId = <cfqueryparam value="#trim(form.supplierId)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(form.ProductID)#"cfsqltype="cf_sql_clob">
         </cfif>
         ORDER BY receiptDate ASC
 </cfquery>
 
 <cfquery name="tsT">
SELECT SUM(Qty) AS Quantity, SUM(Amt) AS Amount
FROM vwpurchaseDetails
WHERE  receiptDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #form.supplierId# is "All">
		<cfelse>
		AND vendorId = <cfqueryparam value="#trim(form.supplierId)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(form.ProductID)#"cfsqltype="cf_sql_clob">
        </cfif> 		
</cfquery>
<cfif #purchaseSearch.recordCount# eq 0>
<h2> No Record Found! </h2>
<cfelse>
<table width="90%" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="83"><strong>Date</strong></td>
<td width="80"><strong>Invoice No.</strong></td>
<td width="79"><strong>Item</strong></td>
<td width="104"><strong>Branch</strong></td>
<td width="59"><div align="right"><strong>Quantity</strong></div></td>
<td width="59"><div align="right"><strong>Value</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="purchaseSearch">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#dateformat(receiptDate,"dd/mm/yyyy")#</td>
<td><a href="../reports/PurchasePrnt.cfm?cfgridkey=#receiptId#">#receiptId#</a></td>
<td><div align="left">#ProductID#</div></td>
<td align="left"><div align="left">#BranchId#</div></td>
<td align="right" width="59"><div align="right">#Qty#</div></td>
<td align="right" width="59"><div align="right">#numberformat(Amt,",000.00")#</div></td>
</tr>
</cfloop>
<tr>
<td></td>
<td></td>
<td></td>
<td align="left"><strong>Total:</strong></td>
<td align="right" width="59"><div align="right"><strong>#tsT.Quantity#</strong></div></td>
<td align="right" width="59"><div align="right"><strong>#Numberformat(tsT.Amount,",000.00")#</strong></div></td>
</tr>
</cfoutput>

</table>
</cfif>
<cfelse>

</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html> 