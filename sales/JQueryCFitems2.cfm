<cffunction name="itemSearch" access="remote" output="no"  returnformat="JSON">
        <cfargument name="itemId" required="true" default="" />

        <!--- Define variables --->
        <cfset var returnArray =ArrayNew(1)>

        <!--- Do search --->
        <cfquery name="data" datasource="#datasource#">
        SELECT barCode, Description, ProductID, salePrice FROM inventory
        where productId like <cfqueryparam value="%#arguments.itemId#%" cfsqltype="cf_sql_varchar">
        order by productId
        </cfquery>

        <!--- Build result array --->
        <cfloop query="data">
            <cfset itemStruct = structNew() />
            <cfset itemStruct['desc'] = Description />
            <cfset itemStruct['price'] = salePrice />

            <cfset arrayAppend(returnArray,itemStruct) />    
        </cfloop>

        <!--- And return it --->
        <cfreturn returnArray />
    </cffunction>