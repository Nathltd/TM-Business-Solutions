<cfquery name="invoice">
select * from invoiceOptions
</cfquery>

<cfset SalesId = #url.CFGRIDKEY#>

<cfif #invoice.TEMPLATEID# is '1'>
<cfinclude template="invoice1.cfm">
<cfelseif #invoice.TEMPLATEID# is '2'>
<cfinclude template="invoice2.cfm">
</cfif>