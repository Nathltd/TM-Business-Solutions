<cfquery name="queryData" datasource="#request.dsn#">
SELECT * 
FROM Sales
</cfquery>

<body>
<cfheader name="Content-Disposition" value="inline; filename=Sales_Report.xls">
<cfcontent type="application/vnd.ms-excel">



<table width="494" border="1">
<tr>

<td><strong> Date</strong> </td><td><strong> Receipt No </strong></td><td><strong> Customer </strong></td><td><strong> Branch </strong></td>
</tr>

 <cfoutput query="queryData">
<tr>
<td>#dateformat(SalesDate, 'dd/mm/yyyy')# </td><td>#SalesID#</td><td>#CustomerId#</td><td>#BranchId#</td> 
</tr>
</cfoutput>
</table>

</cfcontent>

</body>

