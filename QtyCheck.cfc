<cfcomponent name="jqueryOutput" output="false">

	<cffunction name="getAllCategory" access="remote" output="false" returntype="query">
		<cfset var qGetAllCategorys	= "" />

		<cfquery name="qGetAllCategory" datasource="TM001">
			SELECT DISTINCT categoryId FROM inventory ORDER BY categoryId
		</cfquery>

		<cfreturn qGetAllCategory />
	</cffunction>

	<cffunction name="getcategoryDetails" access="remote" output="false" returntype="query">
		<cfargument name="category" type="string" required="true" />
		<cfset var qGetCategoryDetails	= "" />

		<cfquery name="qGetCategoryDetails" datasource="TM001">
			SELECT *
			FROM inventory
			WHERE categoryId = <cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_char" />
			ORDER BY productId
		</cfquery>

		<cfreturn qGetCategoryDetails />
	</cffunction>
    
    <cffunction name="getQuantity" access="remote" returntype="string" hint="Get Products Quantity for Ajax SELECT">
<cfargument name="itemName" type="string">
<cfargument name="BranchID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT distinct Balance, ProductID FROM vwProductInBranch
WHERE ProductID = '#ARGUMENTS.itemName#' AND BranchID = '#ARGUMENTS.BranchID#'
</cfquery>
<cfset Qty =ValueList(data.Balance)>

<!--- And return it --->
<cfreturn Qty>
</cffunction>
    
    

</cfcomponent>