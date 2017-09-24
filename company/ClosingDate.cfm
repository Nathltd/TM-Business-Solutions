<!doctype html>
<html>
<head>
<title><cfoutput>Closing Date :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Closing Date</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.submit" default="">
<cfif isdefined (form.submit)>


<cfquery name="UpdateFinYear">
UPDATE ClosingDate
SET
ClosingDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(myDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE ID = 1
</cfquery>
<p>
<h2>Closing Date Updated!</h2>&nbsp;<a href="../Index/index.cfm">Home</a>
</p>
<cfelse>


<cfform action="#cgi.SCRIPT_NAME#">
<cfif #GetUserRoles()# is "Administrator" or #GetUserRoles()# is "Manager" or #GetUserRoles()# is "Alpha">

<table width="23%" cellpadding="3">
<tr>
<td width="30%"><div align="right">Current:</div></td>
<td width="70%"><cfinput name="current" id="current" tabindex="1" value="#dateformat(request.clsDate,"dd/mm/yyyy")#" readonly="yes"/>
</td>
</tr>
<tr>
<td><div align="right">New:</div></td>
<td><cfinput type="datefield"  mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Invoice Date" required="yes" message="Enter Invoice Date" autocomplete="off"/>
</td>
</tr>
<tr>
<td><div align="right"></div></td>
<td><div align="right"><cfinput type="submit" value="Submit" name="Submit"></div>
</td>
</tr>
</table>
</cfif>
</cfform>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>