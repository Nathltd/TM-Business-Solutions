<!doctype html>
<html>
<head>
<title><cfoutput>Product Costing Details :: #request.title#</cfoutput></title>
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

<h4>Product Costing Details (<cfoutput>#url.id#</cfoutput>) </h4>

<div id="RightColumn">

    <cfquery name="Products">
Select ProductId, BranchId, ReceiptId, ReceiptDate, Qty, UnitPrice, Amt, Type
from vwCostOfGoodsUnion
where productId = '#url.id#'
  </cfquery>
  <cfquery name="summ" dbtype="query">
  select SUM(qty) AS Qtyy, SUM(UnitPrice) AS Uprice, SUM(Amt) AS Amtt
  from products
  </cfquery>

  <cfparam name="url.print" default="">
<cfif url.print is "yes">

<cfdocument format="flashpaper" unit="in" margintop=".1">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<p>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="100%">
  <tr>
    <td colspan="2" valign="top"><font size="+1" face="Segoe UI">Product List</font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td><td width="127" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>
<table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td colspan="5"></td>
  </tr>
  <tr>
  <td width="350"><strong>Date</strong></td>
  <td width="157"><div align="left"><strong>Branch</strong></div></td>
  <td width="400"><div align="left"><strong>Reference</strong></div></td>
    <td width="91"><div align="left"><strong>Type</strong></div></td>
  <td width="80"><div align="left"><strong>Quantity</strong></div></td>
  <td width="91"><div align="left"><strong>Amount</strong></div></td>
    <td width="91"><div align="left"><strong>Price</strong></div></td>
  </tr>
<cfoutput query="Products">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="120" align="left">#dateformat(ReceiptDate,"dd/mm/yyyy")#</td>
  <td width="157"><div align="left">#BranchId#</div></td>
  <td width="295"><div align="left">#ReceiptId#</div></td>
  <td width="295"><div align="left">#Type#</div></td>
  <td width="295"><div align="left">#Qty#</div></td>
  <td width="120"><div align="right">#numberformat(Amt,",999.99")#</div></td>
  <td width="120"><div align="right">#numberformat(UnitPrice,",999.99")#</div></td>
  </tr>
</cfoutput>
</table>
</div>
<cfoutput>
<cfdocumentitem type="footer">
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>

<cfelse>

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td colspan="5"></td>
  </tr>
  <tr>
  <td width="350"><strong>Date</strong></td>
  <td width="157"><div align="left"><strong>Branch</strong></div></td>
  <td width="400"><div align="left"><strong>Reference</strong></div></td>
    <td width="91"><div align="left"><strong>Type</strong></div></td>
  <td width="80"><div align="right"><strong>Quantity</strong></div></td>
  <td width="91"><div align="right"><strong>Amount</strong></div></td>
    <td width="91"><div align="right"><strong>Price</strong></div></td>
  </tr>
<cfoutput query="Products">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="10%" align="left">#dateformat(ReceiptDate,"dd/mm/yyyy")#</td>
  <td width="20%"><div align="left">#BranchId#</div></td>
  <td width="15%"><div align="left">#ReceiptId#</div></td>
  <td width="15%"><div align="left">#Type#</div></td>
  <td width="10%"><div align="right">#Qty#</div></td>
  <td width="15%"><div align="right">#numberformat(Amt,",999.99")#</div></td>
  <td width="20%"><div align="right">#numberformat(UnitPrice,",999.99")#</div></td>
  </tr>
</cfoutput>

<cfoutput>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="15%" colspan="4"><div align="right">Total:</div></td>
  <td width="10%"><div align="right">#numberformat(summ.Qtyy,",999")#</div></td>
  <td width="15%"><div align="right">#numberformat(summ.Amtt,",999.99")#</div></td>
  <cfset uPrice = #summ.Amtt#/#summ.Qtyy#>
  <td width="20%"><div align="right"><font color="##0000FF" title="Actual Cost">#numberformat(uPrice,",999.99")#</font></div></td>
  </tr>
  </cfoutput>
</table>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>

</body>
</html>