

<cfquery name="sale">
select salesid from sales
where salesid like '%c%'
order by salesid desc
</cfquery>

<cfoutput>
<cfloop query="sale">
<cfset Csalesid = #lcase(salesid)#>
<cfset MsalesId = #replace(Csalesid, "c", "3")#>
<cfset newId = #Left(salesid, len(salesid)-1)#>

#salesid# - - - - #Left(salesid, len(salesid)-1)# ------- #MsalesId#<br>

<cfquery>
UPDATE Sales
SET
SalesID = '#MsalesId#'
WHERE SalesID = '#sale.salesId#'
</cfquery>
</cfloop>

</cfoutput>


