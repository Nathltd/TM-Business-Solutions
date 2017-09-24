<!doctype html>
<html>
<head>
<title><cfoutput>Product Costing :: #request.title#</cfoutput></title>
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

<h4>Product Cost Price</h4>

<div id="RightColumn">

    <cfquery name="Products">
SELECT Inventory.ProductID, Inventory.CategoryID, Inventory.Description, Inventory.CostPrice, vwCOGSPriceAvg.PriceAvg AS crntPrice
FROM Inventory LEFT JOIN vwCOGSPriceAvg ON Inventory.ProductID = vwCOGSPriceAvg.ProductID
ORDER BY Inventory.ProductID, Inventory.CategoryID ASC
  </cfquery>
  
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
  <td colspan="5"><div align="right"><cfoutput>Products on Record =<strong> #Products.recordCount#</strong></cfoutput>&nbsp;</div></td>

  </tr>
  <tr>
  <td width="350"><strong>Product</strong></td>
  <td width="157"><div align="left"><strong>Category</strong></div></td>
  <td width="400"><div align="left"><strong>Description</strong></div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha' or #GetUserRoles()# is 'Manager' or #GetUserRoles()# is 'Accountant1'>
  <td width="80"><div align="left"><strong>Initial</strong></div></td>
  <cfelse>
  </cfif>
  <td width="91"><div align="left"><strong>Current</strong></div></td>
  </tr>
<cfoutput query="Products">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="203" align="left">#ProductID#</td><td width="157"><div align="left">#CategoryID#</div></td><td width="295"><div align="left">#Description#</div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha'>
  <td width="80"><div align="right">#numberformat(Costprice,",999.99")#</div></td>
  <cfelse>
  </cfif>
  <td width="91"><div align="right">#numberformat(crntPrice,",999.99")#</div></td>
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
  <td colspan="2"></td>
  <td width="130"><div align="right"><cfoutput>Products on Record =<strong> #Products.recordCount#</strong></cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="?print=1">Print</a></div></td>
  </tr>
  <tr>
  <td width="120"><strong>Product</strong></td>
  <td width="111"><div align="left"><strong>Category</strong></div></td>
  <td width="223"><div align="left"><strong>Description</strong></div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha' or #GetUserRoles()# is 'Manager' or #GetUserRoles()# is 'Accountant1'>
  <td width="90"><div align="left" title="System Cost Price"><strong>Initial</strong></div></td>
  <cfelse>
  </cfif>
  <td width="101"><div align="left" title="Current Cost Price"><strong>Current</strong></div></td>
  </tr>
<cfoutput query="Products">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="300" align="left">#ProductID#</td><td width="150"><div align="left">#CategoryID#</div></td><td width="350"><div align="left">#Description#</div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha' or #GetUserRoles()# is 'Manager' or #GetUserRoles()# is 'Accountant1'>
  <td width="80"><div align="right">#numberformat(Costprice,",999.99")#</div></td>
  <cfelse>
  </cfif>
  <td width="91"><div align="right"><a href="ProductsCostingDetails.cfm?id=#productId#">#numberformat(crntPrice,",999.99")#</a></div></td>
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