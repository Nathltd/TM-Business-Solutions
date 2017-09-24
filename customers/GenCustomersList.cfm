<!doctype html>
<html>
<head>
<title><cfoutput>Customer List  :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">

<h4>Customer List</h4>

<div id="RightColumn">

    <cfquery name="Customers">
SELECT *
FROM CustomersGen
where status = 'enabled'
ORDER BY CustomerID ASC 
  </cfquery>
  <cfif #customers.recordCount# eq 0>
  <h2>No Record Found</h2>
  <cfabort>
  </cfif>
  <cfparam name="url.print" default="">
<cfif url.print is "yes">

<cfdocument format="flashpaper" unit="in" margintop=".1">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<p>
<cfoutput>
<font size="+2" face="Segoe UI"><strong>#request.Company# Accounts</strong></font><br>

<table width="699">
  <tr>
    <td colspan="2" valign="top"><font size="+1" face="Segoe UI">General Customers List</font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td width="171" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
    <td width="182"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td><td width="154" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>
<table width="700" cellpadding="0" cellspacing="5">
  <tr>
  <td width="138"></td>
  <td width="132"><div align="left"></div></td>
  <td width="192" colspan="3"><div align="right"><cfoutput>Customers on Record =<strong> #Customers.recordCount#</strong></cfoutput>&nbsp;</div></td>

  </tr>
  <tr>
  <td width="110"><strong>Customer</strong></td>
  
  <td width="170"><div align="left"><strong>Address</strong></div></td>
  <td width="110"><div align="left"><strong> Phone</strong></div></td>
  <td width="120"><div align="left"><strong>Invoice No.</strong></div></td>
  </tr>
<cfoutput query="Customers">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="300" align="left">#CustomerID#</td><td width="300"><div align="left">#Address#</div></td><td width="94"><div align="left">#Phone#</div></td><td width="89"><div align="left">#salesId#</div></td>
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

  <table width="80%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="138"></td>
  <td width="132"><div align="left"></div></td>
  <td width="192" colspan="2"><div align="right"><cfoutput>General Customers on Record =<strong> #Customers.recordCount#</strong></cfoutput>&nbsp;</div></td>
  <td width="94"><div align="right"><a href="?print=1">Print</a></div></td>
  </tr>
  <tr>
  <td width="20%"><strong>Customer</strong></td>
  <td width="40%"><div align="left"><strong>Address</strong></div></td>
  <td width="20%"><div align="left"><strong>Phone</strong></div></td>
  <td width="20%"><div align="left"><strong>Invoice No.</strong></div></td>
  </tr>
<cfoutput query="Customers">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="138" align="left"><a href="../reports/CustomerGenFiscalBal.cfm?id=#customerID#&inv=#salesId#">#CustomerID#</a></td><td width="192"><div align="left">#Address#</div></td><td width="94"><div align="left">#Phone#</div></td><td width="89"><div align="left"><a href="../reports/InvoicePrnt.cfm?CFGRIDKEY=#salesid#">#salesId#</a></div>
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