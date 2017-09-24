<!doctype html>
<html>
<head>
<title><cfoutput>Cash Flow :: #request.title#</cfoutput></title>
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

<h4><cfif isdefined ("form.AccountID")><cfoutput>#form.AccountID# Cash Flow (#form.StartDate# - #form.EndDate#)</cfoutput><cfelse>Cash Flow Search</cfif></h4>

<div id="RightColumn">
<div align="right"> <a href="?">Reset</a>&nbsp;&nbsp;<a href="?print=1">Print</a>&nbsp;&nbsp;<a href="?export=1">Export</a>&nbsp;&nbsp;</div>

<cfparam name="url.print" default="">  
<cfparam name="url.export" default="">
<cfparam name="session.StartDate" default="">
<cfparam name="session.EndDate" default="">
<cfparam name="session.AccountID" default="">


<cfif url.print is "yes">
<cfquery name="AccountDetails">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwAccountFiscalTranstUnion
WHERE PaymentDate >= #CreateODBCDate(session.StartDate)# AND PaymentDate <= #CreateODBCDate(session.EndDate)# AND AccountID = '#session.AccountID#'
ORDER BY PaymentDate, Type, PaymentID ASC
</cfquery>

<cfquery dbtype="query" name="newOut">
SELECT  SUM(Qty) AS Amt
FROM AccountDetails
WHERE Type = 'Transfer Out' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense' or Type = 'Reimburse' or Type = 'Rebate' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="newIn">
SELECT  SUM(Qty) AS Amt
FROM AccountDetails
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'O/Balance'  or Type = 'Sup Refund' or Type = 'EFT'
</cfquery>

<cfset newOut = #newOut.Amt#>
<cfset newIn = #newIn.Amt#>

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwAccountFiscalTranstUnion
WHERE PaymentDate < #CreateODBCDate(session.StartDate)# AND AccountID = '#session.AccountID#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer Out' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense' or Type = 'Reimburse' or Type = 'Rebate' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'O/Balance' or Type = 'Sup Refund' or Type = 'EFT'
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

<cfparam name="qty2" default="#PreviousBal#">
<cfdocument format="flashpaper" unit="in" margintop=".3" marginbottom=".3" marginRight=".3" marginLeft=".3">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<style>
#row{
	font-size:11px;
}
</style>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="577">
  <tr>
    <td colspan="2" valign="top"><font size="-1" face="Segoe UI">Account Activities Report</font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Account:</font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.AccountID#</font></strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2">Date:</font></div></td><td width="127" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2">#session.startDate# - #session.endDate#</font></strong></div></td>
</tr>
</table>
</cfoutput>


<table width="703" cellpadding="0" cellspacing="5">
  <tr>
  <td colspan="7"><div align="right" id="row"><cfoutput> #AccountDetails.RecordCount# Record(s) Available.</cfoutput></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  </tr>
  <tr id="row">
  <td width="79"><strong>Date</strong></td>
  <td width="83"><strong>Ref No.</strong></td><td width="62"><strong>Type</strong></td>
  <td width="107"><strong>Account</strong></td>
  <td width="102"><div align="right"><strong>Debit</strong></div></td><td width="92"><div align="right"><strong>Credit</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="98"><div align="right"><strong>Balance</strong></div></td>
  </tr>
  <tr id="row" bgcolor="#C0C0C0">
  <td>&nbsp;</td>
  <td></td>
  <td></td>
  <td></td><td>&nbsp;</td>
  <td><div align="right"><strong>B/F.</strong></div></td>
  <td><div align="right">
    <cfoutput>#numberformat(Qty2,",000.00")#</cfoutput>
  </div></td>
</tr>
<cfoutput query="AccountDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr id="row" bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="83" align="left">#PaymentID#</td><td width="91" align="left">#Type#</td>
<cfset customer = '#AccountDetails.CustomerID#'>
  <cfif #Type# is 'Invoicepd'>
  <cfquery name="general">
select customerId, SalesId from customersGen
where salesId = #PaymentID#
</cfquery>
  <cfif #general.RecordCount# eq 1 AND #AccountDetails.Type# is 'Invoicepd'>
  <cfset customer = #general.CustomerID#>
  </cfif>  
  </cfif>
  <td width="107" align="left">#Customer#</td>
  <td><div align="right"><cfif #Type# is "Transfer Out">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Expense">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Pd Supply">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Rebate">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Purchase Pd">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td><td><div align="right"><cfif #Type# is "Transfer Out">0<cfelseif #Type# is "Sup Refund">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Expense">0<cfelseif #Type# is "Pd Supply">0<cfelseif #Type# is "Rebate">0<cfelseif #Type# is "Purchase Pd">0<cfelse>#numberformat(Qty,",000.00")#</cfif></div></td>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>

