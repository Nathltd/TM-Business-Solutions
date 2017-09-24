<!doctype html>
<html>
<head>
<title><cfoutput>Purchase Modification :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>



<cfoutput>
<cfset thisyear=year(now())>
<cfset curmonth=Month(now())>
<cfif #curmonth# eq 1>
  <cfset prevmonth=12>
<cfelse>
  <cfset prevmonth=#curmonth# - 1>
</cfif>
<cfset curyear=Year(now())>
<cfset prevyear=#curyear# - 1>

<cfquery name="calc">
SELECT Month(SalesDate) AS mMonth, BranchID, StaffID, Amt
FROM vwSalesDetails
</cfquery>

<cfquery dbtype="query" name="calcDtls">
SELECT mMonth, BranchID, StaffID, Amt
FROM calc
</cfquery>

<cfquery dbtype="query" name="CurrentProduct"  maxrows="5">
SELECT StaffID, SUM(Amt) As Amt
FROM calcDtls
where mMonth = #curmonth#
Group by StaffID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="PreviousProduct"  maxrows="5">
SELECT StaffID, SUM(Amt) As Amt
FROM calcDtls
where mMonth = #prevmonth#
Group by StaffID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="CurrentCustomer"  maxrows="5">
SELECT BranchID, SUM(Amt) As Amt
FROM calcDtls
where mMonth = #curmonth#
Group by BranchID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="PreviousCustomer"  maxrows="5">
SELECT BranchID, SUM(Amt) As Amt
FROM calcDtls
where mMonth = #prevmonth#
Group by BranchID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="CurrentStaff"  maxrows="5">
SELECT BranchID, SUM(Amt) As Amt
FROM calcDtls
where mMonth = #curmonth#
Group by BranchID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="PreviousStaff"  maxrows="5">
SELECT BranchID, SUM(Amt) As Amt
FROM calcDtls
where mMonth = #prevmonth#
Group by BranchID
ORDER BY Amt Desc
</cfquery>

<cfquery name="calc2">
Select ID,BranchID,SalesID,Month(SalesDate) AS mMonth, CustomerID, StaffID, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit
FROM vwSalesDetails
</cfquery>

<cfquery dbtype="query" name="calcDtls2">
Select ID,BranchID,SalesID,mMonth,ProductID,Description, CustomerID, StaffID, CostPrice,UnitPrice,Qty,CostAmt,Amt,Profit
FROM calc2
</cfquery>

<cfquery dbtype="query" name="CurrentProduct2"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, ProductID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls2
where mMonth = #curmonth#
Group by ProductID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="PreviousProduct2"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, ProductID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls2
where mMonth = #prevmonth#
Group by ProductID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="CurrentCustomer2"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, CustomerID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls2
where mMonth = #curmonth#
Group by CustomerID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="PreviousCustomer2"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, CustomerID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls2
where mMonth = #prevmonth#
Group by CustomerID
ORDER BY Amt Desc
</cfquery>



</cfoutput>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<table>
<tr>
<td colspan="2">
<h4>Marketers'&nbsp;&nbsp;Rating</h4>
</td>
</tr>
<tr>
<td>Previous Month</td><td>Current Month</td>
</tr>
<tr>
<td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Marketers in #MonthAsString(prevMonth)#" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="PreviousProduct" valuecolumn="Amt" itemcolumn="StaffID" >
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Current Top Marketers" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="CurrentProduct" valuecolumn="Amt" itemcolumn="StaffID">
</cfchartseries>
</cfchart>
</td>
</tr>
<tr>
<td colspan="2">
<h4>Branches' &nbsp;&nbsp;Rating</h4>
</td>
</tr>
<tr>
<td>Previous Month</td><td>Current Month</td>
</tr>
<tr>
<td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Selling Branch in #MonthAsString(prevMonth)#" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="PreviousCustomer" valuecolumn="Amt" itemcolumn="BranchID">
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Current Top Selling Branch" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="CurrentCustomer" valuecolumn="Amt" itemcolumn="BranchID">
</cfchartseries>
</cfchart>
</td>
</tr>
<tr>
<td colspan="2">
<h4>Products'&nbsp;&nbsp;Rating</h4>
</td>
</tr>
<tr>
<td>Previous Month</td><td>Current Month</td>
</tr>
<tr>
<td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Selling Products in #MonthAsString(prevMonth)#" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="PreviousProduct2" valuecolumn="Amt" itemcolumn="ProductID" >
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Current Top Selling Products" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="CurrentProduct2" valuecolumn="Amt" itemcolumn="ProductID">
</cfchartseries>
</cfchart>
</td>
</tr>
<tr>
<td colspan="2">
<h4>Customers'&nbsp;&nbsp;Rating</h4>
</td>
</tr>
<tr>
<td>Previous Month</td><td>Current Month</td>
</tr>
<tr>
<td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Customers in #MonthAsString(prevMonth)#" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="PreviousCustomer2" valuecolumn="Amt" itemcolumn="CustomerID">
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="450" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Current Top Customers" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="CurrentCustomer2" valuecolumn="Amt" itemcolumn="CustomerID">
</cfchartseries>
</cfchart>
</td>
</tr>
</table>
</div>
</body>