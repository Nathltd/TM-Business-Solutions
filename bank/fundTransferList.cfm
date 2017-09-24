<!doctype html>
<html>
<head>
<title><cfoutput>Fund Transfer Search :: #request.title#</cfoutput></title>
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
<h4>Fund Transfer Search</h4>
<div id="RightColumn">
<cfparam name="form.Source" default="">
<cfparam name="form.Destination" default="">
<!---<div align="right"><cfif isdefined ("submit")><a href="TransferSearchpdf.cfm"><font size="-1">Print</font></a></cfif>&nbsp;&nbsp;</div>--->

<cfquery name="AllAccounts">
SELECT accountID FROM accounts
ORDER BY accountID
</cfquery>
<cfif isdefined ("submit")>
<cfset startDate = #form.StartDate#>
<cfset endDate = #form.endDate#>
<cfelse>
<cfset startDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset endDate = #dateformat(now(),"dd/mm/yyyy")#>
</cfif>
<cfoutput>
<cfform action="#cgi.SCRIPT_NAME#" method="post">
<table width="70%">
<tr align="left">
  <td valign="top" width="20%" ><div align="left">Starting:</div></td>
  <td valign="top" width="20%"><div align="left">Ending:</div></td>
  <td valign="top" width="20%" ><div align="left">Source:</div></td>
  <td valign="top" width="20%"><div align="left">Destination:</div></td>
  <td valign="top" width="10%"><div align="left"></div></td>
</tr>
<tr align="center">
  <td><div align="left">
    <cfinput name="startDate" type="datefield" required="yes" message="Enter Starting Date" mask="dd/mm/yyyy" placeholder="#startDate#" style="width:100%">
  </div>
    <label>
  </label>
  </td>
  <td>
    <div align="left">
      <cfinput name="endDate" type="datefield"  required="yes" message="Enter Ending Date" mask="dd/mm/yyyy" placeholder="#endDate#" style="width:100%">
    </div></td>
  <td valign="top">
    <div align="left">
      <cfselect name="Source" message="Choose Source"  required="yes" id="Source" style="width:100%">
        <option value="All" selected>All</option>
        <cfloop query="AllAccounts">
          <option value="#accountID#" <cfif AllAccounts.accountID is #form.Source#>
    selected </cfif>>#accountID#</option>
          </cfloop>
        </cfselect>
    </div></td>
  <td valign="top">
    <div align="left">
      <cfselect name="Destination" message="Choose Destination"  required="yes" id="Destination" style="width:100%">
        <option value="All" selected>All</option>
        <cfloop query="AllAccounts">
          <option value="#accountID#" <cfif AllAccounts.accountID is #form.Source#>
    selected </cfif>>#accountID#</option>
          </cfloop>
        </cfselect>
      </div></td>
  <td valign="top"><div align="left">
    <cfinput name="Submit" value="Search" type="submit" >
  </div></td>
</tr>
<tr>
  <td colspan="4">
    <div align="center"></div></td>
</tr>
</table>
</cfform>
</cfoutput>

<cfif isdefined ("submit")>

<cfset session.StartDate = "#Form.StartDate#">
<cfset session.EndDate = "#Form.EndDate#">
<cfset session.Source = "#form.Source#">
<cfset session.Destination = "#form.Destination#">

<cfquery name="TransferSearch">
SELECT TransferDate, TransferID, SourceId, DestineId, Amount, staffId, remark
FROM vwFundTransfer
WHERE 	TransferDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #form.Source# is "All">
		<cfelse>
        AND SourceId = <cfqueryparam value="#trim(form.Source)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.Destination# is "All">
		<cfelse>
        AND DestineId = <cfqueryparam value="#trim(form.Destination)#"cfsqltype="cf_sql_clob">
        </cfif>
        ORDER BY TransferDate ASC
 </cfquery>
 
 <cfquery name="tsT">
SELECT SUM(Amount) AS Amt
FROM vwFundTransfer
WHERE 	TransferDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #form.Source# is "All">
		<cfelse>
        AND SourceId = <cfqueryparam value="#trim(form.Source)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.Destination# is "All">
		<cfelse>
        AND DestineId = <cfqueryparam value="#trim(form.Destination)#"cfsqltype="cf_sql_clob">
        </cfif>
</cfquery>
<cfif #transferSearch.recordCount# eq 0>
<h2>No record found!</h2>
<cfelse>
<table width="90%" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="10%"><strong>Date</strong></td>
<td width="15%"><strong>Transfer No.</strong></td>
<td width="20%"><strong>Source</strong></td>
<td width="20%"><strong>Destination</strong></td>
<td width="15%"><strong>Details</strong></td>
<td width="15%"><strong>Authorised</strong></td>
<td width="15%"><strong>Amount</strong></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="TransferSearch">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#dateformat(TransferDate,"dd/mm/yyyy")#</td>
<td>#TransferID#</td>
<td><div align="left">#SourceId#</div></td>
<td align="right"><div align="left">#DestineId#</div></td>
<td align="right"><div align="left">#remark#</div></td>
<td align="right"><div align="left">#staffId#</div></td>
<td align="right" width="84"><div align="right">#numberformat(Amount,",000.00")#</div></td>
</tr>
</cfloop>
<tr>
<td></td>
<td></td>
<td></td>
<td align="right"></td>
<td align="left">&nbsp;</td>
<td align="right"><strong>Total:</strong></td>
<td align="right" width="84"><div align="right"><strong>#numberformat(tsT.Amt,",000.00")#</strong></div></td>
</tr>
</cfoutput>

</table>
</cfif>
<cfelse>

</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html> 