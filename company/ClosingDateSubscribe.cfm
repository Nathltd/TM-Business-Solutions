<!doctype html>
<html>
<head>
<title><cfoutput>Subscription Closing Date  :: #request.title#</cfoutput></title>
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
<cfif #GetUserRoles()# is not  'Alpha'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.submit" default="">
<cfif isdefined (form.submit)>


<cfquery name="UpdateFinYear">
UPDATE ClosingDateSubscribe
SET
ClosingDate =
<cfqueryparam value="#lsDateFormat(CreateODBCDate(myDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE ID = 1
</cfquery>
<p>
<h2>Subscription Date Updated!</h2>&nbsp;<a href="../Index/index.cfm">Home</a>
</p>
<cfelse>


<cfform action="#cgi.SCRIPT_NAME#">
<cfif #GetUserRoles()# is "Alpha">

<table width="23%" cellpadding="2">
<tr>
<td>Current:</td>
<td><cfinput name="current" style="width:100%" id="current" tabindex="1" value="#dateformat(request.clsDateSubscribe,"dd/mm/yyyy")#" readonly="yes"/>
</td>
</tr>
<tr>
<td>New:</td>
<td><cfinput type="datefield" style="width:100%" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Invoice Date" required="yes" message="Enter Invoice Date" autocomplete="off"/>
</td>
</tr>
<tr>
<td></td>
<td align="right"><cfinput type="submit" value="Submit" name="Submit">
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
