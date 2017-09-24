<!doctype html>
<html>
<head>
<title><cfoutput>Order List  :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">

<h4>Customer List</h4>

<div id="RightColumn">
<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha' AND #GetUserRoles()# is not 'Manager' AND #GetUserRoles()# does not contain 'Sales'>
<h1> Unauthrised Zone </h1>
<cfabort>
</cfif>
    <cfquery name="orders">
SELECT *
FROM sales
where type = 'order'
ORDER BY salesDate ASC 
  </cfquery>
  <cfif #orders.recordCount# eq 0>
  <h2> No Sales Order Availale </h2>
  <cfabort>
  </cfif>

  <table width="90%" cellpadding="0" cellspacing="5">
  <tr>
  <td width="138"></td>
  <td width="132"><div align="left"></div></td>
  <td width="192" colspan="2"><div align="right"><cfoutput>Total Sales Order =<strong> #orders.recordCount#</strong></cfoutput>&nbsp;</div></td>
  <td width="94"><div align="right"></div></td>
  </tr>
  <tr>
  <td width="10%"><strong>Seria</strong></td>
  <td width="7%"><div align="left"><strong>Order No.</strong></div></td>
  <td width="20%"><div align="left"><strong>Customer</strong></div></td>
  <td width="12%"><div align="left"><strong>Branch</strong></div></td>
  <td width="10%"><div align="left"><strong>Order Value</strong></div></td>
  <td width="10%"><div align="left"><strong>Amount Paid</strong></div></td>
  <td width="10%"><div align="left"><strong>Authorised</strong></div></td>
    <td width="10%"><div align="left"><strong>Action</strong></div></td>
  </tr>
  
<cfoutput query="orders">

<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#dateformat(salesDate,"dd/mm/yyyy")#</td><td><div align="left">#salesId#</div></td><td><div align="left">#customerId#</div></td><td><div align="left">#branchId#</div></td><td><div align="right">#numberformat(amountPaid,",000.00")#</div></td><td><div align="right">#numberformat(amountPaid,",000.00")#</div></td><td><div align="left">#staffId#</div></td><td><div align="left"><a href="../invoices/invoice.cfm?CFGRIDKEY=#salesid#&InvoiceType=SALES">Create invoice</a></div></td>
  </tr>
</cfoutput>
</table>
<cfset #session.salesType# = 'Order'>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>

</body>
</html>