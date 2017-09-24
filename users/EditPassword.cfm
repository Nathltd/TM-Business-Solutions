<!doctype html>
<html>
<head>
<title><cfoutput>Edit Profile :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="../css/styles2.css">

<script type="text/javascript">
$(document).ready(function(){
	$('#submit').click(function(event) {
		var pw1 = $('#password2').val();
		var pw2 = $('#password3').val();

// check for a value in both fields.
if (pw1 != pw2) {
alert ("Please verify your password");
return false;
  }
  if (pw1 == '' || pw2 == '') {
alert('Please enter your password twice.');
return false;
}
});
});
</script>

</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Pasword Modification</h4>
<div id="RightColumn">

<cfif isdefined("form.submit")>
<cfquery name="user">
SELECT * FROM Users
WHERE UserID = '#GetAuthUser()#' AND PWord = '#Trim(form.password1)#'
</cfquery>
<cfif User.recordCount eq 1>
<cfquery>
UPDATE Users 
	SET PWord = '#Trim(form.password2)#',
    	LastUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
    	Creator = '#GetAuthUser()#'
WHERE UserID = '#GetAuthUser()#' AND PWord = '#Trim(form.password1)#'
</cfquery>

<p>
<cfoutput>Password for User: <strong>#GetAuthUser()#</strong> has been changed successfully <a href="../index/index.cfm">click here</a> to continue </cfoutput>
</p>

<cfelse>
<br />
<br />
<br />

<strong>Current Password Incorrect!</strong>
<br />
<br />
<a href="EditPassword.cfm">Try again</a>
</cfif>
<cfelse>
<cfform action="EditPassword.cfm" enctype="multipart/form-data"  onSubmit="return validatePwd()">
<br />

  <table cellpadding="5">
  
  <tr>
  <td width="161" height="24"><div align="right">User ID:</div></td>
  <td width="157"><div align="left">
    <cfoutput> #GetAuthUser()# </cfoutput>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Current Password:</div></td>
  <td><div align="left">
    <cfinput name="password1" type="password" id="password1"  value=" " required="yes" message="Enter Current Password" />
  </div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">New Password:</div></td>
  <td><div align="left">
    <cfinput type="password" name="password2" id="password2" required="yes" message="Enter New Password" placeholder="Enter New Password" />
  </div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">Confirm New Password:</div></td>
  <td><div align="left">
    <cfinput type="password" name="password3" id="password3"  required="yes" message="Confirm New Password" placeholder="Confirm New Password"/>
  </div>
    </td>
    </tr>
 
  <td height="26" colspan="2" align="right"><div align="right">
    <cfinput type="submit" name="submit" id="submit" value="Change">
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