<!doctype html>
<html>
<head>
<title><cfoutput>Transfer Report :: #request.title#</cfoutput></title>
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
<h4>Transfer Reprint</h4>
<div id="RightColumn">

<cfquery name="Sales">
SELECT TransferID, TransferDate, Source,  Destination,StaffId
FROM Transfers
WHERE TransferID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="SalesDetails">
SELECT ID,TransferID,ProductID,Description,Quantity,UnitPrice
FROM vwtransferUpdate
WHERE TransferID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="transferAmt">
select SUM(Amount) AS Total
FROM vwtransferUpdate
WHERE TransferID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="company">
select logo
from company
</cfquery>


<cfdocument format="flashpaper" unit="in" margintop=".5" marginleft=".5" marginbottom="1">
<div align="left">
<cfoutput>
<img src="../invoices/images/#company.logo#" height="50">
	</cfoutput>
<br>
<cfoutput>
<table width="862">
<tr>
  <td colspan="3">
  <font size="+4" face="Segoe UI">#request.Company#</font>
  <br>
    
  <span><font size="2">#request.CompanyAddress#</font></span>
  </td>
  <td width="194" colspan="2" align="right">
    <font size="+2" face="Segoe UI" color="##666666"><strong>TRANSFER NOTE</strong></font>
  </td>
</tr>
<tr>
  <td colspan="3">
    <br>
    <div align="left"></div>
  </td>
  <td colspan="2"><font size="3" face="Segoe UI">Date:</font>&nbsp;<font size="2" face="Segoe UI"><strong> #Dateformat(Sales.transferDate,"dd/mm/yyyy")#</strong></font>
  				  <br>
                  <font size="3" face="Segoe UI">Invoice ##:</font>&nbsp;<font size="2" face="Segoe UI"><strong> #Sales.transferID#</strong></font>
                  <br>
                  <font size="3" face="Segoe UI">Issued at:</font>&nbsp; <font size="2" face="Segoe UI"><strong>#Sales.source#</strong></font></td>
</tr>
<tr>
  <td colspan="3">&nbsp;</td>
  <td colspan="2">
    <div align="right"></div>
    <div align="right"></div></td>
</tr>
<tr>
<td width="129" bgcolor="EEEEEE">
<div align="left"><font size="4" >Destination:&nbsp;</font></div>
</td>
<td width="207" bgcolor="EEEEEE"><div align="right"><font size="4" face="Segoe UI"><strong>#Sales.destination#</strong></font>&nbsp;</div></td>
<td width="312" >&nbsp;</td>
<td colspan="2">
  <div align="right"></div>
  <div align="right"></div></td>
</tr>
</table>
</cfoutput>
<br>
<br>

<table  width="862">
<cfoutput> 
<tr>
<td></td>
</tr>
</cfoutput>
</table>
<div id="InvoiceRow">
<table width="862">

<tr align="center">
<td width="160"><div align="left"> <strong>Item</strong></div></td>
<td width="378"><strong>Description</strong></td>
<td width="86"> <strong>Qty</strong></td>
<td width="87"> <strong>U/Price</strong></td>
<td width="123"> <div align="right"><strong>Amount</strong></div></td>
</tr>

<cfoutput query="SalesDetails">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#ProductID#</td>
<td align="left"> #Description# </td>
<td align="right"> #LSNumberFormat(quantity,',999')# </td>
<td align="right"> #LSNumberFormat(UnitPrice,',999.99')#</td>
<cfset Amt = #Quantity#*#UnitPrice#>
<td align="right"> <div align="right">#LSNumberFormat(Amt,',999.99')#</div></td>
</tr>
</cfoutput>
<cfoutput>
<tr>
  <td ></td>
</tr>
<tr>
  <td colspan="3" >&nbsp;</td><td ><strong>Total</strong></td><td align="right"><strong>#NumberFormat(transferAmt.Total,',999.99')#</strong></td>
</tr>
<tr>
  <td ></td>
</tr>
<tr >
  <td align="center" colspan="5">&nbsp;</td>
  <td width="0" align="right"><div align="right"><strong></strong></div></td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr>
  <td align="center" colspan="5">&nbsp;</td>
  <td align="right"><div align="right"></div></td>
</tr>
</cfoutput>
</table>
</div>
<br>
<br/>
<br/>
</div>
<br/><br/>
<div id="Notice" align="center"></div><cfoutput>
<cfdocumentitem type="footer">
<div align="right">
<table align="left">
<tr>
<td>
<div align="right"><font size="3" face="Segoe UI"></font></div>
</td>
<td>
<div align="left"><font size="4" face="Segoe UI"><strong> </strong></font>
</div>
</td>
</tr>
</table>
<table align="right">
<tr>
<td>
<div align="right"><font size="3" face="Segoe UI">Signed By:</font></div>
</td>
<td>
<div align="left"><font size="4" face="Segoe UI"><strong> #Sales.StaffID#</strong></font>
</div>
</td>
</tr>
</table>
</div><br><br>
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>
</div>
</div>
</div>
</body>
</html>