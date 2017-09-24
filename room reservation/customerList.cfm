<cfset returnArray = ArrayNew(1) />
 
<cfquery name="qryStates" dataSource="TM001" maxrows="10">
    Select customerid from customers
     where customerid like <cfqueryparam value="%#URL.term#%" cfsqltype="cf_sql_varchar">
</cfquery>
 
<cfloop query="qryStates">
    <cfset statesStruct = StructNew() />
    <cfset statesStruct["label"] = customerid />
     
    <cfset ArrayAppend(returnArray,statesStruct) />
</cfloop>
 
<cfoutput>
#serializeJSON(returnArray)#
</cfoutput>
