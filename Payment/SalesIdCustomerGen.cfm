<cfset returnArray = ArrayNew(1) />
 
<cfquery name="qryCustomers" maxrows="10">
    Select salesId, CustomerId from CustomersGen
     where salesId like <cfqueryparam value="%#URL.term#%" cfsqltype="cf_sql_varchar"> AND Status = 'Enabled'
     order by salesId
</cfquery>
 
<cfloop query="qryCustomers">
    <cfset customerStruct = StructNew() />
    <cfset customerStruct["label"] = salesId />
    <cfset customerStruct["description"] = CustomerId />
     
    <cfset ArrayAppend(returnArray,customerStruct) />
</cfloop>
 
<cfoutput>
#serializeJSON(returnArray)#
</cfoutput>
