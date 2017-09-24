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
<cfset session.Branch = 'Head Office'>
<cfdump var="#session.Branch#">
<cfdump var="#request.startyear#">
<cfdump var="#CreateODBCDate(request.startyear)#">
<cfdump var="#CreateODBCDate(dateformat(request.startyear,"dd/mm/yyyy"))#">
<cfdump var="#CreateODBCDate(now())#">


<cfquery name="calc">
Select ID,BranchID,SalesID,SalesDate as mMonth, CustomerID, StaffID, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit
FROM vwSalesDetails
WHERE BranchID = '#session.branch#' AND SalesDate between #CreateODBCDate(dateformat(request.startyear,"dd/mm/yyyy"))# AND  #CreateODBCDate(now())#
order by Salesdate
</cfquery>

<cfquery dbtype="query" name="calcDtls">
Select ID,BranchID,SalesID,mMonth,ProductID,Description, CustomerID, StaffID, CostPrice,UnitPrice,Qty,CostAmt,Amt,Profit
FROM calc
</cfquery>

<cfquery dbtype="query" name="Product"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, ProductID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
Group by ProductID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="Customer"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, CustomerID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
Group by CustomerID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="Staff"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, StaffID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
Group by StaffID
ORDER BY Amt Desc
</cfquery>

</cfoutput>
<table>
<tr>
<td>Top Selling Products</td><td>Current Month</td><td>Top Customers</td><td>Top Performing Staff</td>
</tr>
<tr>
<td>
<cfchart chartwidth="300" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Selling Products" show3d="yes">
<cfchartseries type="bar" query="Product" valuecolumn="Amt" itemcolumn="ProductID">
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="300" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Selling Products" show3d="yes">
<cfchartseries type="bar" query="Product" valuecolumn="Amt" itemcolumn="ProductID">
</cfchartseries>
</cfchart>
</td>
<td>
<cfchart chartwidth="300" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Customers" show3d="yes">
<cfchartseries type="bar" query="Customer" valuecolumn="Amt" itemcolumn="CustomerID">
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="300" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Performing Staff" show3d="yes">
<cfchartseries type="bar" query="Staff" valuecolumn="Amt" itemcolumn="StaffID">
</cfchartseries>
</cfchart>
</td>
</tr>
</table>