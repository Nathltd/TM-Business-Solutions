<cfset returnArray = ArrayNew(1) />
 
<cfquery name="qryStates" dataSource="tmtest" maxrows="10">
    SELECT barCode, Description, ProductID, salePrice, balance FROM vwProductInBranch
     where productId like <cfqueryparam value="%#URL.term#%" cfsqltype="cf_sql_varchar">
     order by productId
</cfquery>

<cfloop query="qryStates">
    <cfset statesStruct = StructNew() />
	<cfset statesStruct["label"] = productId />
    <cfset statesStruct["description"] = description />
    <cfset statesStruct["salePrice"] = salePrice />
    <cfset statesStruct["balance"] = balance />
     
    <cfset ArrayAppend(returnArray,statesStruct) />
</cfloop>
 
<cfoutput>
#serializeJSON(returnArray)#
</cfoutput>