<cfif #AccountDetails.Type# is "Transfer Out">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Purchase Pd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Pd Supply">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Rebate">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Expense">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div>
</td>
  </tr>
</cfoutput>
<cfoutput>
<tr id="row" bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left"></td><td width="83" align="left"></td><td colspan="2" align="right"><strong>Total Debit/Credit/Difference</strong></td>
  <td><div align="right"><strong>#numberformat(NewOut,",000.00")#</strong></div></td><td><div align="right"><strong>#numberformat(NewIn,",000.00")#</strong></div></td>
<td>
<cfif not isNumeric(#newOut#)>
<cfset #newOut# = 0>
</cfif>
<cfif not isNumeric(#newIn#)>
<cfset #newIn# = 0>
</cfif>
 
<cfset dif = #newIn# - #newOut#>

<div align="right"><strong>#numberformat(dif,",000.00")#</strong></div>
</td>
  </tr>
  </cfoutput>
</table>
</div>
<cfoutput>
<cfdocumentitem type="footer">
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>

<cfelseif url.export is "yes">
<cfquery name="AccountDetails">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwAccountFiscalTranstUnion
WHERE PaymentDate >= #CreateODBCDate(session.StartDate)# AND PaymentDate <= #CreateODBCDate(session.EndDate)# AND AccountID = '#session.AccountID#'
ORDER BY PaymentDate, Type, PaymentID ASC
</cfquery>

<cfquery dbtype="query" name="newOut">
SELECT  SUM(Qty) AS Amt
FROM AccountDetails
WHERE Type = 'Transfer Out' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense' or Type = 'Reimburse' or Type = 'Rebate' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="newIn">
SELECT  SUM(Qty) AS Amt
FROM AccountDetails
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'O/Balance' or Type = 'Sup Refund'
</cfquery>

<cfset newOut = #newOut.Amt#>
<cfset newIn = #newIn.Amt#>

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwAccountFiscalTranstUnion
WHERE PaymentDate >= #createODBCDate(session.StartDate)# AND PaymentDate < #CreateODBCDate(session.StartDate)# AND AccountID = '#session.AccountID#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer Out' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense' or Type = 'Reimburse' or Type = 'Rebate' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'O/Balance' or Type = 'Sup Refund'
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

<cfparam name="qty2" default="#PreviousBal#">

<cfheader name="Content-Disposition" value="inline; filename=TM_Report.xls">
<cfcontent type="application/vnd.ms-excel">
 <cfoutput>
<table width="577">
  <tr>
    <td colspan="2" valign="top">Account Activities Report</td>
    <td></td>
    <td valign="baseline"><div align="left">Account:</div></td>
    <td valign="baseline"><div align="left"><strong>#session.AccountID#</strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td width="141" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
    <td width="212"></td><td width="41" valign="baseline"><div align="left">Date:</div></td><td width="127" valign="baseline"><div align="left"><strong>#session.startDate# - #session.endDate#</strong></div></td>
</tr>
</table>
</cfoutput>
<table width="703" cellpadding="0" cellspacing="5">
  <tr>
  <td colspan="7"><div align="right"><cfoutput>#AccountDetails.RecordCount#</cfoutput> Record(s) Available.</div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  </tr>
  <tr>
  <td width="79"><strong>Date</strong></td>
  <td width="73"><strong>Ref No.</strong></td><td width="85"><strong>Type</strong></td>
  <td width="112"><strong>Account</strong></td>
  <td width="102"><div align="right"><strong>Debit</strong></div></td><td width="108"><div align="right"><strong>Credit</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="102"><div align="right"><strong>Balance</strong></div></td>
  </tr>
  <tr bgcolor="#C0C0C0">
  <td>&nbsp;</td>
  <td></td>
  <td></td>
  <td></td><td>&nbsp;</td>
  <td><div align="right"><strong>B/F.</strong></div></td>
  <td><div align="right">
  <cfoutput>  #numberformat(Qty2,",000.00")# </cfoutput>
  </div></td>
</tr>
<cfoutput query="AccountDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="83" align="left">#PaymentID#</td><td width="91" align="left">#Type#</td>
<cfset customer = '#AccountDetails.CustomerID#'>
  <cfif #Type# is 'Invoicepd'>
  <cfquery name="general">
select customerId, SalesId from customersGen
where salesId = #PaymentID#
</cfquery>
  <cfif #general.RecordCount# eq 1 AND #AccountDetails.Type# is 'Invoicepd'>
  <cfset customer = #general.CustomerID#>
  </cfif>  
  </cfif>
  <td width="107" align="left">#Customer#</td>
  <td><div align="right"><cfif #Type# is "Transfer Out">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Expense">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Pd Supply">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Rebate">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Purchase Pd">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td><td><div align="right"><cfif #Type# is "Transfer Out">0<cfelseif #Type# is "Refund">0<cfelseif #Type# is "Expense">0<cfelseif #Type# is "Pd Supply">0<cfelseif #Type# is "Rebate">0<cfelseif #Type# is "Purchase Pd">0<cfelse>#numberformat(Qty,",000.00")#</cfif></div></td>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>

<cfif #AccountDetails.Type# is "Transfer Out">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Purchase Pd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Pd Supply">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Rebate">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Expense">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div>
</td>
  </tr>
</cfoutput>
<cfoutput>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left"></td><td width="83" align="left"></td><td colspan="2" align="right"><strong>Total Debit/Credit/Difference</strong></td>
  <td><div align="right"><strong>#numberformat(NewOut,",000.00")#</strong></div></td><td><div align="right"><strong>#numberformat(NewIn,",000.00")#</strong></div></td>
<td>
<cfset dif = #newIn# - #newOut#>

<div align="right"><strong>#numberformat(dif,",000.00")#</strong></div>
</td>
  </tr>
  </cfoutput>
</table>
</cfcontent>

<cfelse>


<cfform action="#cgi.SCRIPT_NAME#">
<table width="60%" cellpadding="2">
<tr align="left">
  <td width="30%" ><div align="left">Starting:</div></td>
  <td width="30%"><div align="left">Ending:</div></td>
  <td width="30%"><div align="left">Account:</div></td>
  <td width="10%"><div align="left"></div></td>
</tr>
<tr>
  <td><div align="left">
    <cfinput name="StartDate" type="datefield" placeholder="#dateformat(request.StartYear,"dd/mm/yyyy")#" required="yes" message="Enter Starting date" mask="dd/mm/yyyy" style="width:100%">
  </div>
    <label>
  </label>
  </td>
  <td>
    <div align="left">
      <cfinput name="endDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" mask="dd/mm/yyyy" message="Enter Ending Date" style="width:100%">
      </div></td>
  <td>
    <div align="left">
      <cfselect name="AccountID" message="Choose Product"  required="yes" id="AccountID" bind="cfc:#request.cfc#cfc.bind.getAllBankAccounts()" display="AccountID" value="AccountID" bindonload="yes" style="width:100%">
        </cfselect>
    </div></td>
  <td><div align="left"><cfinput name="Search" value="Search" type="submit">
  </div></td>
</tr>
<tr>
  <td colspan="3">
    <div align="center"></div></td>
</tr>
</table>
</cfform>

<cfif isdefined ("form.Search")>

<cfset StartDate = #form.StartDate#>
<cfset StartDate = #Dateformat(StartDate,"dd/mm/yyyy")#>
<cfset EndDate = #form.EndDate#>
<cfset EndDate = #Dateformat(EndDate,"dd/mm/yyyy")#>
<cfset yyear = '#request.StartYear#'>
<cfset yyear = #Dateformat(CreateODBCDate(request.StartYear))#>

<cfset session.StartDate = "#StartDate#">
<cfset session.EndDate = "#EndDate#">
<cfset session.AccountID = "#AccountID#">


<cfquery name="AccountDetails">
Select CustomerID, Type, Amount AS Qty, PaymentID, PaymentDate, AccountID from vwAccountFiscalTranstUnion
WHERE PaymentDate >= #CreateODBCDate(StartDate)# AND PaymentDate <= #CreateODBCDate(EndDate)# AND AccountID = '#form.AccountID#'
ORDER BY PaymentDate, Type, PaymentID ASC

</cfquery>

<cfif #AccountDetails.recordCount# eq 0>
<h2> No Record Found! </h2>
<cfelse>

<cfquery dbtype="query" name="newOut">
SELECT  SUM(Qty) AS Amt
FROM AccountDetails
WHERE Type = 'Transfer Out' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense' or Type = 'Reimburse' or Type = 'Rebate' or Type = 'Refund'
</cfquery>

<cfquery dbtype="query" name="newIn">
SELECT  SUM(Qty) AS Amt
FROM AccountDetails
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'O/Balance' or Type = 'Sup Refund'
</cfquery>

<cfset newOut = #newOut.Amt#>
<cfset newIn = #newIn.Amt#>

<cfquery name="TotalQty">
SELECT Type, SUM(Amount) AS Qty1 FROM vwAccountFiscalTranstUnion
WHERE PaymentDate < #CreateODBCDate(StartDate)# AND AccountID = '#form.AccountID#'
GROUP BY Type
</cfquery>

<cfquery dbtype="query" name="QtyOut">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer Out' or Type = 'Purchase Pd' or Type = 'Pd Supply' or Type = 'Expense' or Type = 'Refund' or Type = 'Reimburse' or Type = 'Rebate'
</cfquery>

<cfquery dbtype="query" name="QtyIN">
SELECT  SUM(Qty1) AS Qty
FROM TotalQty
WHERE Type = 'Transfer In' or Type = 'InvoicePd' or Type = 'Cheque' or Type = 'Cash' or Type = 'O/Balance' or Type = 'Sup Refund'
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

<cfparam name="qty2" default="#PreviousBal#">


  <table width="90%" cellpadding="2">
  <tr>
  <td colspan="7"><div align="right"><cfoutput> #AccountDetails.RecordCount# Record(s) Available.</cfoutput></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  </tr>
  <tr>
  <td width="10%"><strong>Date</strong></td>
  <td width="12%"><strong>Ref No.</strong></td><td width="10%"><strong>Type</strong></td>
  <td width="22%"><strong>Account</strong></td>
  <td width="12%"><div align="right"><strong>Debit</strong></div></td><td width="12%"><div align="right"><strong>Credit</strong></div></td>
  <!--<td width="33" hidden="yes">Calc</td>-->
  <td width="12%"><div align="right"><strong>Balance</strong></div></td>
  </tr>
  <tr bgcolor="#C0C0C0">
  <td>&nbsp;</td>
  <td></td>
  <td></td>
  <td></td><td>&nbsp;</td>
  <td><div align="right"><strong>B/F.</strong></div></td>
  <td><div align="right">
    <cfoutput>#numberformat(Qty2,",000.00")#</cfoutput>
  </div></td>
</tr>

<cfoutput query="AccountDetails">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left">#Dateformat(PaymentDate,"dd/mm/yyyy")#</td><td width="83" align="left">#PaymentID#</td><td width="91" align="left">#Type#</td>
<cfset customer = '#AccountDetails.CustomerID#'>
  <cfif #Type# is 'Invoicepd'>
  <cfquery name="general">
select customerId, SalesId from customersGen
where salesId = #PaymentID#
</cfquery>
  <cfif #general.RecordCount# eq 1 AND #AccountDetails.Type# is 'Invoicepd'>
  <cfset customer = #general.CustomerID#>
  </cfif>  
  </cfif>
  <td width="107" align="left">#Customer#</td>
  <td><div align="right"><cfif #Type# is "Transfer Out">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Expense">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Refund">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Pd Supply">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Rebate">#numberformat(Qty,",000.00")#<cfelseif #Type# is "Purchase Pd">#numberformat(Qty,",000.00")#<cfelse>0</cfif></div></td><td><div align="right"><cfif #Type# is "Transfer Out">0<cfelseif #Type# is "Refund">0<cfelseif #Type# is "Expense">0<cfelseif #Type# is "Pd Supply">0<cfelseif #Type# is "Rebate">0<cfelseif #Type# is "Purchase Pd">0<cfelse>#numberformat(Qty,",000.00")#</cfif></div></td>
<!--  <td hidden="yes"><div align="right">
#Qty2#

</div>
</td>-->
<cfset Qty2 = #val(Qty2)#>

<cfif #AccountDetails.Type# is "Transfer Out">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Refund">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Purchase Pd">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Pd Supply">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Rebate">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelseif #AccountDetails.Type# is "Expense">
<cfset qty2 = -(#qty#)+#val(qty2)#>
<cfelse>
<cfset qty2 = (#qty#)+#val(qty2)#>
</cfif>

<td>

<cfset newBalance = +#Qty#+#Qty2#-#Qty#>



<div align="right">#numberformat(newBalance,",000.00")#</div>
</td>
  </tr>
</cfoutput>
<cfoutput>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
  <td width="79" align="left"></td><td width="83" align="left"></td><td colspan="2" align="right"><strong>Total Debit/Credit/Difference</strong></td>
  <td><div align="right"><strong>#numberformat(NewOut,",000.00")#</strong></div></td><td><div align="right"><strong>#numberformat(NewIn,",000.00")#</strong></div></td>
<td>

<cfif not isNumeric(#newOut#)>
<cfset #newOut# = 0>
</cfif>
<cfif not isNumeric(#newIn#)>
<cfset #newIn# = 0>
</cfif>
 

<cfset dif = #NewIn# - #NewOut#>

<div align="right"><strong>#numberformat(dif,",000.00")#</strong></div>
</td>
  </tr>
  </cfoutput>
</table>
</cfif>
</cfif>
</cfif>

</div>
</div>
</div>
</body>
</html>
