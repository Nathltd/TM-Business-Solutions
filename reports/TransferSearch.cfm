<!doctype html>
<html>
<head>
<title><cfoutput>Transfer Analysis :: #request.title#</cfoutput></title>
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
<h4>Transfer Search</h4>
<div id="RightColumn">
<cfparam name="form.Source" default="">
<cfparam name="form.Destination" default="">
<cfparam name="form.ProductID" default="">
<div align="right"><cfif isdefined ("submit")><a href="TransferSearchpdf.cfm"><font size="-1">Print</font></a></cfif>&nbsp;&nbsp;</div>

<cfquery name="Allproducts">
SELECT ProductID FROM Inventory
ORDER BY ProductID
</cfquery>
<cfquery name="AllBranches">
SELECT BranchID FROM Branches
ORDER BY BranchID
</cfquery>
<cfif isdefined ("submit")>
<cfset startDate = #form.StartDate#>
<cfset endDate = #form.endDate#>
<cfelse>
<cfset startDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset endDate = #dateformat(now(),"dd/mm/yyyy")#>
</cfif>
<cfoutput>
<cfform action="TransferSearch.cfm" method="post">
<table width="90%">
<tr align="left">
  <td valign="top" ><div align="left">Starting:</div></td>
  <td valign="top"><div align="left">Ending:</div></td>
  <td valign="top"><div align="left">Product:</div></td>
  <td valign="top" ><div align="left">Source:</div></td>
  <td valign="top"><div align="left">Destination:</div></td>
  <td valign="top"><div align="left"></div></td>
</tr>
<tr align="center">
<td width="20%"><div align="left">
  <cfinput name="startDate" type="datefield" required="yes" message="Enter Starting Date" mask="dd/mm/yyyy" placeholder="#startDate#" style="width:100%">
</div>
  <label>
</label>
</td>
<td width="20%">
  <div align="left">
    <cfinput name="endDate" type="datefield"  required="yes" message="Enter Ending Date"  mask="dd/mm/yyyy" placeholder="#endDate#" style="width:100%">
  </div></td>
  <td valign="top" width="20%">
  <div align="left">
    <cfselect name="ProductID" message="Choose Product"  required="yes" id="ProductID"class="bold_10pt_black" style="width:100%">
    <option value="All" selected>All</option>
    <cfloop query="Allproducts">
    <option value="#ProductID#" <cfif Allproducts.ProductID is #form.ProductID#> selected </cfif>>#ProductID#</option>
    </cfloop>
          </cfselect>
  </div></td>
<td valign="top" width="20%">
  <div align="left">
    <cfselect name="Source" message="Choose Source"  required="yes" id="Source" style="width:100%">
    <option value="All" selected>All</option>
    <cfloop query="AllBranches">
      <option value="#BranchID#" <cfif AllBranches.BranchID is #form.Source#>
    selected </cfif>>#BranchID#</option>
      </cfloop>
            </cfselect>
  </div></td>
<td width="20%" valign="top">
  <div align="left">
    <cfselect name="Destination" message="Choose Destination"  required="yes" id="Destination" style="width:100%">
    <option value="All" selected>All</option>
    <cfloop query="AllBranches">
      <option value="#BranchID#" <cfif AllBranches.BranchID is #form.Destination#>
    selected </cfif>>#BranchID#</option>
      </cfloop>
      </cfselect>
  </div></td>
<td><div align="left" valign="top">
  <cfinput name="Submit" value="Search" type="submit">
</div></td>
</tr>
<tr>

</tr>
<tr>
<td colspan="5">
  <div align="center"></div></td>
</tr>
</table>
</cfform>
</cfoutput>

<cfif isdefined ("submit")>

<cfset session.StartDate = "#Form.StartDate#">
<cfset session.EndDate = "#Form.EndDate#">
<cfset session.ProductID = "#form.ProductID#">
<cfset session.Source = "#form.Source#">
<cfset session.Destination = "#form.Destination#">

<cfquery name="TransferSearch">
SELECT TransferDate, TransferID, ProductID, Description, Source, Destination,Quantity
FROM vwTransferUpdate
WHERE 	TransferDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #form.Source# is "All">
		<cfelse>
        AND Source = <cfqueryparam value="#trim(form.Source)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.Destination# is "All">
		<cfelse>
        AND Destination = <cfqueryparam value="#trim(form.Destination)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(form.ProductID)#"cfsqltype="cf_sql_clob">
        </cfif>
        ORDER BY TransferDate ASC
 </cfquery>
 
 <cfquery name="tsT">
SELECT SUM(Quantity) AS Qty
FROM vwTransferUpdate
WHERE 	TransferDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        <cfif #form.Source# is "All">
		<cfelse>
        AND Source = <cfqueryparam value="#trim(form.Source)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.Destination# is "All">
		<cfelse>
        AND Destination = <cfqueryparam value="#trim(form.Destination)#"cfsqltype="cf_sql_clob">
        </cfif>
        <cfif #form.ProductID# is "All">
		<cfelse>
        AND ProductID = <cfqueryparam value="#trim(form.ProductID)#"cfsqltype="cf_sql_clob">
        </cfif> 
</cfquery>
<cfif #transferSearch.recordCount# eq 0>
<h2> No Record Found! </h2>
<cfelse>
<table width="90%" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="5%"><strong>Date</strong></td>
<td width="8%"><strong>Transfer #</strong></td>
<td width="15%"><strong>Item</strong></td>
<td width="20%"><strong>Description</strong></td>
<td width="13%"><strong>Source</strong></td>
<td width="15%"><strong>Destination</strong></td>
<td width="7%"><div align="right"><strong>Quantity</strong></div></td>
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
<td width="250"><div align="left">#ProductID#</div></td><td align="right" width="250"><div align="left">#Description#</div></td>
<td><div align="left">#Source#</div></td><td align="right"><div align="left">#Destination#</div></td>
<td align="right" width="60"><div align="right">#Quantity#</div></td>
</tr>
</cfloop>
<tr>
<td></td>
<td></td>
<td></td>
<td></td><td align="right"></td>
<td align="left"><strong>Total:</strong></td>
<td align="right" width="48"><div align="right"><strong>#tsT.Qty#</strong></div></td>
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