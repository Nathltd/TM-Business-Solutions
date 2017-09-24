<cfset returnArray = ArrayNew(1) />
 
<cfquery name="qryStates" dataSource="tmtest" maxrows="10">
    Select productCode, productId, description, salePrice from Inventory
     where productCode like <cfqueryparam value="619659000417" cfsqltype="cf_sql_varchar">
     order by productCode
</cfquery>

<cfloop query="qryStates">
    <cfset statesStruct = StructNew() />
	<cfset statesStruct["productId"] = productId />
    <cfset statesStruct["description"] = description />
    <cfset statesStruct["salePrice"] = salePrice />
     
    <cfset ArrayAppend(returnArray,statesStruct) />
</cfloop>
 
<cfoutput>
<span id="productId" >
#serializeJSON(statesStruct["productId"])#
</span>
<br>
<span id="desc" >
#serializeJSON(statesStruct["description"])#
</span>
<br>
<span id="price" >
#serializeJSON(statesStruct["salePrice"])#
</span>
</cfoutput>
