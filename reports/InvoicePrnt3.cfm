<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Invoice Reprint</h4>
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
<cfdocument format="flashpaper" unit="in" margintop=".2" marginleft=".5" marginbottom=".7">
<div align="left">

<cfoutput>
<table width="911">
<tr>
  <td colspan="3">
    <cfquery name="branch">
select id from branches
where branchId = '#sales.BranchId#'
</cfquery>

<cfif #branch.Id# eq 1>
  <img style="margin:0" src="../image/invBanner1.jpg">
  <cfelseif #branch.Id# eq 2>
  <img style="margin:0" src="../image/invBanner2.jpg">
  <cfelseif #branch.Id# eq 5>
  <img style="margin:0" src="../image/invBanner5.jpg">
  </cfif>
  </td>
  <td width="167" colspan="2" align="right" valign="top">
    <font size="+3" face="Segoe UI" color="##666666"><strong>INVOICE</strong></font>
  </td>
</tr>
<tr>
  <td colspan="3">
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
<td width="138" bgcolor="EEEEEE">
<div align="left"><font size="4" >Amount Paid:&nbsp;</font></div>
</td>
<td width="223" bgcolor="EEEEEE"><div align="right"><font size="4" face="Segoe UI"><strong>#LSNumberFormat(Amounts.AmountPaid,',9999999999.99')#</strong></font>&nbsp;</div></td>
<td width="363" >&nbsp;</td>
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
<td width="119"><div align="left"><strong>ITEM</strong></div></td>
<td width="290"><div align="left"><strong>DESCRIPTION</strong></div></td>
<td width="45"> <strong>QTY</strong></td>
<td width="81"> <strong>PRICE</strong></td>
<td width="110"> <strong>DISCOUNT</strong></td>
<td width="190"> <div align="right"><strong>AMOUNT</strong></div></td>
</tr>

<cfoutput query="SalesDetails">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#ProductID#</td>
<td align="left"> #Description# </td>
<td align="right"> #LSNumberFormat(Qty,',999')# </td>
<td align="right"> #LSNumberFormat(UnitPrice,',9999999999.99')#</td>
<td align="right"> #LSNumberFormat(discount,',999')# </td>
<td align="right"> <div align="right">#LSNumberFormat(Amt,',9999999999.99')#</div></td>
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
<tr >
  <td align="center" colspan="5"><div align="right">TOTAL:</div></td>
  <td align="right"><div align="right"><strong>#LSNumberFormat(Amounts.TotalAmount,',9999999999.99')#</strong></div></td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr>
  <td align="center" colspan="5"><div align="right">Balance:</div></td>
  <td align="right"><div align="right">#LSNumberFormat(Balance,',9999999999.99')#</div></td>
</tr>
</cfoutput>
</table>
</div>
<br>
<br/>
<br/>
</div>
<div><font size="-1">Goods sold in GOOD CONDITION are not returnable<br>
No Refund of Money after payment<br/>
Warranty only covers the cost of repairs and not for<br>
replacement or refund.<br>
Thanks for your Patronage
</font>
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
<div align="center"><font size="-3" face="Segoe UI">Generated by <font color="blue"><strong>transacTMananger</strong> </font>Online Invoicing</font></div>
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>
</div>
</div>
</div>
</body>