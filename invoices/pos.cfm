<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>

<body>

<div align="center">


<div id="RightColumnPrnt">

<cfquery name="Sales">
SELECT BranchID,SalesID,AmountPaid,AccountID,SalesDate,CustomerID,StaffID
FROM Sales
WHERE SalesID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="SalesDetails">
SELECT ID,SalesID,ProductID,Description,Qty,UnitPrice,Amt,discount
FROM vwSalesDetails
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

<cfquery name="Amounts">
SELECT SalesID,TotalAmount,AmountPaid
FROM vwCustInvoiceTotalAmt
WHERE SalesID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfset Balance = #Amounts.AmountPaid# - #Amounts.TotalAmount#>

<div align="left">
<img src="../shared/TMlogoSmall3.jpg" width="30" height="30">

<cfoutput>
<table width="586">
<tr>
<td width="578">
  <font size="+3" face="Segoe UI"><strong>#request.Company#</strong></font>
  <br>
  <font size="+1">Add:&nbsp;&nbsp;#request.CompanyAddress#</font><br>
  <font size="+1">Tel:&nbsp;&nbsp;&nbsp;#request.CompanyPhone#</font><br>
  <font size="+3" face="Segoe UI" color="##666666"><strong>INVOICE</strong></font></td>
</tr>
<tr>
<td><div align="left"><strong><font size="-1" face="Segoe UI">Date:</font>&nbsp;&nbsp;<strong> <font size="-1" face="Segoe UI">#Dateformat(Sales.SalesDate,"dd/mm/yyyy")#</font>
  </strong> <font size="-1" face="Segoe UI"><br>
    Invoice ##:</font></strong><strong><font size="-1" face="Segoe UI">  #Sales.SalesID#</font></strong></div>
  </td>
</tr>
<tr>
  <td><div align="left"><strong><font size="-1" face="Segoe UI">Issued at:</font></strong>&nbsp;<strong><font size="-1" face="Segoe UI">#Sales.BranchID#</font></strong></div></td>
  </tr>
<tr>
<td>
 	<div align="left"><strong>To:  #customer#<br>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  #company#<br>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  #address#</strong></div>
</td>
</tr>
<tr>
<td >
  <div align="left"><strong> Paid:&nbsp;</strong><strong>#LSNumberFormat(Amounts.AmountPaid,',9999999999.99')#&nbsp;</strong></div>
</td>
</tr>
</table>
</cfoutput><br>

<table  width="862">
<cfoutput> 
<tr>
<td></td>
</tr>
</cfoutput>
</table>
<div id="InvoiceRow">
<table width="450">

<tr align="center">
<td width="150"><div align="left"> <strong>Item</strong></div></td>
<td width="41"> <div align="right"><strong>Qty</strong></div></td>
<td width="50"> <div align="right"><strong>Price</strong></div></td>
<td width="50"> <div align="right"><strong>Disc</strong></div></td>
<td width="90"> <div align="right"><strong>Amt</strong></div></td>
</tr>

<cfoutput query="SalesDetails">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left"><strong>#ProductID#</strong></td>
<td align="right"> <div align="right"><strong>#LSNumberFormat(Qty,',999')# </strong></div></td>
<td align="right"> <div align="right"><strong>#LSNumberFormat(UnitPrice,',999.99')#</strong></div></td>
<td align="right"> <div align="right"><strong>#LSNumberFormat(Discount,',9999999999.99')#</strong></div></td>
<td align="right"> <div align="right"><strong>#LSNumberFormat(Amt,',9999999999.99')#</strong></div></td>
</tr>
</cfoutput>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>
<cfoutput>
<tr >
  <td align="center" colspan="4"><div align="right"><strong>TOTAL:</strong></div></td>
  <td align="right"><div align="right"><strong>#LSNumberFormat(Amounts.TotalAmount,',9999999999.99')#</strong></div></td>
  </tr>
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr>
  <td align="center" colspan="4"><div align="right"><strong>Balance:</strong></div></td>
  <td align="right"><div align="right"><strong>#LSNumberFormat(Balance,',9999999999.99')#</strong></div></td>
  </tr>
</cfoutput>
</table>
</div>
<br>
</div>
<cfoutput>
<div align="left">
<table>
<tr>
<td>
<div align="right"><strong><font size="-1" face="Segoe UI">Signed By:</font></strong></div>
</td>
<td>
<div align="left"><strong><font size="-1" face="Segoe UI"> #Sales.StaffID#</font>
</strong></div>
</td>
</tr>
</table>
</div><br>
</cfoutput>

</div>
</div>
</body>