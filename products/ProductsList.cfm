<!doctype html>
<html>
<head>
<title><cfoutput>Product List :: #request.title#</cfoutput></title>
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

<h4>Product List</h4>

<div id="RightColumn">

    <cfquery name="Products">
SELECT barcode, ProductID, CategoryID, Description, Costprice, saleprice, reorderLevel, Status
FROM Inventory
ORDER BY ProductID, CategoryID ASC 
  </cfquery>
  
  <cfparam name="url.print" default="">
<cfif url.print is "yes">

<cfdocument format="flashpaper" unit="in" margintop=".3" marginleft=".3" marginright=".3" marginbottom=".3">
<style>
#row{
	font-size:11px;
}
</style>
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<p>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="100%">
  <tr id="row">
    <td colspan="2" valign="top"><font size="+1" face="Segoe UI">Product List</font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
  </tr>
  <tr id="row">
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td><td width="127" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>
<table width="100%" cellpadding="0" cellspacing="0">
  <tr id="row">
  <td colspan="8"><div align="right"><cfoutput>Products on Record =<strong> #Products.recordCount#</strong></cfoutput>&nbsp;</div></td>

  </tr>
  <tr id="row">
  <td width="50"><strong>S/N</strong></td>
  <td width="50"><strong>Barcode</strong></td>
  <td width="320"><strong>Product</strong></td>
  <td width="157"><div align="left"><strong>Category</strong></div></td>
  <td width="350"><div align="left"><strong>Description</strong></div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha'  or #GetUserRoles()# is 'Manager' or #GetUserRoles()# is 'Accountant1' or #GetUserRoles()# is 'Procurement'>
  <td width="80"><div align="right"><strong>C-Price</strong></div></td>
  </cfif>
  <td width="91"><div align="right"><strong>S-Price</strong></div></td>
  <td width="91"><div align="right"><strong>R-Level</strong></div></td>
  <td width="91"><div align="right"><strong>Status</strong></div></td>
  </tr>
<cfoutput query="Products">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr id="row" bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#currentRow#</td>
<td>#barcode#</td>
  <td width="203" align="left">#ProductID#</td><td width="157"><div align="left">#CategoryID#</div></td><td width="295"><div align="left">#Description#</div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha'  or #GetUserRoles()# is 'Manager' or #GetUserRoles()# is 'Accountant1' or #GetUserRoles()# is 'Procurement'>
  <td width="80"><div align="right">#numberformat(Costprice,",999.99")#</div></td>
  </cfif>
  <td width="91"><div align="right">#numberformat(Saleprice,",999.99")#</div></td>
  <td width="91"><div align="right">#numberformat(reOrderLevel,",9")#</div></td>
  <td width="91"><div align="right">#Status#</div></td>
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
<div align="right"><cfoutput>Products on Record =<strong> #Products.recordCount#</strong></cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;<a href="?print=1">Print</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
  <table width="95%" cellpadding="3" cellspacing="0">
  <tr>
  <td colspan="2"></td>
  <td>&nbsp;</td>
  </tr>
  <tr>
  <td width="2%"><strong>S/N</strong></td>
  <td width="50"><strong>Barcode</strong></td>
  <td width="180"><strong>Product</strong></td>
  <td width="157"><div align="left"><strong>Category</strong></div></td>
  <td width="200"><div align="left"><strong>Description</strong></div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha'  or #GetUserRoles()# is 'Manager' or #GetUserRoles()# is 'Accountant1' or #GetUserRoles()# is 'Procurement'>
  <td width="10%"><div align="right"><strong>C-Price</strong></div></td>
  <cfelse>
  </cfif>
  <td width="6%"><div align="right"><strong>S-Price</strong></div></td>
  <td width="6%"><div align="right"><strong>R-Level</strong></div></td>
  <td width="5%"><div align="right"><strong>Status</strong></div></td>
  </tr>
<cfoutput query="Products">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#currentRow#</td>
<td>#barcode#</td>
  <td width="167" align="left">#ProductID#</td><td width="157"><div align="left">#CategoryID#</div></td><td width="256"><div align="left">#Description#</div></td>
  <cfif #GetUserRoles()# is 'Administrator' or #GetUserRoles()# is 'Alpha'  or #GetUserRoles()# is 'Manager' or #GetUserRoles()# is 'Accountant1' or #GetUserRoles()# is 'Procurement'>
  <td width="74"><div align="right">#numberformat(Costprice,",999.99")#</div></td>
  <cfelse>
  </cfif>
  <td width="71"><div align="right">#numberformat(Saleprice,",999.99")#</div></td>
  <td width="97"><div align="right">#numberformat(reOrderLevel,",9")#</div></td>
  <td width="91"><div align="right">#Status#</div></td>
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