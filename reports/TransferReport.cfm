<!doctype html>
<html>
<head>
<title><cfoutput>Transfer Report :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<cfparam name="form.search" default="">

<h4>Inventory Transfers <cfif not isdefined(form.search)>(Last 200)</cfif></h4>

<div id="RightColumn">
<br />
  <cfform>
<table width="56%" cellpadding="1">
<tr>
<td width="14%" valign="top">Start Date:</td><td width="31%"> <cfinput type="datefield" name="startDate" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"mm/dd/yyyy")#" style="width:100%"></td>
<td width="14%" valign="top">End Date:</td><td width="29%"> <cfinput type="datefield" name="endDate" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"mm/dd/yyyy")#" style="width:100%"></td>
<td width="12%" valign="top"><cfinput type="submit" value="Search" name="Search"></td>
</tr>
</table>
</cfform>
<cfif isdefined(form.Search)>
<cfset startDate = #CreateODBCDate(dateformat(form.startDate,"dd/mm/yyyy"))#>
<cfset endDate = #CreateODBCDate(dateformat(form.endDate,"dd/mm/yyyy"))#>
<cfset datedif = #datediff("d",startDate,enddate)#>

<cfif #datedif# lt 1>
<h3>Range Less than 1 day. Please Adjust.</h3>
<cfabort>
</cfif>
<cfif #datedif# gt 31>
<h3>Range greater than 31 days. Please Adjust.</h3>
<cfabort>
</cfif>

<cfquery name="invoiceAll">
SELECT distinct TransferID, TransferDate, Source,  Destination, StaffId, Amount
FROM vwTransferUpdate
WHERE TransferDate between #startdate# and #endDate#
ORDER BY TransferDate ASC 
  </cfquery>
  <cfif #invoiceAll.RecordCount# eq 0>
<h3>No Transfer Record For This Period.</h3>
<cfabort>
</cfif>

  <table width="85%" border="0" cellpadding="3" cellspacing="0">
<tr>
  <td width="13%"><strong>Date</strong></td><td width="10%" title="Transfer Number"><strong>T/No.</strong></td><td width="21%" ><div align="left"><strong>Source</strong></div></td><td width="15%"><div ><strong>Destination</strong></div></td><td width="18%" align="right"><div ><strong>Value</strong></div></td><td width="13%"><div align="right"><strong>Authorised</strong></div></td>
</tr>
<cfoutput query="invoiceAll">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(TransferDate,"dd/mm/yyyy")#</td><td><a href="../reports/transferPrnt.cfm?CFGRIDKEY=#TransferID#">#TransferID#</a></td><td><div align="left">#Source#</div></td><td><div>#Destination#</div></td><td align="right"><div>#NumberFormat(Amount,',999.99')#</div></td><td><div align="right">#StaffId#</div></td>
</tr>
</cfoutput>

</table>
  
<cfelse>

<cfquery name="invoices" maxrows="100">
SELECT distinct TransferID, TransferDate, Source,  Destination, staffId, Amount
FROM vwTransferUpdate
ORDER BY TransferDate ASC
  </cfquery>
<div align="center">
<table width="85%" border="0" cellpadding="3" cellspacing="0">
<tr>
  <td width="13%"><strong>Date</strong></td><td width="10%" title="Transfer Number"><strong>T/No.</strong></td><td width="21%" ><div align="left"><strong>Source</strong></div></td><td width="15%"><div ><strong>Destination</strong></div></td><td width="18%" align="right"><div ><strong>Value</strong></div></td><td width="13%"><div align="right"><strong>Authorised</strong></div></td>
</tr>
<cfoutput query="invoices">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#Dateformat(TransferDate,"dd/mm/yyyy")#</td><td><a href="../reports/transferPrnt.cfm?CFGRIDKEY=#TransferID#">#TransferID#</a></td><td><div align="left">#Source#</div></td><td><div>#Destination#</div></td><td align="right"><div>#NumberFormat(Amount,',999.99')#</div></td><td><div align="right">#StaffId#</div></td>
</tr>
</cfoutput>

</table>
</div>
</cfif>
</div> 
</div>
</body>
</html>