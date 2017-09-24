<cfcomponent output="no">
<cfset this.name = "tm001">
<cfset this.Datasource = "tm001">
<!---<cfset this.ormenabled = "true" >--->
<cfset this.sessionManagement = "yes">
<cfset sessionTimeout = #CreateTimeSpan(0, 0, 20, 0)#>
<cfset request.dsn = "tm001">
<!--- cfc Empty for Online Version --->
<cfset request.cfc = "tm001.">
<cfset request.bkup = "tm001\">
<cfset request.db = "tm001\db\">
<cfset request.shared = "tm001\shared\">
<cfset request.footer = "&copy;2011 - #year(now())# transacTManager&reg;. All rights reserved.">
<!--- Check for OS Type --->
<cfif findNoCase('Windows', cgi.http_user_agent,1)>
<cfset request.format = "flash">
<cfelse>
<cfset request.format = "jpg">
</cfif>

<!---To control Revenue Limit for this Application--->


<!---<cfquery name="vendors" datasource="#request.dsn#">
Select MAX(Salesid) AS myID from Sales
Group by SalesID order by Salesid desc
</cfquery>
<cfset request.SalesID = #vendors.myID#>--->

<!---To control Closing Date for this Application--->

<cfquery name="ClsDate" datasource="#request.dsn#">
SELECT closingDate FROM closingDate
</cfquery>
<cfset request.clsDate = #Dateformat(ClsDate.closingDate, "mm/dd/yyyy")#>

<!---To control Subscription Date for this Application--->

<cfquery name="ClsDateSubscribe" datasource="#request.dsn#">
SELECT closingDate FROM closingDateSubscribe
</cfquery>
<cfset request.clsDateSubscribe = #CreateODBCDate(ClsDateSubscribe.closingDate)#>

<cfquery name="CompanyInfo" datasource="#request.dsn#">
SELECT CompanyName, Address, Phone, Phone2, Phone3, EmailAddress, Address2
FROM Company 
</cfquery>
<cfquery name="Invoice" datasource="#request.dsn#">
select formatId from invoiceOptions
</cfquery>
<cfquery name="FinYear" datasource="#request.dsn#">
SELECT StartDate, EndDate
FROM FinancialYear 
</cfquery>
<cfset session.Company = #CompanyInfo.CompanyName#>
<cfset request.StartYear = #createODBCdate(FinYear.StartDate)#>
<cfset request.EndYear = #createODBCdate(FinYear.EndDate)#>
<cfset request.Company = #CompanyInfo.CompanyName#>
<cfset request.CompanyAddress = #CompanyInfo.Address#>
<cfset request.CompanyAddress2 = #CompanyInfo.Address2#>
<cfset request.CompanyPhone = #CompanyInfo.Phone#>
<cfset request.CompanyPhone2 = #CompanyInfo.Phone2#>
<cfset request.CompanyPhone3 = #CompanyInfo.Phone3#>
<cfset request.CompanyEmail = #CompanyInfo.EmailAddress#>
<cfset request.invoiceFormat = #Invoice.formatId#>
<cfset request.title = "#session.Company# Accounts">




<cffunction name="onApplicationStart" returnType="boolean" output="false">
<cfset application.dsn = "tm001">
<cfset sessionManagement = "yes">
<cfset sessionTimeout = #CreateTimeSpan(0, 0, 2, 0)# >
<cfreturn true>
</cffunction>



<cffunction name="onSessionStart" returnType="void" output="no">
	<cfset var thisPage = cgi.SCRIPT_NAME>
    <cfif len(cgi.QUERY_STRING)>
    	<cfset thisPage=thisPage & "?" & cgi.QUERY_STRING>
    </cfif>
    <cfset session.hits = 0>
    <!--- Log the entry page --->
    <cfquery datasource="#application.dsn#">
    insert into logInfo (sessionId,entryPage,loginTime)
    values(
    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.URLToken#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#thisPage#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCdate(Now())#">)
    </cfquery>
    
</cffunction>

<cffunction name="onRequestStart" returnType="boolean" output="no">
	<cfargument name="thePage" type="string" required="yes">
    <cfset var thisPage = arguments.thePage>
    <cfif len(cgi.QUERY_STRING)>
    	<cfset thisPage=thisPage & "?" & cgi.QUERY_STRING>
    </cfif>
    <!--- Store for later use --->
	<cfset session.lastPage = thisPage>
	<cfset session.lastHit = now()>
	<cfset session.hits = session.hits + 1>
	<cfreturn true>
</cffunction>

<cffunction name="onSessionEnd" returnType="void" output="no">
	<cfargument name="sessionScope" type="struct" required="yes">
    <cfargument name="appScope" type="struct" required="no">
     <!--- Log the exit page --->
     <cfquery datasource="#arguments.appScope.dsn#">
    Update logInfo
    Set
    exitPage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionScope.lastPage#">,
    logoutTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sessionScope.lasthit#">,
    hits = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sessionScope.hits#">
    Where sessionId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionScope.urlToken#">
    </cfquery>
</cffunction>


</cfcomponent>


