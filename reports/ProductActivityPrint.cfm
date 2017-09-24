<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
	
	<title><cfoutput>Product Activities :: #request.title#</cfoutput></title>
    <link rel="shortcut icon" href="../shared/TMicon.ico"/>
    <link rel="stylesheet" type="text/css" href="../invoices/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="../invoices/css/print.css" media="print"/>
    <script type="text/javascript" src="../invoices/js/jquery-1.3.2.min.js"></script>
    <script type="text/javascript" src="../invoices/js/example.js"></script>
    <style>
	body {
		font-family:"Gill Sans", "Gill Sans MT", "Myriad Pro", "DejaVu Sans Condensed", Helvetica, Arial, sans-serif;
		font-size:11px;
	}
					#identity {
						width: 90%;
						background-color:#888686;
						color:#F8F4F4;
						margin:auto;
						font-family:"Gill Sans", "Gill Sans MT", "Myriad Pro", "DejaVu Sans Condensed", Helvetica, Arial, sans-serif;
						}
						#addressline {
							color:#0540AA;
						}
					
					</style>
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
		<h2>Stock Status <cfif #GetUserRoles()# is "Administrator" OR #GetUserRoles()# is "Alpha">and Value</cfif>  At <cfoutput> #url.BranchID# </cfoutput> </h2>
            <div id="addressline" align="left">      
              <div id="address1">
            <Span id="address">#ucase(option.company)#</Span><br />
            <span> #request.CompanyAddress#<br />
Phone: #request.CompanyPhone#, #request.CompanyPhone2#</Span>
            <br />
Date: #dateformat(now(),"dd/mm/yyyy")#</Span>
            </div>
            <div id="logo2" align="right">
              <img id="image" src="../Invoices/images/#company.logo#" alt="logo" height="80px" />
            </div>
            </div>
		
		</div>
</cfoutput>
<cfparam name="url.branchId" default="">

<cfquery name="InventoryByShop">
SELECT ProductID, Balance, Description, vValue
FROM vwInventoryBalanceValue
WHERE BranchID = <cfqueryparam value="#url.BranchID#" cfsqltype="cf_sql_clob"> AND Balance <> 0
ORDER BY ProductID ASC
 </cfquery>
 
 <cfquery name="InventoryValue">
SELECT SUM(vValue) AS TotalValue
FROM vwInventoryBalanceValue
WHERE BranchID = <cfqueryparam value="#url.BranchID#" cfsqltype="cf_sql_clob"> AND Balance <> 0

 </cfquery>


<div align="center">

<div id="Content">

<div id="RightColumn">

<cfif #InventoryByShop.recordcount# eq 0>
<br />
<h2>There is no Item in <cfoutput><strong> #url.BranchID#</strong> </cfoutput>.</h2>

<cfelse>


<br />


<table width="90%" cellpadding="2" cellspacing="0">
<tr>
<td colspan="5" align="right"><cfif #GetUserRoles()# is "Administrator" OR #GetUserRoles()# is "Alpha">Total Stock Value: <cfoutput>N #numberformat(InventoryValue.TotalValue,",.00")#</cfoutput></cfif></td>
</tr>
<tr>
<td width="5%"><div align="left"><strong>S/N</strong></div></td>
<td width="30%"><div align="left"><strong>Product Name</strong></div></td>
<td width="30%"><div align="left"><strong>Description</strong></div></td> 
<td width="20%"><div align="right"><strong>Status</strong></div></td>
<td width="20%"><div align="right"><strong>Value (N)</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput query="InventoryByShop">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td>#currentRow#</td>
<td align="left"><div align="left">#ProductID#</div></td>
<td align="left"><div align="left">#Description#</div></td>
<td align="right"><div align="right">#numberformat(balance,",999.00")#</div></td>
<td align="right"><div align="right"><cfif #GetUserRoles()# is "Administrator" OR #GetUserRoles()# is "Alpha" >#numberformat(vValue,",999.00")#</cfif></div></td>
</tr>
</cfoutput>
</table>
</cfif>
<div align="center"  id="footer">
		  <span><cfoutput>#request.footer#</cfoutput></span>
		</div>
</div>
</div>
</div>
</body>
</html>