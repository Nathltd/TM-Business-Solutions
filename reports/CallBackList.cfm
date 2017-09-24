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

    <cfquery name="callBack">
SELECT *
FROM modifyList
ORDER BY authorisedDate ASC 
  </cfquery>
  
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
    <td colspan="2" valign="top"><font size="+1" face="Segoe UI">Call Back List</font></td>
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
<table width="100%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="138"></td>
  <td width="132"><div align="left"></div></td>
  <td width="192" colspan="3"><div align="right"><cfoutput>Total Call Backs =<strong> #callBack.recordCount#</strong></cfoutput>&nbsp;</div></td>

  </tr>
  <tr>
  <td width="10%"><strong>Ref No.</strong></td>
  <td width="10%"><div align="left"><strong>Type</strong></div></td>
  <td width="15%"><div align="left"><strong>Authorised</strong></div></td>
  <td width="15%"><div align="left"><strong>Modified By</strong></div></td>
  <td width="12%"><div align="left"><strong>Author. Date</strong></div></td>
  <td width="12%"><div align="left"><strong>Modified Date</strong></div></td>
  <td width="25%"><div align="left"><strong>Comment</strong></div></td>
  <td width="10%"><div align="left"><strong>Status</strong></div></td>
  </tr>
<cfoutput query="callBack">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="138" align="left">#moduleId#</td><td width="192"><div align="left">#moduleType#</div></td><td width="94"><div align="left">#Authorised#</div></td><td width="89"><div align="left">#modifyUser#</div></td><td width="89"><div align="left">#dateformat(AuthorisedDate,"dd/mm/yyyy")#</div></td><td width="89"><div align="left">#dateformat(modifyDate,"dd/mm/yyyy")#</div></td><td width="89"><div align="left">#comment#</div></td><td width="89"><div align="left">#status#</div></td>
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
  <td width="192" colspan="2"><div align="right"><cfoutput>Total Call Backs =<strong> #callBack.recordCount#</strong></cfoutput>&nbsp;</div></td>
  <td width="94"><div align="right"><a href="?print=1">Print</a></div></td>
  </tr>
  <tr>
  <td width="10%"><strong>Ref No.</strong></td>
  <td width="10%"><div align="left"><strong>Type</strong></div></td>
  <td width="15%"><div align="left"><strong>Authorised</strong></div></td>
  <td width="15%"><div align="left"><strong>Modified By</strong></div></td>
  <td width="12%"><div align="left"><strong>Author. Date</strong></div></td>
  <td width="12%"><div align="left"><strong>Modified Date</strong></div></td>
  <td width="25%"><div align="left"><strong>Comment</strong></div></td>
  <td width="10%"><div align="left"><strong>Status</strong></div></td>
  </tr>
  
<cfoutput query="callBack">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="138" align="left">#moduleId#</td><td width="192"><div align="left">#moduleType#</div></td><td width="94"><div align="left">#Authorised#</div></td><td width="89"><div align="left">#modifyUser#</div></td><td width="89"><div align="left">#dateformat(AuthorisedDate,"dd/mm/yyyy")#</div></td><td width="89"><div align="left">#dateformat(modifyDate,"dd/mm/yyyy")#</div></td><td width="89"><div align="left">#comment#</div></td><td width="89"><div align="left">#status#</div></td>
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