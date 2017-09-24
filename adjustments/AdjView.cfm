<!doctype html>
<html>
<head>
<title><cfoutput>Adjustments View :: #request.title#</cfoutput></title>
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

<h4>Adjustments View</h4>

<div id="RightColumn">

<cfif isdefined ("url.Adjid")>

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
<td width="107"><div align="left"><font size="-1" face="Segoe UI"><strong> #Dateformat(AdjInventory.AdjDate,"dd/mm/yyyy")#</strong></font></div>
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
<td width="145"><div align="left"> <strong>Item</strong></div></td>
<td width="435"><strong>Description</strong></td>
<td width="48"> <strong>Qty</strong></td>
<td width="87"> <strong>U/Cost</strong></td>
<td width="123"> <div align="right"><strong>Amount</strong></div></td>
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

<tr >
  <td align="center" colspan="4"><div align="right">TOTAL:</div></td>
  <td align="right"><div align="right"><strong>#LSNumberFormat(Amounts.Worth,',9999999999.99')#</strong></div></td>
</tr>
<tr >
  <td colspan="4" align="center"><div align="left">&nbsp;</div></td>
  <td align="right">&nbsp;</td>
</tr>
<tr >
  <td align="center"><div align="left"><strong>Comment:</strong></div></td>
  <td colspan="3" align="center"><div align="left">#AdjInventory.comment#&nbsp;</div></td>
  <td align="right">&nbsp;</td>
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

<cfelse>

    <cfquery name="AdjView">
SELECT ID, AdjID, AdjDate, BranchID, Worth, Creator
FROM vwAdjWorth
ORDER BY AdjDate ASC 
  </cfquery>
<cfif #AdjView.recordcount# is 0>
<p>
No adjustment record available
</p>
<cfelse>
  <div align="right">
  <cfoutput>Adjustments on Record =<strong> #AdjView.recordCount#</strong></cfoutput>&nbsp;
  </div>

  <table width="70%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="182"><strong>Date</strong></td>
  <td width="130"><div align="left"><strong>Ref #</strong></div></td>
  <td width="130"><div align="left"><strong>Branch</strong></div></td>
  <td width="130"><div align="left"><strong>Authorised by</strong></div></td>
  <td width="125"><div align="right"><strong>Value</strong></div></td>
  </tr>
<cfoutput query="AdjView">

  <cfif #AdjView.Worth# lte 0>
<cfset Bcolor="009900"><!---Green--->
<cfelse>
<cfset Bcolor="FF0000"><!---Red--->
</cfif>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="182" align="left">#Dateformat(AdjDate,"dd/mm/yyyy")#</td><td width="130"><div align="left"><font style="font-weight: normal"><a href="#cgi.SCRIPT_NAME#?Adjid=#AdjID#">#AdjID#</a></font></div></td><td width="130"><div align="left"><font style="font-weight: normal">#BranchID#</font></div></td><td width="130"><div align="left"><font style="font-weight: normal">#Creator#</font></div></td><td width="125"><div align="right"><font color="#Bcolor#">#numberformat(Worth,",000.00")#</font></div></td>
  </tr>
</cfoutput>
      <cfquery name="AdjTotal">
SELECT SUM(Worth) AS Totl
FROM vwAdjWorth 
  </cfquery>
<cfoutput>
  <tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="182" align="left"><strong>Total</strong></td><td width="130"><div align="right"><strong></strong></div></td><td width="130"><div align="right"><strong></strong></div></td><td width="130" align="right"><div align="right"><strong></strong></div></td><td width="125" align="right"><div align="right"><strong>#numberformat(AdjTotal.Totl,",000.00")#</strong></div></td>
  </tr>
  </cfoutput>
</table>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>

</body>
</html>