<cfset returnArray = ArrayNew(1) />
 
<cfquery name="qryStates" dataSource="TM001" maxrows="5">
    Select productId, description, balance, saleprice from vwProductInBranch
	     where productId like <cfqueryparam value="%#URL.term#%" cfsqltype="cf_sql_varchar"> AND Balance > 0
</cfquery>
 
<cfloop query="qryStates">
    <cfset statesStruct = StructNew() />
    <cfset statesStruct["label"] = productId />
    <cfset statesStruct["description"] = description />
    <cfset statesStruct["balance"] = balance />
    <cfset statesStruct["salesprice"] = saleprice />
     
    <cfset ArrayAppend(returnArray,statesStruct) />
</cfloop>
 
<cfoutput>
#serializeJSON(returnArray)#
</cfoutput>
