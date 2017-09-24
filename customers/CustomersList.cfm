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
SELECT CustomerID, Company, Address, CustomerPhone, CustomerEmail, status, creditLimit
FROM Customers
ORDER BY CustomerID ASC 
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
    <td colspan="2" valign="top"><font size="+1" face="Segoe UI">Customer List</font></td>
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
<table width="700" cellpadding="0" cellspacing="5">
  <tr>
  <td width="138"></td>
  <td width="132"><div align="left"></div></td>
  <td width="192" colspan="3"><div align="right"><cfoutput>Customers on Record =<strong> #Customers.recordCount#</strong></cfoutput>&nbsp;</div></td>

  </tr>
  <tr>
  <td width="20%"><strong>Customer</strong></td>
  <td width="20%"><div align="left"><strong>Company</strong></div></td>
  <td width="20%"><div align="left"><strong>Address</strong></div></td>
  <td width="10%"><div align="left"><strong>Phone</strong></div></td>

  <td width="15%"><div align="right"><strong>Credit Limit</strong></div></td>
  <td width="5%"><div align="right"><strong>Status</strong></div></td>
  </tr>
<cfoutput query="Customers">
<cfif #status# is 'inactive'>
  <cfset fontColor = "##FF8040">
  <cfelse>
  <cfset fontColor = "##000000">
  </cfif>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td align="left"><a href="../reports/CustomerFiscalBal.cfm?id=#customerID#"><font color="#fontColor#">#CustomerID#</font></a></td><td><div align="left">#Company#</div></td><td><div align="left">#Address#</div></td><td width="94"><div align="left">#CustomerPhone#</div></td><td><div align="right">#numberformat(creditLimit,",000.00")#</div></td><td><div align="right">#status#</div></td>
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
  <td width="192" colspan="2"><div align="right"><cfoutput>Customers on Record =<strong> #Customers.recordCount#</strong></cfoutput>&nbsp;</div></td>
  <td width="94"><div align="right"><a href="?print=1">Print</a></div></td>
  </tr>
  <tr>
  <td width="20%"><strong>Customer</strong></td>
  <td width="20%"><div align="left"><strong>Company</strong></div></td>
  <td width="20%"><div align="left"><strong>Address</strong></div></td>
  <td width="10%"><div align="left"><strong>Phone</strong></div></td>
  <td width="3%"><div align="left"><strong>Email</strong></div></td>
  <td width="15%"><div align="right"><strong>Credit Limit</strong></div></td>
  <td width="5%"><div align="right"><strong>Status</strong></div></td>
  </tr>
<cfoutput query="Customers">
<cfif #status# is 'inactive'>
  <cfset fontColor = "##FF8040">
  <cfelse>
  <cfset fontColor = "##000000">
  </cfif>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td align="left"><a href="../reports/CustomerFiscalBal.cfm?id=#customerID#"><font color="#fontColor#">#CustomerID#</font></a></td><td><div align="left">#Company#</div></td><td><div align="left">#Address#</div></td><td width="94"><div align="left">#CustomerPhone#</div></td><td><div align="left">#CustomerEmail#</div></td><td><div align="right">#numberformat(creditLimit,",000.00")#</div></td><td><div align="right">#status#</div></td>
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