<cfquery name="invoice">
select * from invoiceOptions
</cfquery>

<cfset SalesId = #url.CFGRIDKEY#>

<cfif #invoice.TEMPLATEID# is '1'>
<cfinclude template="invoice1.cfm">
<cfelseif #invoice.TEMPLATEID# is '2'>
<cfinclude template="invoice2.cfm">
<cfelseif #invoice.TEMPLATEID# is '3'>
<cfinclude template="invoice3.cfm">
<cfelseif #invoice.TEMPLATEID# is '4'>
<cfinclude template="invoice4.cfm">
<cfelseif #invoice.TEMPLATEID# is '5'>
<cfinclude template="invoice5.cfm">
</cfif>

<cfif isdefined('session.salesType')>
<cfquery>
UPDATE Sales
SET
type = 'Sales'
creator = '#GetAuthUser()#'
WHERE SalesID = #url.CFGRIDKEY#
</cfquery>
<cfset structdelete(session, 'salesType')>
</cfif>