<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>


<style type="text/css">
<!--
#InvoiceRow {
	height: 700px;
}
-->
</style>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<cfdocument format="flashpaper" unit="in" margintop=".5" marginleft=".5" marginbottom="1">
<div align="left">
<img src="../shared/TMlogoSmall3.jpg" width="50" height="37">
<br>
<br>
<cfoutput>
<table width="862">
<tr>
<td width="644">
<font size="+4" face="Segoe UI">#request.Company#</font>
<br>
<font size="-2">#request.CompanyAddress#</font>
</td>
<td colspan="2" align="right">
<font size="+3" face="Segoe UI" color="##666666"><strong>INVOICE</strong></font>
</td>
</tr>
<tr>
<td>
</td>

<td width="95"><div align="left"><font size="-1" face="Segoe UI">Date:</font>  <font size="-1" face="Segoe UI"><br>
  Invoice ##:</font></div></td>
<td width="107"><div align="left"><font size="-1" face="Segoe UI"><strong> #session.myDate#</strong></font></div>
<div align="left"><font size="-1" face="Segoe UI"><strong>  #session.SalesID#</strong></font></div></td>
</tr>
<tr>
  <td></td>
  <td><div align="left"><font size="-1" face="Segoe UI">Issued at:</font></div></td>
  <td><div align="left"><font size="-1" face="Segoe UI"><strong>#session.BranchID#</strong></font></div></td>
</tr>
<tr>
<td>
<div align="left">To:
<br>
#session.CustomerID#</div>
</td>
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
<cfoutput>
<tr align="center">
<td width="150"><div align="left"> <strong>Item</strong></div></td>
<td width="452"><strong>Description</strong></td>
<td width="50"> <strong>Qty</strong></td>
<td width="70"> <strong>U/Price</strong></td>
<td width="140"> <div align="right"><strong>Amount</strong></div></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#session.myInvoice[variables.counter].Name#</td>
<td align="left"> #session.myInvoice[variables.counter].ItemDescription# </td>
<td align="right"> #session.myInvoice[variables.counter].itemQuantity# </td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',9999999999.99')#</td>
<td align="right"> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',9999999999.99')#</div></td>

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
  <td align="right"><div align="right"><strong>#LSNumberFormat(session.Amount,',9999999999.99')#</strong></div></td>
</tr>
<tr>
  <td align="center" colspan="3"></td>
  <td align="center" bgcolor="#rowColor#"><div align="right">Paid:</div></td>
  <td align="right"><div align="right">#LSNumberFormat(session.AmountPaid,',9999999999.99')#</div></td>
</tr>
<tr >
  <td align="center" colspan="4"><div align="right">Balance:</div></td>
  <td align="right"><div align="right">#LSNumberFormat(session.Balance,',9999999999.99')#</div></td>
</tr>
</cfoutput>
</table>
</div>
<br>
</div>
<cfoutput>
<cfdocumentitem type="footer">
<div align="right">
<table>
<tr>
<td>
<div align="right"><font size="-1" face="Segoe UI">Signed By:</font></div>
</td>
<td>
<div align="left"><font size="-1" face="Segoe UI"><strong> #session.StaffID#</strong></font>
</div>
</td>
</tr>
</table>
</div><br>
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>
</div>

</body>
</html> 