

<!---
Initialize the Admin API
--->
<cfscript>
   request.CFADMIN_PASSWORD = "sandra";
   request.adminObj = createObject("Component", "cfide.adminapi.administrator");
   request.adminObj.login(request.CFADMIN_PASSWORD);
   request.dsnObj = createObject("component", "cfide.adminapi.datasource");
</cfscript>

<!---
Set the datasource configuration settings.
Note that the timeout below is actually set in seconds, although the Admin API CFC reports it as minutes incorrectly
--->
<cfscript>
   aDatasource = structNew();
   aDatasource.DATA_SRC_NAME = "TM001";
   aDatasource.FILE = "C:\inetpub\wwwroot\nathconcept\db\tm001.mdb";
   aDatasource.DRIVER = "MSAccessJet";
   aDatasource.DSN = "TM001";
   aDatasource.CLASS = "com.inzoom.jdbcado.Driver";
   aDatasource.DESCRIPTION = "TM Online Data Source";
   aDatasource.PASSWORD = "sandra";
   aDatasource.APPL_USER_ID = "cfuser";
   unencryptedpassword = "coldfusion";
   disabled = false;
</cfscript>

<!---
Create a datasource with these settings, in this case its Oracle
--->
   
   <cfset request.dsnObj.setMSAccessUnicode ( 
	name="#ucase(aDatasource.DATA_SRC_NAME)#",
	databasefile="#aDatasource.FILE#", 
	originaldsn="#aDatasource.DSN#", 
	driver="#aDatasource.DRIVER#",
	password="",
	class="#aDatasource.CLASS#",
	description="#aDatasource.DESCRIPTION#")>

<!---
Verify datasource using Admin API
--->
<cfset verified = request.dsnObj.verifyDSN(aDatasource.DATA_SRC_NAME)>

<!---
If unverified, attempt to verify via ServiceFactory to get error detail
--->
<cfif not verified>
   <cftry>
      <cfscript>
       factory = createObject("java", "coldfusion.server.ServiceFactory");
       request.sqlexecutive = factory.getDataSourceService();
       success = request.sqlexecutive.verifyDatasource(aDatasource.DATA_SRC_NAME);
      </cfscript>
   <cfcatch>
      <!--- Print the reason verification failed --->
      <cfdump var="#cfcatch#" label="ERRORS">
   </cfcatch>
   </cftry>
<cfelse>
   <h3>TM Online Components Installed and Verified</h3>
   <h3><!---<cfoutput>#ucase(aDatasource.DATA_SRC_NAME)# Data Source Created and Verified!</cfoutput>---></h3>
</cfif>