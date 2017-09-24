<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Waybill Reprint</h4>
<div id="RightColumn">

<cfquery name="Sales">
SELECT BranchID,SalesID,AmountPaid,AccountID,SalesDate,CustomerID,StaffID
FROM Sales
WHERE SalesID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="cAddress">
SELECT company, address
FROM Customers
WHERE customerId = '#sales.customerId#'
</cfquery>
<cfquery name="gAddress">
SELECT customerId, address, phone
FROM CustomersGen
WHERE salesId = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob"> AND Status = 'enabled'
</cfquery>
<cfif #gAddress.recordcount# eq 0>
<cfset customer = #sales.CustomerId#>
<cfset company = #cAddress.company#>
<cfset address = #cAddress.address#>
<cfelse>
<cfset customer = #gAddress.CustomerId#>
<cfset company = #gAddress.address#>
<cfset address = #gAddress.phone#>
</cfif>


<cfquery name="SalesDetails">
SELECT ID,SalesID,ProductID,Description,Qty,UnitPrice,Amt,discount
FROM vwSalesDetails
WHERE SalesID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="Amounts">
SELECT SalesID,TotalAmount,AmountPaid
FROM vwCustInvoiceTotalAmt
WHERE SalesID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfset Balance = #Amounts.AmountPaid# - #Amounts.TotalAmount#>
<cfdocument format="flashpaper" unit="in" margintop=".5" marginleft=".5" marginbottom="1">
<div align="left">
<img src="../shared/TMlogoSmall3.jpg" width="45" height="45">

<cfoutput>
<table width="862">
<tr>
  <td colspan="3">
  <font size="+4" face="Segoe UI"><strong>#request.Company#</strong></font>
  <br>  
  <span><font size="2">Add:&nbsp; #request.CompanyAddress#</font></span>
  <br>
  <span><font size="2">Tel:&nbsp;&nbsp; #request.CompanyPhone#</font></span>
  </td>
  <td width="194" colspan="2" align="right">
    <font size="+3" face="Segoe UI" color="##666666"><strong>WAYBILL</strong></font>
  </td>
</tr>
<tr>
  <td colspan="3">
    <br>
    <div align="left"><font size="3" face="Segoe UI">To:</font> <br>
      <font size="4" face="Segoe UI"><strong>#customer#</strong></font><br>
		#company#<br>
		#address#</div>
  </td>
  <td colspan="2"><font size="3" face="Segoe UI">Date:</font>&nbsp;<font size="2" face="Segoe UI"><strong> #Dateformat(Sales.SalesDate,"dd/mm/yyyy")#</strong></font>
  				  <br>
                  <font size="3" face="Segoe UI">Invoice ##:</font>&nbsp;<font size="2" face="Segoe UI"><strong> #Sales.SalesID#</strong></font>
                  <br>
                  <font size="3" face="Segoe UI">Issued at:</font>&nbsp; <font size="2" face="Segoe UI"><strong>#Sales.BranchID#</strong></font></td>
</tr>
<tr>
  <td colspan="3">&nbsp;</td>
  <td colspan="2">
    <div align="right"></div>
    <div align="right"></div></td>
</tr>
<tr>
<td width="129" bgcolor="EEEEEE">
<div align="left"></div>
</td>
<td width="207" bgcolor="EEEEEE"><div align="right">&nbsp;</div></td>
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
<table width="862" border="0" cellpadding="0" cellspacing="0">

<tr align="center">
<td width="119"><div align="left"><strong>ITEM</strong></div></td>
<td width="290"><div align="left"><strong>DESCRIPTION</strong></div></td>
<td width="45"> <div align="right"><strong>QTY</strong></div></td>
</tr>

<cfoutput query="SalesDetails">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#ProductID#</td>
<td align="left"> #Description# </td>
<td align="right"> #LSNumberFormat(Qty,',999')# </td>
</tr>
</cfoutput>
<tr>
  <td ></td>
</tr>
<tr>
  <td ><strong>S/N:</strong></td>
</tr>
<tr>
  <td ></td>
</tr>
<cfoutput>
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
</cfoutput>
</table>
</div>
<br>
<br/>
<br/>
</div>
<div>Goods sold in GOOD CONDITION are not returnable, No Refund of Money after payment<br/>
Thanks for your Patronage
</div>
<br/><br/>
<div id="Notice" align="center"></div><cfoutput>
<cfdocumentitem type="footer">
<div align="right">
<table align="left">
<tr>
<td>
<div align="right"><font size="3" face="Segoe UI">Customer's Sign:</font></div>
</td>
<td>
<div align="left"><font size="4" face="Segoe UI">......................</font>
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