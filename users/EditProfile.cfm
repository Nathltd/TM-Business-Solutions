<!doctype html>
<html>
<head>
<title><cfoutput>Edit Profile :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>

<div align="center">

<div id="Content">
<h4>Profile Modification</h4>
<div id="RightColumn">
<cfquery name="user">
SELECT * FROM Users
WHERE UserID = '#GetAuthUser()#'
</cfquery>
<cfif User.recordCount eq 1>
<cfif isdefined("form.submit")>

<cfquery>
UPDATE Users 
	SET 
    firstName = '#Trim(form.firstName)#',
    lastName = '#Trim(form.lastName)#',
    email = '#Trim(form.email)#',
    phone = '#Trim(form.phone)#',
	LastUpdated = '#dateformat(now(),"dd/mm/yyyy")#',
    Creator = '#GetAuthUser()#'
WHERE UserID = '#GetAuthUser()#'
</cfquery>

<p>
<cfoutput>Your Profile as <strong>#GetAuthUser()#</strong> has been updated successfully <a href="../index/index.cfm">click here</a> to continue </cfoutput>
</p>

<cfelse>
<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<br />

  <table cellpadding="5" class="font1">
  
  <tr>
  <td height="24"><div align="right">User ID:</div></td>
  <td><div align="left">
    <cfoutput> #GetAuthUser()# </cfoutput>
  </div></td>
  </tr>
    <tr>
  <td height="24"><div align="right">First Name:<font color="#FF0000">*</font></div></td>
  <td><div align="left">
    <cfinput name="firstName" type="text" id="firstName" required="yes" message="Enter First Name" value="#user.firstName#"/>
  </div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">Surname:<font color="#FF0000">*</font></div></td>
  <td><div align="left">
    <cfinput name="lastName" type="text" id="lastName" required="yes" message="Enter Surname" value="#user.lastName#"/>
  </div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">Phone:<font color="#FF0000">*</font></div></td>
  <td><div align="left">
    <cfinput name="phone" type="text" id="phone" required="yes" message="Enter Phone Number" value="#user.phone#" validate="integer"/>
  </div>
    </td>
    </tr>
  <tr>
  <td height="24"><div align="right">Email:</div></td>
  <td><div align="left">
    <cfinput name="email" type="text" id="email"  message="Enter Email Address" value="#user.email#" validate="email"/>
  </div>
    </td>
    </tr>
    <tr>
  <td height="24"><div align="right">Designation:</div></td>
  <td><div align="left">
    <cfoutput>#user.designation#</cfoutput>
  </div>
    </td>
    </tr>
 <tr>
  <td height="26" colspan="2" align="right"><div align="right">
    <cfinput type="submit" name="submit" value="Change">
  </div></td>
  </tr>
  </table>
  </cfform>
</cfif>

<cfelse>
<h1> Access Denied!<br />
You Are Not Authorised </h1><br />
</cfif>


</div>
</div>
</div>
</body>
</html>