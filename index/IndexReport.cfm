<cfoutput>
<cfset thisyear=year(now())>
<cfset curmonth=Month(now())>
<cfif #curmonth# eq 1>
  <cfset prevmonth=12>
  <cfset prevyear=#thisyear# - 1>
<cfelse>
  <cfset prevmonth=#curmonth# - 1>
  <cfset prevyear=#thisyear#>
</cfif>


<cfquery name="calc">
Select ID,BranchID,SalesID,Month(SalesDate) AS mMonth,Year(SalesDate) AS yYear, CustomerID, StaffID, ProductID, Description, CostPrice, UnitPrice, Qty, CostAmt, Amt, Profit
FROM vwSalesDetails2
</cfquery>

<cfquery dbtype="query" name="calcDtls">
Select ID,BranchID,SalesID,mMonth,yYear,ProductID,Description, CustomerID, StaffID, CostPrice,UnitPrice,Qty,CostAmt,Amt,Profit
FROM calc
</cfquery>

<cfquery dbtype="query" name="CurrentProduct"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, ProductID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
where mMonth = #curmonth# AND yYear = #thisyear#
Group by ProductID
ORDER BY Qty Desc
</cfquery>

<cfquery dbtype="query" name="PreviousProduct"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, ProductID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
where mMonth = #prevmonth# AND yYear = #prevyear#
Group by ProductID
ORDER BY Qty Desc
</cfquery>

<cfquery dbtype="query" name="CurrentCustomer"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, CustomerID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
where mMonth = #curmonth# AND yYear = #thisyear#
Group by CustomerID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="PreviousCustomer"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, CustomerID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
where mMonth = #prevmonth# AND yYear = #prevyear#
Group by CustomerID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="CurrentStaff"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, StaffID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
where mMonth = #curmonth# AND yYear = #thisyear#
Group by StaffID
ORDER BY Amt Desc
</cfquery>

<cfquery dbtype="query" name="PreviousStaff"  maxrows="3">
SELECT  SUM(CostAmt) AS CostAmt, StaffID, SUM(Amt) AS Amt, SUM(Profit) AS Profit, SUM(Qty) AS Qty
FROM calcDtls
where mMonth = #prevmonth# AND yYear = #prevyear#
Group by StaffID
ORDER BY Amt Desc
</cfquery>

</cfoutput>
<table>
<tr>
<td>Previous Month</td><td>Current Month</td><td>Previous Month</td><td>Current Month</td>
</tr>
<tr>
<td>

<cfchart chartwidth="300" chartheight="250" yaxistitle="Qty in Rolls/Box" xaxistitle="Top Selling Products in #MonthAsString(prevMonth)#" show3d="yes" format="#request.format#">
<cfchartseries type="bar" query="PreviousProduct" valuecolumn="Qty" itemcolumn="ProductID" >
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="300" chartheight="250" yaxistitle="Qty in Rolls/Box" xaxistitle="Current Top Selling Products" show3d="yes"  format="#request.format#">
<cfchartseries type="bar" query="CurrentProduct" valuecolumn="Qty" itemcolumn="ProductID">
</cfchartseries>
</cfchart>
</td>
<td>
<cfchart chartwidth="300" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Top Customers in #MonthAsString(prevMonth)#" show3d="yes"  format="#request.format#">
<cfchartseries type="bar" query="PreviousCustomer" valuecolumn="Amt" itemcolumn="CustomerID">
</cfchartseries>
</cfchart><br>
</td><td>
<cfchart chartwidth="300" chartheight="250" yaxistitle="Amt in Naira" xaxistitle="Current Top Customers" show3d="yes"  format="#request.format#">
<cfchartseries type="bar" query="CurrentCustomer" valuecolumn="Amt" itemcolumn="CustomerID">
</cfchartseries>
</cfchart>
</td>
</tr>
</table>

