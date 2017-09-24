<cfscript>
// Login is always required. This example uses a single line of code. createObject("component","cfide.adminapi.administrator").login("admin");

// Instantiate the data source object. myObj = createObject("component","cfide.adminapi.datasource");

// Required arguments for a data source. stDSN = structNew();
stDSN.driver = "MSSQLServer";
stDSN.name="northwind_MSSQL";
stDSN.host = "127.0.0.1";
stDSN.port = "1433";
stDSN.database = "northwind";
stDSN.username = "sa";

// Optional and advanced arguments. stDSN.login_timeout = "29";
stDSN.timeout = "23";
stDSN.interval = 6;
stDSN.buffer = "64000";
stDSN.blob_buffer = "64000";
stDSN.setStringParameterAsUnicode = "false";
stDSN.description = "Northwind SQL Server";
stDSN.pooling = true;
stDSN.maxpooledstatements = 999;
stDSN.enableMaxConnections = "true";
stDSN.maxConnections = "299";
stDSN.enable_clob = true;
stDSN.enable_blob = true;
stDSN.disable = false;
stDSN.storedProc = true;
stDSN.alter = false;
stDSN.grant = true;
stDSN.select = true;
stDSN.update = true;
stDSN.create = true;
stDSN.delete = true;
stDSN.drop = false;
stDSN.revoke = false;

//Create a DSN. myObj.setMSSQL(argumentCollection=stDSN);
</cfscript>

<!---
Initialize the Admin API
--->
<cfscript>
   request.CFADMIN_PASSWORD = "myPassword";
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
   aDatasource.DATA_SRC_NAME = "oracleXE10g_adminapi_1";
   aDatasource.SRVR_NAME = "localhost";
   aDatasource.SID_NAME = "XE";
   aDatasource.PORT_NBR = 1521;
   aDatasource.CON_TMOT = 500;
   aDatasource.MAX_CON = 25;
   aDatasource.MAX_POOL_STAT = 250;
   aDatasource.APPL_USER_ID = "cfuser";
   unencryptedpassword = "coldfusion";
   disabled = false;
</cfscript>

<!---
Create a datasource with these settings, in this case its Oracle
--->
<cfset request.dsnObj.setOracle(
   name="#ucase(aDatasource.DATA_SRC_NAME)#",
   host="#aDatasource.SRVR_NAME#",
   port="#aDatasource.PORT_NBR#",
   sid="#aDatasource.SID_NAME#",
   username="#aDatasource.APPL_USER_ID#",
   password="#unencryptedpassword#",
   timeout="#aDatasource.CON_TMOT#",
   enablemaxconnections = true,
   maxconnections="#aDatasource.MAX_CON#",
   disable="#disabled#",
   maxPooledStatements="#aDatasource.MAX_POOL_STAT#")>

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
   <h3>Yipee! It verified :)</h3>
</cfif>