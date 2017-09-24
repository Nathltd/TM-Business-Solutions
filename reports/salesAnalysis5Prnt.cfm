<!doctype html>
<html>
<head>
<title><cfoutput>Sales Analysis :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>

</head>

<body>

<div align="center">
<cfparam name="form.search" default="">

<div id="RightColumnPrnt">


<cfif isdefined(form.search)>
<cfset session.branchId = #form.branchId#>
<cfset session.StartDate = #createODBCDate(Dateformat(form.StartDate,"dd/mm/yyyy"))#>
<cfset session.EndDate = #createODBCDate(Dateformat(form.EndDate,"dd/mm/yyyy"))#>


<cfquery name="SalesDetails">
Select ProductID, UnitPrice, SUM(Qty) AS sumQty, SUM(Amt) As sumAmt
FROM vwSalesDetails2
WHERE SalesDate >= #CreateODBCDate(session.StartDate)# AND SalesDate <= #CreateODBCDate(session.EndDate)# AND BranchID = '#session.BranchID#'
GROUP BY ProductId, UnitPrice
</cfquery>
<cfquery name="calcTotal">
Select SUM(Amt) As sumAmt
FROM vwSalesDetails2
WHERE SalesDate >= #CreateODBCDate(session.StartDate)# AND SalesDate <= #CreateODBCDate(session.EndDate)# AND BranchID = '#session.BranchID#'
</cfquery>


<div align="left">
<img src="../shared/TMlogoSmall3.jpg" width="30" height="30">

<cfoutput>
<table width="586">
<tr>
  <td width="578">
    <font size="+3" face="Segoe UI"><strong>#request.Company#</strong></font>
    <br>
    <font size="+3" face="Segoe UI" color="##666666"><strong>SALES REPORT</strong></font><br>
<cfoutput> <cfif isdefined(form.search)>#StartDate# and #endDate# for #branchId#</cfif></cfoutput></td>
</tr>
</table>
</cfoutput><br>

<div id="InvoiceRow">
<table width="450">

<tr align="center">
<td width="150"><div align="left"> <strong>Item</strong></div></td>
<td width="41"> <div align="right"><strong>Qty</strong></div></td>
<td width="50"> <div align="right"><strong>Price</strong></div></td>
<td width="50"> <div align="right"><strong>Amout</strong></div></td>
</tr>

<cfoutput query="SalesDetails">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left"><strong>#ProductID#</strong></td>
<td align="right"> <div align="right"><strong>#LSNumberFormat(SUMQty,',999')# </strong></div></td>
<td align="right"> <div align="right"><strong>#LSNumberFormat(UnitPrice,',999.99')#</strong></div></td>
<td align="right"> <div align="right"><strong>#LSNumberFormat(sumAmt,',9999999999.99')#</strong></div></td>
</tr>
</cfoutput>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>
<cfoutput>
<tr>
<td colspan="4"><div align="right"> <strong>&##x20a6 #numberformat(calctotal.sumAmt,",999.00")#</strong></div></td>
</tr>
</cfoutput>
</table>
</div>
<br>
</div>
<cfelse>
<cfform action="#cgi.SCRIPT_NAME#">
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
</cfif>
</div>
</div>
</body>