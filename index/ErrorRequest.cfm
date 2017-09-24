<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<title>Error!</title>
</head>

<body><br />


<div align="center">
<h1> Sorry, a technical problem occured!</h1>
<cfoutput>
Please<a href=""> try again </a>shortly.<br />
</cfoutput>
<br />
<br />
<br />



<!--- Display the actual error message --->
<blockquote>
<hr>
<table width="358">
<tr>
<td width="105" valign="top"><div align="right"><strong>Error Message:</strong></div></td><td width="241"><div align="left">#error.diagnostics#</div>
</td>
</tr>
<tr>
<tr>
<td valign="top"><div align="right"><strong>Time Occured:</strong></div></td><td><div align="left">#error.datetime#</div></td>
</tr>
<tr>
<td valign="top"><div align="right"><strong>Browser:</strong></div></td><td><div align="left">#error.browser#</div></td>
</tr>
</table>
<hr />
<!--- "mailto" link so user can send email --->
<font size="-3" face="Segoe UI">You can <a href="mailto:#error.mailTo#">send the webmaster an email</a>.</font><br /></blockquote>
<br />
<cftry>

<cfcatch type="any">
<h3>An Error Has Occured</b></h3>
<cfoutput>

<!--- and the diagnostic message from the ColdFusion server --->

<p>Type = #CFCATCH.TYPE# </p>
<p>Message = #cfcatch.detail#</p>


<cfloop index = i from = 1 to = #ArrayLen(CFCATCH.TAGCONTEXT)#>
<cfset sCurrent = #CFCATCH.TAGCONTEXT[i]#>

Occured on Line #sCurrent["LINE"]#, Column #sCurrent["COLUMN"]#
</cfloop>
</cfoutput>
</cfcatch>


</cftry>
</div>
</body>
</html>