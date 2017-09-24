<!doctype html>
<html>
<head>
<title><cfoutput>New User :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="../css/styles2.css">
</head>


<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>New User</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is not "Administrator" and #GetUserRoles()# is not "Alpha" ><br />
<br />
<br />


<h1> Access Denied!<br />
You Are Not Authorised </h1><br />
<br />

<a href="../index/index.cfm">click here</a> to continue
<cfabort>
</cfif>
<cfquery name="UsersCount">
Select ID from Users
</cfquery>
<cfif #GetUserRoles()# is not "Alpha" >
<cfif #UsersCount.RecordCount# gt 4 >
<h1> Reached Maximum Users!</h1>
<cfabort>
</cfif>
</cfif>
<cfif isdefined("form.submit")>
<cfquery>
INSERT INTO Users (FirstName, LastName, Designation, UserID, PWord, LastUpdated, Creator, BranchID)
VALUES (<cfqueryparam cfsqltype="cf_sql_char" maxlength="15" value="#form.firstName#">, <cfqueryparam cfsqltype="cf_sql_char" maxlength="15" value="#form.LastName#">, <cfqueryparam cfsqltype="cf_sql_char" maxlength="15" value="#form.staffDesignation#">, <cfqueryparam cfsqltype="cf_sql_char" maxlength="15" value="#form.staffId#">, <cfqueryparam cfsqltype="cf_sql_char" maxlength="15" value="#form.Password1#">,<cfqueryparam cfsqltype="cf_sql_date" maxlength="15" value="#dateformat(now(),"mm/dd/yyyy")#">, '#GetAuthUser()#', '#form.BranchID#') 
</cfquery>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.FirstName# #form.LastName# </strong></font>has been created successfully <a href="newUser.cfm">click here</a> to continue </cfoutput>
</div>
<cfelse>
  <cfquery name="Branches">
SELECT BranchID
FROM Branches 
</cfquery>
  <cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data" autocomplete="off">
<br />

  <table cellpadding="5" class="font1">
  <tr>
  <td height="24"><div align="right">First Name:</div></td>
  <td><div align="left">
    <cfinput type="text" name="firstName" class="bold_10pt_black" required="yes">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Last Name:</div></td>
  <td><div align="left">
    <cfinput type="text" name="lastName" class="bold_10pt_black">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Designation:</div></td>
  <td><div align="left">
    <cfselect name="staffDesignation" required="yes" bind="cfc:#request.cfc#cfc.bind.getDesignation()" display="DesignationID" value="DesignationID" bindonload="yes" class="bold_10pt_black">      
      </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Branch:</div></td>
  <td><div align="left">
    <cfselect name="BranchID" id="BranchID" required="yes" class="bold_10pt_black" message="Choose Location" bind="cfc:#request.cfc#cfc.bind.getBranches()" display="BranchID" value="BranchID" bindonload="yes" tabindex="4"> </cfselect>      
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">User ID:</div></td>
  <td><div align="left">
    <cfinput type="text" name="staffID" size="8" class="bold_10pt_black">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Password:</div></td>
  <td><div align="left">
    <cfinput name="password1" type="password" id="password1" size="10" class="bold_10pt_black">
 </div>
    </td>
    </tr>
 
  <td height="26" colspan="2" align="right"><div align="right">
    <cfinput type="submit" name="submit" value="Create">
  </div></td>
  </tr>
  </table>
  </cfform>
</cfif>

</div>
</div>
</div>
</body>
</html>