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
<h4>Product/Branch Activity</h4>
<div id="RightColumn">
<cfparam name="form.BranchID" default="">
<cfparam name="form.ProductID" default="">
<div align="right"><a href="SalesSearchpdf.cfm">Print</a>&nbsp;</div><br>
<cfquery name="AllProducts">
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
<cfform action="#cgi.SCRIPT_NAME#" method="post">
<table width="601" class="font1">
<tr align="left">
  <td valign="top" ><div align="left"><strong>Starting:</strong></div></td>
  <td valign="top"><div align="left"><strong>Ending:</strong></div></td>
  <td valign="top"><div align="left"><strong>Branch:</strong></div></td>
  <td valign="top"><div align="left"><strong>Product:</strong></div></td>
  <td valign="top"><div align="left"></div></td>
</tr>
<tr align="center">
  <td width="131" valign="bottom" ><div align="left">
    <cfinput name="startDate" type="datefield" required="yes" mask="dd/mm/yyyy" message="Enter Starting Date" class="bold_10pt_Date" value="#startDate#">
  </div>
    <label>
  </label>
  </td>
  <td width="131" valign="bottom">
    <div align="left">
      <cfinput name="endDate" type="datefield" required="yes" mask="dd/mm/yyyy" message="Enter Ending Date" class="bold_10pt_Date" value="#endDate#">
      </div></td>
  <td width="128" valign="bottom">
  <div align="left">
      <cfselect name="BranchID" message="Choose Branch"  required="yes" id="BranchID" class="bold_10pt_item">
      <option value="All" selected>All</option>
      <cfloop query="AllBranches">
      <option value="#BranchID#" <cfif AllBranches.BranchID is #form.BranchID#>
    selected </cfif>>#BranchID#</option>
      </cfloop>
        </cfselect>
    </div>
    </td>
  <td width="126"valign="bottom">
  <div align="left">
      <cfselect name="ProductID" message="Choose Product"  required="yes" id="ProductID" class="bold_10pt_item">
      
      <cfloop query="AllProducts">
      <option value="#ProductID#" <cfif AllProducts.ProductID is #form.ProductID#>
    selected </cfif>>#ProductID#</option>
      </cfloop>
        </cfselect>
    </div>
    </td>
  <td width="61" valign="top"><div>
    <cfinput name="Submit" value="Search" type="submit" class="bold_10pt_Button">
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
<cfset session.ProductID = "#form.ProductID#">
<cfset session.BranchID = "#form.BranchID#">

<cfquery name="SalesSearch">
SELECT ProductID, Qty, ReceiptDate, TypeID, BranchID
FROM vwProductTransactUnion
WHERE ReceiptDate between <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
        AND <cfqueryparam value="#dateformat(form.endDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #form.BranchID# is "All">
		<cfelse>
		AND BranchID = <cfqueryparam value="#trim(form.BranchID)#"cfsqltype="cf_sql_clob">
        </cfif>
        AND ProductID = <cfqueryparam value="#trim(form.ProductID)#"cfsqltype="cf_sql_clob">
         
         ORDER BY ReceiptDate ASC
</cfquery>
 
 <cfquery name="tsT">
SELECT SUM(Qty) AS Quantity
FROM vwProductTransactUnion
WHERE  ReceiptDate > <cfqueryparam value="#request.StartYear#" cfsqltype="cf_sql_date">
        and ReceiptDate < <cfqueryparam value="#dateformat(form.startDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_date">
		<cfif #form.BranchID# is "All">
		<cfelse>
		AND BranchID = <cfqueryparam value="#trim(form.BranchID)#"cfsqltype="cf_sql_clob">
        </cfif>
        AND ProductID = <cfqueryparam value="#trim(form.ProductID)#"cfsqltype="cf_sql_clob">
         		
</cfquery>
<cfparam name="qty2"  default="#tsT.Quantity#">
<cfif #SalesSearch.recordCount# eq 0>
<table width="571" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="83"><strong>Date</strong></td>
<td width="80"><strong>Branch</strong></td>
<td width="79"><strong>Trans. Type</strong></td>
<td width="104"><strong>Quantity</strong></td>
  <td hidden="yes"><div align="right"></div></td>
<td width="59"><strong>Balance</strong></td>
</tr>
<tr>
<td></td>
</tr>

<cfoutput>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>No Date</td>
<td>None</td>
<td><div align="left">#form.ProductID#</div></td>
<td align="left"><div align="left">#form.BranchID#</div></td>
<td align="right" width="59"><div align="right">0</div></td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
<td align="left"><strong>Total:</strong></td>
<td align="right" width="59"><strong>0</strong></td>
</tr>
</cfoutput>

</table>
<cfelse>
<table width="558" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="82"><strong>Date</strong></td>
<td width="79"><strong>Branch</strong></td>
<td width="111"><strong>Trans. Type</strong></td>
<td width="73"><div align="right"><strong>Quantity</strong></div></td>
<td width="58" hidden="yes" ><div align="right"><strong>Cal</strong></div></td>
<td width="95"><div align="right"><strong>Balance</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td><div align="right"><strong>Prev. Bal.</strong></div></td>
  <td hidden="yes"><div align="right"></div></td>
  <td><div align="right"><strong>
    <cfoutput>#Qty2#</cfoutput>
  </strong></div></td>
</tr>
<cfoutput>
<cfloop query="SalesSearch">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#dateformat(ReceiptDate,"dd/mm/yyyy")#</td>
<td>#BranchID#</td>
<td><div align="left">#TypeID#</div></td>
<td align="left"><div align="right">#Qty#</div></td>
<td hidden="yes"><div align="right">#Qty2#
  <cfif isdefined (#Qty2#)>
    <cfset qty2 = #qty#>
    <cfelse>
    <cfif #SalesSearch.TypeID# is "Sales">
      <cfset qty2 = -(#qty#)+#qty2#>
      <cfelseif #SalesSearch.TypeID# is "Transfer Out">
      <cfset qty2 = -(#qty#)+#qty2#>
      <cfelse>
      <cfset qty2 = (#qty#)+#val(qty2)#>
    </cfif>
  </cfif>
</div></td>
<cfset newBalance = +#Qty#+#Qty2#-#Qty#>
<td align="right" width="95"><div align="right">#newBalance#</div></td>
</tr>
</cfloop>
<tr>
<td></td>
<td></td>
<td></td>
<td align="left"><div align="right"><strong>Total:</strong></div></td>
<td hidden="yes"><div align="right"></div></td>
<td align="right" width="95"><div align="right"><strong>#tsT.Quantity#</strong></div></td>
</tr>
</cfoutput>

</table>
</cfif>
<cfelse>

</cfif>
</div>
</div>
</div>
</body>
</html> 