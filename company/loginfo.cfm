<!doctype html>
<html>
<head>
<title><cfoutput>Log Info  :: #request.title#</cfoutput></title>
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
<cfif #GetUserRoles()# is 'Alpha' or #GetUserRoles()# is 'Administrator'>

<h4>Log In Activities (Last 200)</h4>
<div id="RightColumn">


<cfquery name="loginfo" maxrows="200">
select id, userId, entryPage, exitPage, loginTime, logoutTime, hits
from loginfo
where exitPage <> ''
order by id desc
</cfquery>
<cfset info = GetTimeZoneInfo()> 


<cfoutput>
<table width="90%" cellpadding="5" cellspacing="0">
<tr>
<td width="5%"><div align="left"><strong> Date:</strong></div></td>
<td width="10%"><div align="left"><strong>User Id</strong></div></td>
<td width="20%"><div align="left"><strong>Entry Page</strong></div></td>
<td width="10%"><div align="left"><strong>Login Time</strong></div></td>
<td width="10%"><div align="left"><strong>Logout Time</strong></div></td>
<td width="5%"><div align="right"><strong>Duration</strong></div></td>
<td width="5%"><div align="right"><strong> Hits</strong></div></td>
</tr>
<cfloop query="loginfo">
<tr>
<td ><div align="left">#dateformat(loginTime,"dd/mm/yyyy")#</div></td>
<td><div align="left">#userId#</div></td>
<td><div align="left">#left(entryPage,35)#</div></td>
<cfset info = GetTimeZoneInfo()> 
<cfset setHour =  #info.utcHourOffset#+1>
<cfset type = 'h'>
<cfset login = #DateAdd(type,setHour,loginTime)#>
<cfset logout = #DateAdd(type,setHour,logoutTime)#>
<td><div align="left">#timeformat(login,"HH:MM:SS")#</div></td>
<td><div align="left">#timeformat(logout,"HH:MM:SS")#</div></td>
<cfset login = #loginTime#>
<cfset logOut = #logoutTime#>
<cfset type = "n">
<cfif logout is "">
<cfset logout = #loginTime#>
</cfif>
<cfset logduration =#datediff(type,login,logOut)#>
<cfif logduration lt 1>
<cfset type = "s">
</cfif>
<td><div align="right">#datediff(type,login,logOut)#&nbsp;<cfif logduration lt 1>s<cfelse>m</cfif></div></td>
<td><div align="right">#hits#</div></td>
</tr>
</cfloop>
</table>
</cfoutput>

</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
<cfelse>
<h1> Unauthrised Zone </h1>
</cfif>
</div>
</div>
</body>
</html>