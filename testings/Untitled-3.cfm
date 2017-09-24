<cfset returnArray = ArrayNew(1) />
 
<cfquery name="qryStates" dataSource="tmtest" maxrows="10">
    Select productId, productCode, description, salePrice from Inventory
     where productId like <cfqueryparam value="%an%" cfsqltype="cf_sql_varchar">
     order by productId
</cfquery>

<cfloop query="qryStates">
    <cfset statesStruct = StructNew() />

    <cfset statesStruct["description"] = description />
    <cfset statesStruct["salePrice"] = salePrice />
     
    <cfset ArrayAppend(returnArray,statesStruct) />
</cfloop>
<span id="desc" >
<cfoutput>
#serializeJSON(statesStruct["description"])#
</cfoutput>
</span>
<br>
<span id="price" >
<cfoutput>
#serializeJSON(statesStruct["salePrice"])#
</cfoutput>
</span>