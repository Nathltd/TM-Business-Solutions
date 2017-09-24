<cfquery name="sales" maxrows="10">
Select * from sales
where salesid like '000%'
order by salesid asc
</cfquery>

<cfoutput>



<cfloop query="sales">
<cfset newsalesid = #ReplaceNoCase(#salesId#, "0", "2")#>

#salesId# = #newsalesid#<br>
<cfquery>
UPDATE Sales
SET
SalesID = '#newsalesid#'
where salesid = '#salesId#'
</cfquery>

</cfloop>




</cfoutput>