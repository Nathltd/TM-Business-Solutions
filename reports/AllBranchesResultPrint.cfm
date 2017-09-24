<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
	
	<title><cfoutput>Sales Invoice :: #request.title#</cfoutput></title>
    <link rel="shortcut icon" href="../shared/TMicon.ico"/>
	
	<link rel='stylesheet' type='text/css' href='css/style.css' />
	<link rel='stylesheet' type='text/css' href='css/print.css' media="print" />
	<script type='text/javascript' src='js/jquery-1.3.2.min.js'></script>
	<script type='text/javascript' src='js/example.js'></script>
    <script type="text/javascript" src="num2word.js"></script>
    


</head>

<body>
<cfparam name="url.cfgridkey" default="#BranchID#">

<cfif #GetAuthUser()# eq "">
<div align="center">
<h2>AUTHORISED ACCESS VIOLATED! </h2>
</div>
<cfabort>
<cfelseif #url.cfgridkey# eq "">
<div align="center">
<h2>AUTHORISED ACCESS VIOLATED! </h2>
</div>
<cfabort>
</cfif>


<cfoutput>
<cfquery name="Sales">
SELECT BranchID,SalesID,AmountPaid,AccountID,SalesDate,CustomerID,StaffID
FROM Sales
WHERE SalesID = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>
<cfquery name="option">
select logo, terms, footer, vat, tin, vendor, pr, company
from invoiceOptions
</cfquery>
<cfquery name="cAddress">
SELECT company, address, customerPhone
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
<cfset company = #cAddress.address#>
<cfset address = #cAddress.customerPhone#>
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

<cfset Balance = #Amounts.TotalAmount#-#Amounts.AmountPaid#>
	<div id="page-wrap">
    <cfparam name="url.InvoiceType" default="">
    <cfparam name="url.type" default="">
            <cfif url.InvoiceType eq "">
            <cfset url.InvoiceType = "DUPLICATE">
			</cfif>
		<cfif url.type is 'order'>
        <div id="header">SALES ORDER</div>
        <cfelse>
		<div id="header">#url.InvoiceType# INVOICE</div>
        </cfif>
		
		<div id="identity">
		
            <div id="addressline">      
              <div id="address1">
            <Span id="address">#ucase(option.company)#</Span><br />
            <span> #request.CompanyAddress#<br />
Phone: #request.CompanyPhone#, #request.CompanyPhone2#</Span>
            <br />
Email: #request.CompanyEmail#</Span>
            </div>
            <div id="logo2" align="right">
              <img id="image" src="../Invoices/images/#option.logo#" alt="logo" height="80px" />
            </div>
            </div>
            <div id="bizDetails" hidden="yes">
              <table border="0" width="100%">
              <tr height="30px">
              <td id="bizDetails1"><input type="text" value=" VAT: #option.vat#" /></td><td id="bizDetails1"><input type="text" value=" TIN: #option.tin#" /></td><td id="bizDetails1"><input type="text" value=" V.##: #option.vendor#" /></td><td id="bizDetails1"><input type="text" value=" PR. ##: #option.pr#" /></td>
              </tr>
              </table>
            </div>
		
		</div>
		
		<div style="clear:both"></div>
		
		<div id="customer">

            <textarea rows="4" id="customer-title">Billed To: &##13;&##10; #customer# &##13;&##10; #company# &##13;&##10;  #address#
			</textarea>            

            <table id="meta">
                <tr>
                    <td class="meta-head">Invoice No.</td>
                    <td>#sales.SalesId#</td>
                </tr>
                <tr>

                    <td class="meta-head">Date</td>
                    <td><textarea>#dateformat(sales.salesDate,"dd/mm/yyyy")#</textarea></td>
                </tr>
                <tr>
                    <td class="meta-head">Issued At</td>
                    <td><div class="due">#Sales.BranchID#</div></td>
                </tr>

            </table>
		
		</div>
		
		<table id="items">
		
		  <tr>
		      <th>Quantity</th>
		      <th>Item</th>
		      <th>Unit-Cost<br />(&##x20a6)</th>
              <th>Discount<br />(&##x20a6)</th>
		      <th>Price<br />(&##x20a6)</th>
		  </tr>
		  <cfloop query="SalesDetails">
		  <tr class="item-row">
		      <td class="quantity" align="center">#LSNumberFormat(Qty,',999.00')#</td>
		      <td class="item-name">#ProductID#</td>
		      <td align="right"> #LSNumberFormat(UnitPrice,',9999999999.99')#</td>
              <td align="right"> #LSNumberFormat(discount,',999')#</td>
		      <td align="right"><span class="price"> #LSNumberFormat(Amt,',9999999999.99')#</span></td>
		  </tr>
		  </cfloop>
		  
		  <tr>

		      <td colspan="2" class="blank"> </td>
		      <td colspan="2" class="total-line"><strong>Total</strong></td>
		      <td class="total-value"><div id="total"><strong>&##x20a6 #LSNumberFormat(Amounts.TotalAmount,',9999999999.99')#</strong></div></td>
		  </tr>
		  <tr>
		      <td colspan="2" class="blank"> </td>
		      <td colspan="2" class="total-line"><strong>Amount Paid</strong></td>

		      <td class="total-value"><strong>&##x20a6 #LSNumberFormat(Amounts.AmountPaid,',9999999999.99')#</strong></td>
		  </tr>
		  <tr>
		      <td colspan="2" class="blank"> </td>
		      <td colspan="2" class="total-line balance"><strong>Balance Due</strong></td>
		      <td class="total-value balance"><div class="due"><strong>&##x20a6 #LSNumberFormat(Balance,',9999999999.99')#</strong></div></td>
		  </tr>
		
		</table>
		<cfquery name="option">
        select * from invoiceOptions
        where id = 1
        </cfquery>
		<div id="terms">
		  <h5>Terms</h5>
		  <textarea rows="7">#option.terms#</textarea>
		</div>
        <div>
        <input id="tAmount" type="hidden" value="#Amounts.TotalAmount#"/>
		 Amount in Words: <textarea cols="80" rows="1" id="amountInwords" type="text" readonly="readonly"></textarea>
		</div>
        <div id="signature">
		   <textarea rows="2" name="sign" id="sign">____________________                                                                                                                                                     __________________________
Customer's Signature                                                                                                                                                            For: #request.Company#</textarea>
		</div>

        <div align="center"  id="footer">
		  <span>#option.footer#</span>
		</div>
	
	</div>
</cfoutput>	
</body>

</html>