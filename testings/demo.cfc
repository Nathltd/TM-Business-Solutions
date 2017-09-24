<cfcomponent>

<!--- Get All Products List For Assemble--->
<cffunction name="NewCategory" access="remote" returnType="query" hint="Insert New Category">

<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT * FROM InventoryCategory
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

</cfcomponent>