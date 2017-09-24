<!doctype html>
<html>
<head>
<title><cfoutput>Product Activities :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>
<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div>
<h4><cfif isdefined ("form.search")><cfoutput>Inventory Valuation for #form.BranchID#  (#form.StartDate# - #form.EndDate#)</cfoutput><cfelse>Inventory Valuation</cfif></h4>
<div id="RightColumn">
<div align="right"> <a href="?">Reset</a>&nbsp;&nbsp;</div>

<cfparam name="form.productId" default="">
<cfparam name="form.search" default="">

<br>

<cfform action="productAnalysis2.cfm">
<table width="70%" cellpadding="2" border="0" >
<tr>
<td width="30%">Starting:</td> <td width="30%">Ending:</td> <td width="30%">Branch:</td> <td width="10%"></td>
</tr>
<tr>
<td><cfinput name="StartDate" type="datefield" placeholder="#dateFormat(request.StartYear,"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td><cfinput name="EndDate" type="datefield" placeholder="#dateFormat(now(),"dd/mm/yyyy")#" required="yes" message="Enter valid date" style="width:100%" mask="dd/mm/yyyy" autocomplete="off"></td>
<td valign="top"><cfselect name="BranchID" id="BranchID" required="yes" message="Select Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" style="width:100%"> </cfselect></td>
<td valign="top"><cfinput name="Search" value="Search" type="submit"></td>
</tr>
</table>
</cfform>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>