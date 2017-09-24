<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
	
	<title><cfoutput>Customer's Transaction :: #request.title#</cfoutput></title>
    <link rel="shortcut icon" href="../shared/TMicon.ico"/>
    <link rel="stylesheet" type="text/css" href="../invoices/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="../invoices/css/print.css" media="print"/>
    <script type="text/javascript" src="../invoices/js/jquery-1.3.2.min.js"></script>
    <script type="text/javascript" src="../invoices/js/example.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/results.css">
</head>

<body>
<cfoutput>
<cfquery name="option">
select logo, terms, footer, vat, tin, vendor, pr, company
from invoiceOptions
</cfquery>
<cfquery name="company">
	select logo
	from company
</cfquery>

<cfparam name="url.InvoiceType" default="">
    <cfparam name="url.type" default="">         
            		
		<div id="identity" align="center">
		<h2>Transaction Details for <cfoutput> #session.urlId# </cfoutput> </h2>
            <div id="addressline" align="left">      
              <div id="address1">
            <Span id="address">#ucase(option.company)#</Span><br />
            <span> #request.CompanyAddress#<br />
Phone: #request.CompanyPhone#, #request.CompanyPhone2#</Span>
            <br />
Date: #dateformat(now(),"dd/mm/yyyy")#</Span>
            </div>
            <div id="logo2" align="right">
            <img id="image" src="../invoices/images/#company.logo#" alt="#company.logo#" height="80px" />
            </div>
            </div>
		
		</div>
</cfoutput>
<cfquery name="CustomerDetails">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwCustomerFiscalTranstUnion
Where CustomerID = '#session.urlId#'
AND paymentdate between #CreateODBCDate(session.StartDate)# AND #CreateODBCDate(session.EndDate)#
ORDER BY PaymentDate asc,  PaymentID asc, Type desc
</cfquery>

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
Where CustomerID = '#session.urlId#'
GROUP BY Type
</cfquery>

<cfquery name="TotalAmt">
SELECT Type, SUM(Amount) AS Qty1 FROM vwCustomerFiscalTranstUnion
WHERE CustomerID = '#session.urlId#' AND paymentdate < #CreateODBCDate(session.StartDate)#
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalAmt
WHERE Type = 'InvoicePd' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="QtyIn">
SELECT  SUM(Qty1) AS Qty
FROM TotalAmt
WHERE Type = 'O/Balance' or Type = 'Cheque' or Type = 'Cash' or Type = 'EFT' or Type = 'Rebate' or Type = 'Reimburse' or  Type = 'Retained'
</cfquery>


<cfif QtyIN.recordCount eq 0 AND QtyOUT.recordCount gt 0>
<cfset QtyIN = 0>
<cfset #QtyOUT# = #Valuelist(QtyOUT.Qty)#>
<cfelseif QtyOUT.recordCount eq 0  AND QtyIN.recordCount gt 0>
<cfset QtyOUT = 0>
<cfset #QtyIN# = #Valuelist(QtyIN.Qty)#>
<cfelseif QtyIN.recordCount eq 0 AND QtyOUT.recordCount eq 0>
<cfset QtyIN = 0>
<cfset QtyOUT = 0>
<cfelse>
<cfset #QtyIN# = #Valuelist(QtyIN.Qty)#>
<cfset #QtyOUT# = #Valuelist(QtyOUT.Qty)#>
</cfif>

<cfset PreviousBal = +#QtyIN#-(#QtyOUT#)>

<cfparam name="qty2" default="0">


<div align="center">

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="96"><strong>Date</strong></td>
  <td width="89"><strong>Ref No.</strong></td>
  <cfif #session.urlId# eq 'General'>
  <td width="183"><strong>Name</strong></td>
  </cfif>
  <td width="46"><strong>Type</strong></td>
  <td width="107"><strong>Account</strong></td>
  <td width="92"><div align="right"><strong>Debit</strong></div></td><td width="89"><div align="right"><strong>Credit</strong></div></td>
  <td width="106"><div align="right"><strong>Balance</strong></div></td>
  </tr>
  <tr>
  <td width="96"></td>
  <td width="89"></td>
  <td width="46"></td>
  <td width="107"></td>
  <td width="92"><div align="right"></div></td><td width="89"><div align="right"><strong>Previous Balance</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="106"><div align="right"><strong><cfoutput>#numberformat(PreviousBal,",000.00")#</cfoutput></strong></div></td>
  </tr>

<cfoutput query="CustomerDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="96" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="89" align="left">#PaymentID#</td>
  <cfif #session.urlId# eq 'General'>
  <cfquery name="CustomerName">
select customerId from customersGen
where salesId = #PaymentID#
</cfquery>
  <td width="183">#CustomerName.customerId#</td>
  </cfif>
  <td width="46" align="left">#Type#</td>
  <td width="107" align="left">#AccountID#</td>
  
  <td><div align="right"><cfif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelseif #Type# is "InvoicePd">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td>

 
  <td><div align="right"><cfif #Type# is "O/Balance">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Cheque">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Cash">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Rebate">#numberformat(Qty,",000.00")#<cfelseif #Type# is "EFT">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Reimburse">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Retained">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td>

<cfset Qty2 = #val(Qty2)#>



<cfif #CustomerDetails.Type# is "Refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #CustomerDetails.Type# is "InvoicePd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = #Qty2#>



<div align="right">#numberformat(newBalance,",000.00")#</div></td>
  </tr>

</cfoutput>
<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty) AS Qty1
FROM CustomerDetails
WHERE Type = 'Invoicepd' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="QtyIn">
SELECT  SUM(Qty) AS Qty1
FROM CustomerDetails
WHERE Type = 'O/Balance' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'EFT'  or Type = 'Rebate' or Type = 'Retained' or Type = 'Reimburse'
</cfquery>

<cfoutput>
  <tr>
  <td colspan="3"></td><td align="left"><div align="right"><strong>Total</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyOUT.Qty1,",000.00")#</strong></div></td>
  <td><div align="right"><strong>#numberformat(QtyIN.Qty1,",000.00")#</strong></div></td>
  <td><div align="right"></div></td>
  </tr>
</cfoutput>  
</table>
</div>
<div align="center"  id="footer">
		  <span><cfoutput>#request.footer#</cfoutput></span>
		</div>
	
</div>
</div>
</div>
</body>
</html>