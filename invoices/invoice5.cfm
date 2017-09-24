<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
	
	<title><cfoutput>Sales Invoice :: #request.title#</cfoutput></title>
    <link rel="shortcut icon" href="../shared/TMicon.ico"/>
	
	<link rel='stylesheet' type='text/css' href='css/style5.css' />
	<link rel='stylesheet' type='text/css' href='css/print.css' media="print" />
	<script type='text/javascript' src='js/jquery-1.3.2.min.js'></script>
	<script type='text/javascript' src='js/example.js'></script>
    <script type="text/javascript" src="num2word.js"></script>
    


</head>

<body>
<cfparam name="url.cfgridkey" default="">

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
select logo, terms, footer, vat, tin, vendor, pr, company, address2
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

            <div id="logo" align="left">
              <!---<img id="image" src="../image/LG-Electronics.jpg" alt="logo" width="" />--->
              <img id="image" src="../Invoices/images/#option.logo#" alt="logo" height="60px" />
              <div id="addressline">      
              <div id="address1">
            <Span id="address">#ucase(option.company)#</Span><br />
            <span> #request.CompanyAddress#<br />
Phone: #request.CompanyPhone#, #request.CompanyPhone2#</Span>
            <br />
Email: #request.CompanyEmail#</Span>
            </div>
            <div id="address2">
            <Span id="address">#ucase(option.address2)#</Span><br />
            <span> #request.CompanyAddress2#<br />
Phone: #request.CompanyPhone3#</Span>
            
            </div></div>
            </div>
            <div id="bizDetails">
              <table border="0" width="100%">
              <tr class="bizDetailstable">
              <td id="bizDetails2">VAT CODE</td><td id="bizDetails2">TIN CODE</td><td id="bizDetails2">VENDOR CODE</td><td id="bizDetails2">WO/PR</td>
              </tr>
              <tr class="bizDetailstable">
              <td id="bizDetails1"><input type="text" value=" #option.vat#" /></td><td id="bizDetails1"><input type="text" value=" #option.tin#" /></td><td id="bizDetails1"><input type="text" value=" #option.vendor#" /></td><td id="bizDetails1"><input type="text" value=" #option.pr#" /></td>
              </tr>
              </table>
            </div>
		
		</div>
		
		<div style="clear:both"></div>
		
		<div id="customer">

            <textarea rows="4" id="customer-title">Billed To: &##13;&##10; #customer# &##13;&##10; #company# &##13;&##10; #address#
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
		      <th>S/N</th>
		      <th>Description</th>
		      <th>Quantity</th>
		      <th>Unit-Cost<br />(&##x20a6)</th>
              <th>Discount<br />(&##x20a6)</th>
		      <th>Price<br />(&##x20a6)</th>
		  </tr>
		  <cfloop query="SalesDetails">
		  <tr class="item-row">
		      <td class="item-sn" align="center">#currentRow#</td>
		      <td class="description">#Description#</td>
		      <td align="center">#LSNumberFormat(Qty,',999.00')#</td>
		      <td align="right"> #LSNumberFormat(UnitPrice,',9999999999.99')#</td>
              <td align="right"> #LSNumberFormat(discount,',999')#</td>
		      <td align="right"><span class="price"> #LSNumberFormat(Amt,',9999999999.99')#</span></td>
		  </tr>
		  </cfloop>
		  
		  <tr>

		      <td colspan="3" class="blank"> </td>
		      <td colspan="2" class="total-line">Total</td>
		      <td class="total-value"><div id="total">&##x20a6 #LSNumberFormat(Amounts.TotalAmount,',9999999999.99')#</div></td>
		  </tr>
          <tr>

		      <td colspan="3" class="blank"> </td>
		      <td colspan="2" class="total-line">VAT Rate</td>
		      <td class="total-value"><div id="total">5%</div></td>
		  </tr>
          <tr>

		      <td colspan="3" class="blank"> </td>
		      <td colspan="2" class="total-line">VAT</td>
		      <td class="total-value"><div id="total"> <input align="right"type="text" value="" /></div></td>
		  </tr>
		  <tr>
		      <td colspan="3" class="blank"> </td>
		      <td colspan="2" class="total-line">Amount Paid</td>

		      <td class="total-value">&##x20a6 #LSNumberFormat(Amounts.AmountPaid,',9999999999.99')#</td>
		  </tr>
		  <tr>
		      <td colspan="3" class="blank"> </td>
		      <td colspan="2" class="total-line balance">Balance Due</td>
		      <td class="total-value balance"><div class="due">&##x20a6 #LSNumberFormat(Balance,',9999999999.99')#</div></td>
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
		  <textarea>Customer's Signature:____________________                                                              					For: #request.Company#</textarea>
		</div>
        <div align="center"  id="footer">
		  <span>#option.footer#</span>
		</div>
	
	</div>
</cfoutput>	
</body>

</html>