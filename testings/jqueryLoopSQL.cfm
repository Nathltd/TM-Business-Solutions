<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Untitled Document</title>
</head>

<body>
<cfset stockEndDate = '23-Feb-17'>
<cfset StartYear = '23-Feb-15'>
<cfset today = '23-Feb-17'>

<cfquery name="TotalQty" cachedwithin="#CreateTimeSpan(0, 0, 20, 0)#" timeout="300" maxrows="10">
SELECT TypeID, SUM(Qty) AS Qty1, ProductID FROM vwProductTransactUnion
WHERE ProductID = 'BA-SP-4C' AND ddate >= #CreateODBCDate(StartYear)# AND ddate <= #CreateODBCDate(stockEndDate)# 
GROUP BY TypeID, ProductID

</cfquery>
<cfdump var="#totalQty#">
<cfoutput>

#dateformat(now())#<br>
#CreateODBCDate(today)#<br>
#CreateODBCDate(request.StartYear)#<br>

<cfloop query="totalQty">
#ProductID#, #Qty1#<br>

</cfloop>

</cfoutput>

</body>
</html>
