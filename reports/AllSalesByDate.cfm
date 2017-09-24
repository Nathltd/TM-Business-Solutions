
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>

</head>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Sales Report By Date</h4>
<div id="RightColumn">

<cfif IsDefined("form.submit") is True>
<div align="right"><a href="AllSalesByDate.cfm">reset&nbsp;</a> | <a href="##">print&nbsp;</a></div>

<cfquery name="InventoryByDate" datasource="#request.dsn#">
SELECT SalesDate, BranchID, ProductID, TotalSales
FROM vwSalesWithDate
WHERE SalesDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_clob"> AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_clob">
ORDER BY SalesDate ASC
 </cfquery>

<cfif #InventoryByDate.recordcount# eq 0><br />
<br />

No Record between <cfoutput><strong> #form.startDate# and #form.endDate#</strong> </cfoutput><br /><br />

<cfelse>
<cfoutput>#InventoryByDate.recordcount# Record(s) found between <strong> #form.startDate# and #form.endDate#</strong> </cfoutput>
<br />
<br />


<table width="355" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="58"><strong>Date</strong></td>
<td width="94"><strong>Branch</strong></td>
<td width="104"><strong>Item Name</strong></td>
<td width="59"><div align="right"><strong>Qty Sold</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="InventoryByDate">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onmouseover="this.bgColor='FFCCCC';" onmouseout="this.bgColor='#rowColor#';">
<td>#dateformat(SalesDate,"dd/mm/yyyy")#</td>
<td>#BranchID#</td><td><a href="SalesByInvoice.cfm?ProductID=#ProductID#&BranchID=#BranchID#&SalesDate=#dateformat(SalesDate,"dd/mm/yyyy")#">#ProductID#</a></td><td align="right"><div align="right">#TotalSales#</div></td>
</tr>
</cfloop>

</cfoutput>
</table>

</cfif><br />

<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="194">
<tr>
<td width="47" align="right" >
<label>
  <div align="right">Starting:</div>
</label>
</td>
<td align="left">
<div align="left">
  <cfinput name="startDate" type="datefield" required="yes" mask="dd/mm/yyyy" message="Enter Date" class="bold_10pt_Date">

</div>
</td>
</tr>
<tr>
<td>
<label>
  <div align="right">Ending:</div>
</label>
</td>
<td width="117">
<div align="left">
  <cfinput name="endDate" type="datefield" required="yes" mask="dd/mm/yyyy" message="Enter Date" class="bold_10pt_Date">
</div>
</td>
</tr>
<tr>
<td colspan="2">
  <div align="right">
    <cfinput name="Submit" value="Search" type="submit" class="bold_10pt_Button">
  </div></td>
</tr>
</table>
</cfform>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>