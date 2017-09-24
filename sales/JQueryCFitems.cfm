<cfset returnArray = ArrayNew(1) />
 
<cfquery name="qryStates"  maxrows="10">
SELECT barCode, Description, ProductID, salePrice FROM inventory
     where productId like <cfqueryparam value="#URL.term#%" cfsqltype="cf_sql_varchar">
     order by productId
</cfquery>

<cfloop query="qryStates">
    <cfset statesStruct = StructNew() />
	<cfset statesStruct["label"] = productId />
    <cfset statesStruct["description"] = description />
    <cfset statesStruct["salePrice"] = salePrice />

     
    <cfset ArrayAppend(returnArray,statesStruct) />
</cfloop>
 
<cfoutput>
#serializeJSON(returnArray)#
</cfoutput>