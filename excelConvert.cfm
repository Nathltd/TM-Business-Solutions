<cfquery name="queryData" datasource="#request.dsn#">
SELECT * 
FROM vwSalesDetails
</cfquery>

<body>

<cfheader name="Content-Disposition" value="inline; filename=TM_Report.xls">
<cfcontent type="application/vnd.ms-excel">



<table border="2">
<tr>
<td colspan="4"> Daily Sales </td>
</tr>
<tr>
<td> SalesID </td><td> Sales Date </td><td> Item </td><td> Amount</td>
</tr>
 <cfoutput query="queryData">
<tr>
<td>#SalesID#</td><td>#Dateformat(SalesDate,"dd/mm/yyyy")#</td> <td> #ProductID# </td><td> #Amt# </td>
</tr>
</cfoutput>
</table>

</cfcontent>
</body>