<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>

</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<cfdocument format="flashpaper" unit="in" margintop=".5" marginleft=".5" marginbottom="1">
<div align="center">
<img src="../shared/TMlogoSmall3.jpg" width="50" height="37"><br>

<cfoutput>
<table width="763">
  <tr>
    <td colspan="2" rowspan="2" valign="top">
    <font size="+4" face="Segoe UI">#request.Company#</font>
<br>
<font size="2">#request.CompanyAddress#</font>
&nbsp;</td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="2">From:</font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="3">#session.Source#</font></strong></div></td>
  </tr>
  <tr>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="3">To:</font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="3">#session.Destination#</font></strong></div></td>
  </tr>
  <tr>
<td width="162" valign="bottom"><strong><font face="Segoe UI" size="4">Transfers Report</font></strong></td><td width="244"></td><td width="78" valign="baseline"><div align="left"><font face="Segoe UI" size="3">Between:</font></div></td><td width="241" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="3">#session.startDate# - #session.endDate#</font></strong></div></td>
</tr>
<tr>
<td valign="bottom">&nbsp;</td><td valign="baseline"></td><td valign="baseline"><div align="left"><font face="Segoe UI" size="3">Item:</font></div></td><td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="3">#session.ProductID#</font></strong></div></td>
</tr>
</table>
</cfoutput>
<br>

<cfquery name="TransferSearch">
SELECT TransferDate, TransferID, ProductID, Description, Source, Destination,Quantity
FROM vwTransferUpdate
WHERE 	TransferDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #session.Source# is "All">
		<cfelse>
        AND Source = <cfqueryparam value="#trim(session.Source)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.Destination# is "All">
		<cfelse>
        AND Destination = <cfqueryparam value="#trim(session.Destination)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(session.ProductID)#"cfsqltype="cf_sql_clob">
        </cfif>
        ORDER BY TransferDate ASC
 </cfquery>
 
 <cfquery name="tsT">
SELECT SUM(Quantity) AS Qty
FROM vwTransferUpdate
WHERE 	TransferDate between <cfqueryparam value="#dateformat(session.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(session.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #session.Source# is "All">
		<cfelse>
        AND Source = <cfqueryparam value="#trim(session.Source)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.Destination# is "All">
		<cfelse>
        AND Destination = <cfqueryparam value="#trim(session.Destination)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #session.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(session.ProductID)#"cfsqltype="cf_sql_clob">
        </cfif> 
</cfquery>

<cfif #TransferSearch.recordCount# eq 0>
<table width="571" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="83"><strong><font face="Segoe UI" size="-1">Date</font></strong></td>
<td width="80"><strong> No.</strong></td>
<td width="79"><strong>Item</strong></td>
<td width="104"><strong>Source</strong></td>
<td width="104"><strong>Destination</strong></td>
<td width="59"><div align="right"><strong>Quantity</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>No Date</td>
<td width="80">None</td>
<td><div align="left">#Session.ProductID#</div></td>
<td align="left"><div align="left">#Session.Source#</div></td>
<td align="left"><div align="left">#Session.Destination#</div></td>
<td align="right" width="59"><div align="right">0</div></td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
<td align="left"></td>
<td align="right"><strong>Total:</strong></td>
<td align="right" width="59"><div align="right"><strong>0</strong></div></td>
</tr>
</cfoutput>

</table>
<cfelse>

<table width="750" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="75"><strong>Date</strong></td>
<td width="69"><strong>Ref #</strong></td>
<td width="78"><strong>Item</strong></td>
<td width="74"><strong>Source</strong></td>
<td width="76"><strong>Destination</strong></td>
<td width="60"><div align="right"><strong>Quantity</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="TransferSearch">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#dateformat(TransferDate,"dd/mm/yyyy")#</td>
<td>#TransferID#</td>
<td width="220"><div align="left">#ProductID#</div></td>
<td width="180"><div align="left">#Source#</div></td><td align="right" width="150"><div align="left">#Destination#</div></td>
<td align="right" width="60"><div align="right">#Quantity#</div></td>
</tr>
</cfloop>
<tr>
<td></td>
<td></td>
<td></td>
<td></td><td align="right"></td>
<td align="left"><strong>Total:</strong></td>
<td align="right" width="48"><div align="right"><strong>#tsT.Qty#</strong></div></td>
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
</div>
</div>

</body>
</html> 