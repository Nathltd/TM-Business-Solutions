<!doctype html>
<html>
<head>
<title><cfoutput>Call Back ::: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkSales.js" language="javascript" type="application/javascript"></script>

</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Invoice Modification</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is not'alpha' and #GetUserRoles()# is not'administrator' and #GetUserRoles()# is not'manager'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif IsDefined("form.submit") is True>
<cfquery name="check">
select moduleId from modifyList
where status = 'active' and moduleid = #form.moduleId# and moduleType = 'invoice'
</cfquery>
<cfif #check.recordCount# gt 0>
<cfoutput><h3>Invoice No.#form.moduleId# Already in queue</h3></cfoutput>
<cfabort>
</cfif>

<cfquery name="addToModifyList">
INSERT into modifyList (moduleId,authorised,comment,moduleType) 
    VALUES ('#form.moduleId#','#GetAuthUser()#','#form.comment#','invoice')
</cfquery>
<p>

<cfoutput> Invoice No. <strong>#form.moduleId#</strong> have been Added to the Modify List<a href="#cgi.SCRIPT_NAME#"> Add Another </a></cfoutput>

</p>
<cfelse>




<br />

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="29%">
 <tr>
<td width="49%" align="right" >Invoice No:</td>
<td width="51%" align="left" >
  <cfinput type="text" name="moduleId" id="moduleId" required="yes" message="Enter a Valid Number">
<span id="msg">&nbsp;Invoice number does not exist</span>
</td>
    </tr>
    <tr>
<td  align="right" >Comment:</td>
<td align="left" >
  <cftextarea name="comment" required="yes" message="Enter Comment"></cftextarea>
</td>
    </tr>
    <tr>
    <td colspan="2" align="right">
      <div align="right">
        <cfinput type="submit" name="submit" id="submit" value="Submit">
      </div></td>
    </tr>
  </table>
  </cfform>
</cfif>
</cfif>
</div>
</div>
</div>
</body>