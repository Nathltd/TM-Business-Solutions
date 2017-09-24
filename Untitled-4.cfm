<cfquery name="data">
SELECT AccountType FROM AccountType
WHERE AccountType <> 'Rebate'
</cfquery>


<cfdump var="#data#">