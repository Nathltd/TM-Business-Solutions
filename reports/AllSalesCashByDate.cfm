<!doctype html>
<html>
<head>
<title><cfoutput>Cash Payments :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Cash payments  By Date</h4>

<div id="RightColumn">
<cfparam name="form.Search" default="">
<cfif isdefined (#form.Search#)>
<cfquery name="InventoryByDate">
SELECT SalesDate, BranchID, TotalAmount, AmountPaid
FROM vwSalesAmtPerDaySumry
WHERE SalesDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE"> AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE">
ORDER BY SalesDate ASC
 </cfquery>
 <cfquery name="salesFin">
SELECT SalesDate, BranchID, SUM(AmountPaid) as AmtPaid, SUM(TotalAmount) AS TotalAmt
FROM vwSalesAmtPerDaySumry
WHERE SalesDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE"> AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE">
group by SalesDate, BranchID
 </cfquery>
 

<cfif #InventoryByDate.recordcount# eq 0><br />
<br />

No record between 
<cfoutput><strong> #form.startDate# and #form.endDate#</strong> </cfoutput>

<cfelse>

<div>
<div align="right"><a href="AllSalesCashByDate.cfm">reset</a>&nbsp;</div>
<cfoutput>#InventoryByDate.recordcount# Records found between <strong>#form.startDate# and #form.endDate#</cfoutput> </strong>
<br />
<br />


<table width="70%" border="0" cellpadding="3" cellspacing="0">
<tr>
<td width="69"><strong>Date</strong></td>
<td width="60"><strong>Branch</strong></td>
<td width="139"><div align="right"><strong>Sales Value</strong></div></td>
<td width="149"><div align="right"><strong>Amount Paid</strong></div></td>
<td width="139"><div align="right"><strong>Sales On Credit</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="salesFin">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#dateformat(SalesDate,"dd/mm/yyyy")#</td>
<td>#BranchID#</td>
<td><div align="right">#numberformat(TotalAmt,",000.00")#</div>  </a></td><td align="right"><div align="right">#numberformat(AmtPaid,",000.00")#</div></td>
<cfset bal = #TotalAmt# - #AmtPaid#>
<td align="right"><div align="right">#numberformat(bal,",000.00")#</div></td>
</tr>
</cfloop>
</cfoutput>
<!---<tr>
<cfoutput>
<td colspan="1" align="right"></td>
<td align="right"><strong>Total:</strong></td>
<td align="right"><div align="right"><strong>#numberformat(Inventory.TotalAmt,",000.00")#</strong></div></td>
<td align="right"><div align="right"><strong>#numberformat(Inventory.AmtPaid,",000.00")#</strong></div></td>
<td align="right"><div align="right"><strong>#numberformat(Inventory.Bal,",000.00")#</strong></div></td>
</cfoutput>
</tr>--->
</table>
</div>
</cfif>


</div>

</div>
<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="27%">
<tr>
  <td  align="right" >
  <label>
    <div align="left">Starting:</div>
  </label>
  </td>
  <td  align="left">
    <div align="left">
      <cfinput name="startDate" type="datefield" class="bold_10pt_Date" required="yes" mask="dd/mm/yyyy" message="Enter Date">
      
      </div>
  </td>
  </tr>
<tr>
  <td><div align="left">Ending:</div></td>
  <td><div align="left">&nbsp;&nbsp;
    <cfinput name="endDate" type="datefield" class="bold_10pt_Date" required="yes" mask="dd/mm/yyyy" message="Enter Date">
  </div></td>
  </tr>
<tr>
<td colspan="2">
  <div align="right">
    <cfinput name="Search" value="Search" type="submit" class="bold_10pt_Button">
  </div></td>
</tr>
</table>
</cfform>
</cfif>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</div>

</body>
</html>