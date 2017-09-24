<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Russ Swift (rswift220@yahoo.com) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
function validatePwd() {
var invalid = " "; // Invalid character is a space
var minLength = 6; // Minimum length
var pw1 = document.form.password2.value;
var pw2 = document.form.password3.value;
// check for a value in both fields.
if (pw1 == '' || pw2 == '') {
alert('Please enter your password twice.');
return false;
}
// check for minimum length
if (document.form.password2.value.length < minLength) {
alert('Your password must be at least ' + minLength + ' characters long. Try again.');
return false;
}
// check for spaces
if (pw1 != pw2) {
alert ("You did not enter the same new password twice. Please re-enter your password.");
return false;
}
else {
return true;
      }
   }
//  End -->
</script>


</head>


<body>
<cfoutput>
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
<cfset form.password2 = #encrypt(form.password2,"SHA-512")#>
<cfquery>
UPDATE Users 
	SET PWord = '#form.password2#',
    	LastUpdated = '#dateformat(now(),"dd/mm/yyyy")#',
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
<a href="#cgi.SCRIPT_NAME#">Try again</a>
</cfif>
<cfelse>
<cfform action="#cgi.SCRIPT_NAME#" onSubmit="return validatePwd()" enctype="multipart/form-data">
<br />

  <table cellpadding="5" class="font1">
  
  <tr>
  <td height="24"><div align="right">User ID:</div></td>
  <td><div align="left">
    <cfoutput> #GetAuthUser()# </cfoutput>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Current Password:</div></td>
  <td><div align="left"><span id="sprypassword1">
    <cfinput name="password1" type="password" id="password1" size="10" value=" " required="yes" message="Enter Current Password"/>
  </span><font color="##FF0000">*</font></div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">New Password:</div></td>
  <td><div align="left"><span id="spryconfirm1">
    <cfinput type="password" name="password2" id="password2" size="10" required="yes" message="Enter New Password" />
  </span><font color="##FF0000">*</font></div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">Confirm Password:</div></td>
  <td><div align="left"><span id="spryconfirm1">
    <cfinput type="password" name="password3" id="password3" size="10" required="yes" message="Enter New Password" />
  </span><font color="##FF0000">*</font></div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">Phone:</div></td>
  <td><div align="left"><span id="spryconfirm1">
    <cfinput type="text" name="phone" id="phone" size="10" required="yes" message="Enter Your Phone Number" />
  </span><font color="##FF0000">*</font></div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">Email:</div></td>
  <td><div align="left"><span id="spryconfirm1">
    <cfinput type="text" name="email" id="email" size="10" validate="email" required="yes" message="Enter Your Email Address" />
  </span><font color="##FF0000">*</font></div>
    </td>
    </tr>
 
  <td height="26" colspan="2" align="right"><div align="right">
    <cfinput type="submit" name="submit" value="Change">
  </div></td>
  </tr>
  </table>
  </cfform>
</cfif>

</div>
</div>
</div>
</cfoutput>
</body>
</html>