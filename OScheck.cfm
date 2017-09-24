<!--- Check for OS Type --->
<cfif findNoCase('Windows', cgi.http_user_agent,1)>
<cfset request.OS = "win">
</cfif>