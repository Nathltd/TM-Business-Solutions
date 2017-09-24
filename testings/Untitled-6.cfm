<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE AccountType
ORDER BY AccountID
</cfquery>



<cfdump var="#data#">
<