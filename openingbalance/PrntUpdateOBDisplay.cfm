
<cfquery name="OPdetails" datasource="#request.dsn#">
SELECT ID,BranchID,OpeningDate,ProductID,Qty, Damages, Creator
FROM OpeningBalance
<cfif #GetUserRoles()# is "Administrator">
<cfelse>
WHERE BranchID = <cfqueryparam value="#Trim(session.BranchID)#" cfsqltype="cf_sql_clob"> AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
ORDER BY BranchID,ProductID
</cfquery>
<cfdocument format="pdf">
<cfinclude template="../shared/header.cfm">
<br />
<br />
<div align="center">
<cfoutput><strong>LIST OF ITEMS IN OPENING BALANCE</strong>
<br />
<br />

<table width="502" border="0">
<tr>
<cfif #GetUserRoles()# is "Administrator">
<td width="137">Branch</td>
</cfif>
<td width="188">Product</td>
<td width="78" align="center">Quantity</td>
<td width="81" align="center">Damages</td>
</tr>

<cfloop query="Opdetails">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#">
<cfif #GetUserRoles()# is "Administrator">
<td>#BranchID#</td>
</cfif>
<td>#productID#</td>
<td align="right">#Qty#</td>
<td align="right">#Damages#</td>
</tr>
</cfloop>
</table>

<cfdocumentitem type="footer">
#cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</div>
</cfdocument>