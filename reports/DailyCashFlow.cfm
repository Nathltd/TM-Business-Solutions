<!doctype html>
<html>
<head>
<link href="../css/styles2.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../googleJquery-ui.min.js"></script>

</head>

<body class=" ui-widget">
<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<cfparam name="form.Search" default="">

<cfoutput>
<h4>Daily Financial Report<cfif isdefined(#form.search#)> For #Dateformat(form.searchDate,"dd/mm/yyyy")#</cfif></h4>
</cfoutput>
<div id="RightColumn">

<cfif isdefined (#form.Search#)>

<cfset datte = '#form.searchDate#'>
<cfset branchid = '#form.BranchId#'>
<cfquery name="searchDetails">
SELECT accountid, type, SUM(Amount) AS Amt
FROM vwAccountFiscalTranstUnion
WHERE accountid = '#branchid#' AND PaymentDate = #CreateODBCDate(datte)#
group by accountid,type
</cfquery>

<cfquery name="SalesDay">
SELECT SalesDate, BranchID, SUM(TotalAmount) AS Amt
FROM vwSalesAmtPerDaySumry
WHERE BranchID = '#branchid#' AND SalesDate = #CreateODBCDate(datte)#
group by  SalesDate, BranchID
 </cfquery>
 
<cfquery name="InvoicePd" dbtype="query">
Select amt from searchDetails
where Type = 'InvoicePd'
</cfquery>
<cfquery name="TransferOut" dbtype="query">
Select amt from searchDetails
where Type = 'Transfer Out'
</cfquery>
<cfquery name="payments" dbtype="query">
Select amt from searchDetails
where Type = 'Cash' or Type = 'Cheque'
</cfquery>

<cfquery name="Expense" dbtype="query">
Select amt from searchDetails
where Type = 'Expense'
</cfquery>
<cfquery name="InvoicePd" dbtype="query">
Select amt from searchDetails
where Type = 'InvoicePd'
</cfquery>
<cfquery name="TransferOut" dbtype="query">
Select amt from searchDetails
where Type = 'Transfer Out'
</cfquery>
 

<cfif #searchDetails.recordcount# eq 0><br />
<br />

<h2> No Record Found! </h2>

<cfelse>

<cfoutput>



<br>
<table border="0" cellpadding="0" cellspacing="5">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">

<td>Total Sales Value:</td><td align="right">#numberformat(SalesDay.Amt,",0.00")#</td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<cfset creditSales = #SalesDay.Amt# - #InvoicePd.Amt#>
<td>Credit Sales Value:</td><td align="right">#numberformat(creditSales,",0.00")#</td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>Amount Paid(Cash):</td><td align="right">#numberformat(InvoicePd.Amt,",0.00")#</td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>Payments from Previous:</td><td align="right">#numberformat(payments.Amt,",0.00")#</td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>Expenses:</td><td align="right">#numberformat(Expense.Amt,",0.00")#</td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<cfset cashHand = #InvoicePd.Amt# + #payments.Amt# - #Expense.Amt#>
<td>Cash At Hand:</td><td align="right">#numberformat(cashHand,",0.00")#</td>
</tr>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>Payment to Bank:</td><td align="right">#numberformat(TransferOut.Amt,",0.00")#</td>
</tr>
</table>
</cfoutput>
</cfif>

<cfelse>
<cfoutput>
<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="177">
<tr>
<td><div align="left">Date:</div></td>
<td>

    <div align="left"><cfinput name="searchDate" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" required="yes" message="Enter Date" type="datefield">
    </div>

  </td>
  </tr>
  <tr>
  <td width="40" align="right" >

    <div align="left">Branch:</div>

  </td>
  <td width="125" align="left">
    <div align="left">
      <cfselect name="branchId" >
      <cfquery name="branch">
      select branchId from Branches
      order by branchid
      </cfquery>
      <cfloop query="branch">
      <option value="#branchId#">#branchId#</option>
      </cfloop>
      </cfselect>
      
      </div>
  </td>
  </tr>
<tr>
  <td colspan="2">
    <div align="right">
      <cfinput name="Search" value="Search" type="submit">
      </div></td>
</tr>
</table>
</cfform>
</cfoutput>
</cfif>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>

</div>
</div>
</div>
</body>
</html>