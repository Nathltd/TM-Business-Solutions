<!doctype html>
<html>
<head>
<title><cfoutput>Adjustments Details :: #request.title#</cfoutput></title>
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
<h4>Adjustments Details</h4>
<div id="RightColumn">

<cfquery name="AdjInventory">
SELECT AdjID, AdjDate, BranchID, StaffID, Comment, Creator
FROM AdjInventory
WHERE AdjID = <cfqueryparam value="#Trim(url.AdjID)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="vwAdjUpdate">
SELECT BranchID, ID, AdjID, ProductID, Description, SalePrice, Creator, Qty, LastUpdated, Amt
FROM vwAdjUpdate
WHERE AdjID = <cfqueryparam value="#Trim(url.AdjID)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="Amounts">
SELECT AdjID, Worth
FROM vwAdjWorth
WHERE AdjID = <cfqueryparam value="#Trim(url.AdjID)#" cfsqltype="cf_sql_clob">
</cfquery>


<cfoutput>
<cfdocument format="flashpaper" unit="in" margintop=".5" marginleft=".5" marginbottom="1">

<div align="left">
<img src="../shared/TMlogoSmall3.jpg" width="50" height="37">
<br>
<br>

<table width="70%">
<tr>
<td width="644">
<font size="+4" face="Segoe UI">#request.Company#</font>
<br>
<font size="-2">#request.CompanyAddress#</font>
</td>
<td colspan="2" align="left">
<font size="+2" face="Segoe UI" color="##666666"><strong>Stock Adjustment</strong></font>
</td>
</tr>
<tr>
<td>
</td>

<td width="95"><div align="left"><font size="-1" face="Segoe UI">Date:</font>  <font size="-1" face="Segoe UI"><br>
  Ref ##:</font></div></td>
<td width="180"><div align="left"><font size="-1" face="Segoe UI"><strong> #Dateformat(AdjInventory.AdjDate,"dd/mm/yyyy")#</strong></font></div>
<div align="left"><font size="-1" face="Segoe UI"><strong>  #AdjInventory.AdjID#</strong></font></div></td>
</tr>
<tr>
  <td></td>
  <td><div align="left"><font size="-1" face="Segoe UI">Issued at:</font></div></td>
  <td><div align="left"><font size="-1" face="Segoe UI"><strong>#AdjInventory.BranchID#</strong></font></div></td>
</tr>
<tr>
<td>
<div align="left">By:
<br>
#AdjInventory.StaffID#</div>
</td>
<td colspan="2">
  <div align="right"></div>
  <div align="right"></div></td>
</tr>
</table>

<br>

<div id="InvoiceRow">
<table width="70%">

<tr align="center">
<td width="150"><div align="left"> <strong>Item</strong></div></td>
<td width="452"><strong>Description</strong></td>
<td width="50"> <strong>Qty</strong></td>
<td width="70"> <strong>U/Cost</strong></td>
<td width="140"> <div align="right"><strong>Amount</strong></div></td>
</tr>


<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<cfloop query="vwAdjUpdate">
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#ProductID#</td>
<td align="left"> #Description# </td>
<td align="right"> #LSNumberFormat(Qty,',999')# </td>
<td align="right"> #LSNumberFormat(SalePrice,',9999999999.99')#</td>
<td align="right"> <div align="right">#LSNumberFormat(Amt,',9999999999.99')#</div></td>
</tr>
</cfloop>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>

<tr >
  <td align="center" colspan="4"><div align="right">TOTAL:</div></td>
  <td align="right"><div align="right"><strong>#LSNumberFormat(Amounts.Worth,',9999999999.99')#</strong></div></td>
</tr>


</table>
</div>
<br>
</div>

<cfdocumentitem type="footer">

</<br>
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>

</cfdocument>
</cfoutput>
</div>
</div>
</div>
</body>
</html>