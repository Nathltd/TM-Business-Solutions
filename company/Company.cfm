<!doctype html>
<html>
<head>
<title><cfoutput>Company Profile  :: #request.title#</cfoutput></title>
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
<h4>Company Profile</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha'>
<h1> Unauthrised Zone </h1>
<cfelse>
<cfset uploadFile = "#expandpath("/")##request.bkup#invoices\images">
<cfif isdefined("form.submit")>
<cfif Len(Trim(form.FileContents)) GT 0>
<cffile action = "upload"  
        fileField = "FileContents"  
        destination = "#uploadFile#"  
        accept = "image/jpeg"  
        nameConflict = "overwrite">

<cfquery>
UPDATE Company
SET logo = '#cffile.serverfile#',
	CompanyName = '#Trim(form.CompanyName)#',
	Creator = '#GetAuthUser()#',
    Address = '#Trim(form.Address)#',
    Address2 = '#Trim(form.Address2)#',
    Phone = '#Trim(form.Phone)#',
    Phone2 = '#Trim(form.Phone2)#',
    Phone3 = '#Trim(form.Phone3)#',
    EmailAddress = '#Trim(form.Email)#'
    WHERE ID=1
</cfquery>

<cfelse>
<cfquery>
UPDATE Company
SET CompanyName = '#Trim(form.CompanyName)#',
	Creator = '#GetAuthUser()#',
    Address = '#Trim(form.Address)#',
    Address2 = '#Trim(form.Address2)#',
    Phone = '#Trim(form.Phone)#',
    Phone2 = '#Trim(form.Phone2)#',
    Phone3 = '#Trim(form.Phone3)#',
    EmailAddress = '#Trim(form.Email)#'
    WHERE ID=1
</cfquery>
</cfif>



<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.CompanyName# </strong></font>has been Updated successfully <a href="../Index/index.cfm">click here</a> to continue </cfoutput>
</div>
<cfelse>

<cfquery name="Company">
SELECT *
FROM COMPANY
WHERE ID = 1
</cfquery>


<div>

<cfform action="Company.cfm" enctype="multipart/form-data">

<table cellpadding="5" width="33%">
<tr>
<td width="37%" height="24" valign="top">Company Name:</td>
<td width="63%"><div align="left">
  <cfinput type="text" name="CompanyName" value="#company.companyName#" id="CompanyName" style="width:100%" required="yes">
</div></td>
</tr>
<tr>
<td valign="top">Address:</td>
<td>
  <cftextarea name="Address" rows="3" value="#company.Address#" required="yes" richtext="no" style="width:100%"></cftextarea>
</td>
</tr>
<tr>
<td valign="top">Address2:</td>
<td>
  <cftextarea name="Address2" rows="3" value="#company.Address2#" richtext="no" style="width:100%"></cftextarea>
</td>
</tr>
<tr>
<td valign="top">Phone:</td>
<td>
  <cfinput type="text" name="Phone" id="Phone" value="#company.Phone#" required="yes"  style="width:100%">
</td>
</tr>
<tr>
<td valign="top">Phone 2:</td>
<td>
  <cfinput type="text" name="Phone2" id="Phone2" value="#company.Phone2#"  style="width:100%">
</td>
</tr>
<tr>
<td valign="top">Phone 3:</td>
<td>
  <cfinput type="text" name="Phone3" id="Phone3" value="#company.Phone3#"  style="width:100%">
</td>
</tr>
<tr>
<td>Email:</td>
<td>
  <cfinput type="text" name="Email" id="Email" value="#company.EmailAddress#" style="width:100%">
</td>
</tr>
<tr>
<td>New Logo:</div></td>
<td><div align="left">
  <cfinput name="FileContents" type="file">
  <cfinput name="FileContents2" type="hidden" value="#company.logo#">  
</div></td>
</tr>
<tr>
<td height="26" colspan="2" align="right">
	<cfif #company.CompanyName# is "Default">
    <cfset Submit = "Create">
    <cfelse>
    <cfset Submit = "Update">
    </cfif>
  <cfinput type="submit" name="submit" value="#Submit#">
</td>
</tr>
</table>
</cfform>

</div>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>