<!doctype html>
<html>
<head>
<title><cfoutput>Password Reset :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Password Reset</h4>

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
<cfparam name="form.Update" default="">
<cfparam name="form.UserID" default="">
<cfparam name="form.search" default="">
<cfparam name="form.Reset" default="">

<cfif isdefined (#form.Reset#)>
<cfquery name="user">
select pWord from users
where userid = '#GetAuthUser()#'
</cfquery>
<cfif #user.pWord# neq "#form.adminPass#">
<h3> Invalid Administrator Password, Access Denied!</h3><br />
<cfoutput><a href="#cgi.SCRIPT_NAME#">Try Again</a></cfoutput>
<cfabort>
</cfif>
<cftransaction>
<cfquery datasource="#request.dsn#">
UPDATE Users
SET LastUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
    pWord = '#Trim(form.password)#'    
WHERE UserID='#form.UserID#'
</cfquery>
</cftransaction>
<p>&nbsp;</p>
 <cfoutput>#form.UserID# Password has been reset. Click <a href="#cgi.SCRIPT_NAME#">here to reset</a> another User</cfoutput>
 <p>&nbsp;</p>
<cfelseif isdefined (#form.search#)>
<cfquery name="getUser">
SELECT UserID, pWord
FROM Users
WHERE UserID = <cfqueryparam value="#Trim(form.UserID)#" cfsqltype="cf_sql_clob"> 
</cfquery>
<div>
<p><strong>Reset Passord</strong></p>
<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellspacing="5" class="font1">
<tr>
<td><div align="left">User Id:</div></td>
<td><div align="left">
  <cfinput name="userId" id="userId" value="#Trim(getUser.userId)#" required="yes" message="Enter First Name" readonly="yes">

</div></td>
<td>&nbsp;</td>
</tr>
<tr>
<td><div align="left">Admin Passord:</div></td>
<td><div align="left">
  <cfinput type="password" name="adminPass" id="adminPass" required="yes" message="Enter Admin Password">
</div></td>
<td>&nbsp;</td>
</tr>
<tr>
<td><div align="left">Reset Passord:</div></td>
<td><div align="left">
<cfset myDate= #timeformat(now(),"hh:ss")#>
<cfset pword = #encrypt(myDate,"SHA")#>
  <cfinput name="password" id="password" value="#pword#" required="yes" readonly="yes">
</div></td>
<td><font color="#FF0000" size="2">Please, write out this password</font></td>
</tr>
<tr>
  <td></td>
<td align="right"><div align="right">
  <cfinput name="Reset" type="submit" value="Reset" class="bold_10pt_Button">
  </div></td>
<td align="right">&nbsp;</td>
</table>
</cfform>
</div>
<cfelse>
<div class="font2">
<p><strong>Select User to modify</strong></p>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5" class="font1">
<tr>
<td><div align="right">User ID:</div></td>
<td><div align="left">
  <cfselect name="UserID" class="bold_10pt_black"  bind="cfc:#request.cfc#cfc.bind.getUsers()" display="UserID" value="UserID" bindonload="yes" tabindex="5">
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td colspan="2" align="right"><div align="right">
      <cfinput type="submit" name="Search" value="Search">
    </div></td>
    </tr>
  </table>
    </div>
  </cfform>
  </div>
</cfif>

</div>
</div>
</div>
</body>
</html>