<!doctype html>
<html>
<head>
<title><cfoutput>Suppliers/Vendors List :: #request.title#</cfoutput></title>
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

<h4>Supplier List</h4>

<div id="RightColumn">

    <cfquery name="Vendors">
SELECT VendorID, Company, Address, Phone, Email, VendorType
FROM Vendors
ORDER BY VendorType DESC, VendorID ASC 
  </cfquery>
  
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
    <td colspan="2" valign="top"><font size="+1" face="Segoe UI">Supplier List</font></td>
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
  <td width="138"></td>
  <td width="132"><div align="left"></div></td>
  <td width="192" colspan="4"><div align="right"><cfoutput>Suppliers on Record =<strong> #Vendors.recordCount#</strong></cfoutput>&nbsp;</div></td>

  </tr>
  <tr>
  <td width="138"><strong>Supplier</strong></td>
  <td width="132"><div align="left"><strong>Company</strong></div></td>
  <td width="192"><div align="left"><strong>Address</strong></div></td>
  <td width="94"><div align="left"><strong> Phone</strong></div></td>
  <td width="89"><div align="left"><strong>Email</strong></div></td>
    <td width="89"><div align="left"><strong>Type</strong></div></td>
  </tr>
<cfoutput query="Vendors">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="138" align="left">#VendorID#</td><td width="132"><div align="left">#Company#</div></td><td width="192"><div align="left">#Address#</div></td><td width="94"><div align="left">#Phone#</div></td><td width="89"><div align="left">#Email#</div></td><td width="89"><div align="left">#VendorType#</div></td>
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
  <td width="138"></td>
  <td width="132"><div align="left"></div></td>
  <td width="192" colspan="3"><div align="right"><cfoutput>Suppliers on Record =<strong> #Vendors.recordCount#</strong></cfoutput>&nbsp;</div></td>
  <td width="94"><div align="right"><a href="?print=1">Print</a></div></td>
  </tr>
  <tr>
  <td width="138"><strong>Supplier</strong></td>
  <td width="132"><div align="left"><strong>Company</strong></div></td>
  <td width="192"><div align="left"><strong>Address</strong></div></td>
  <td width="94"><div align="left"><strong> Phone</strong></div></td>
  <td width="89"><div align="left"><strong>Email</strong></div></td>
    <td width="89"><div align="left"><strong>Type</strong></div></td>
  </tr>
<cfoutput query="Vendors">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="138" align="left"><a href="../Reports/SupplierFiscalBal.cfm?id=#VendorID#">#VendorID#</a></td><td width="132"><div align="left">#Company#</div></td><td width="192"><div align="left">#Address#</div></td><td width="94"><div align="left">#Phone#</div></td><td width="89"><div align="left">#Email#</div></td><td width="89"><div align="left">#VendorType#</div></td>
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