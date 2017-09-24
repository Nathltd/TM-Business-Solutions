<!doctype html>
<html>
<head>
<title><cfoutput>Invoice Options :: #request.title#</cfoutput></title>
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
<h4>Invoice Options</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<p>
<cfparam name="form.Update" default="">
<cfparam name="form.Category" default="">
<cfparam name="form.Category2" default="">
<cfparam name="form.search" default="">
<cfset uploadFile = "#expandpath("/")##request.bkup#invoices\images">
<cfif isdefined (#form.update#)>

<cfif Len(Trim(form.FileContents)) GT 0>
<cffile action = "upload"  
        fileField = "FileContents"  
        destination = "#uploadFile#"  
        accept = "image/jpeg"  
        nameConflict = "overwrite">
<cfquery>
UPDATE invoiceOptions
SET logo = '#cffile.serverfile#',
    vat = '#Trim(form.vat)#',
    templateId = '#Trim(form.templateId)#',
    footer = '#Trim(form.footer)#',
    tin =  '#Trim(form.tin)#',
    creator = '#GetAuthUser()#',
    terms = '#Trim(form.terms)#',
    pr = '#Trim(form.pr)#',
    vendor = '#Trim(form.vendor)#',
    company = '#Trim(form.company)#',
    address2 = '#Trim(form.address2)#',
    formatid = '#Trim(form.formatid)#',
    dateUpdated = #CreateODBCDate(dateformat(Now(), "mm/dd/yyyy"))#
</cfquery>

<cfelse> 
        
<cfquery>
UPDATE invoiceOptions
SET vat = '#Trim(form.vat)#',
    templateId = '#Trim(form.templateId)#',
    footer = '#Trim(form.footer)#',
    tin =  '#Trim(form.tin)#',
    creator = '#GetAuthUser()#',
    terms = '#Trim(form.terms)#',
    pr = '#Trim(form.pr)#',
    vendor = '#Trim(form.vendor)#',
    company = '#Trim(form.company)#',
    address2 = '#Trim(form.address2)#',
    formatid = '#Trim(form.formatid)#',
    dateUpdated = #CreateODBCDate(dateformat(Now(), "mm/dd/yyyy"))#
</cfquery>
</cfif>

<h5> Invoice options updated!</h5>

<cfelse>
<cfquery name="getOptions" maxrows="1">
select logo, terms, footer, vat, tin, pr, vendor, company, address2, templateId, formatId
from invoiceOptions
</cfquery> 


<div class="font1">
<cfoutput>
<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table width="45%" cellspacing="5">
<tr>
<td valign="top"><div align="right">Company Name:</div></td>
<td><div align="left">
  <cfinput name="company" id="company" value="#Trim(getOptions.company)#" autocomplete="off" style="width:100%">
</div></td>
</tr>
<tr>
<td valign="top"><div align="right">Address2:</div></td>
<td><div align="left">
  <cfinput name="address2" id="address2" value="#Trim(getOptions.address2)#" autocomplete="off" style="width:100%">
</div></td>
</tr>
<tr>
<cfquery name="templ">
select * from invoiceTemplate
</cfquery>
<td valign="top"><div align="right">Template:</div></td>
<td><div align="left">
  <cfselect id="templateid" name="templateid"  style="width:100%">
  <cfloop query="templ">
  <option value="#tempId#" <cfif templ.tempId is getOptions.templateId>
    selected </cfif>>#tempName#</option>
    </cfloop>
    </cfselect>

</div></td>
</tr>
<tr>
<td valign="top"><div align="right">VAT No.:</div></td>
<td><div align="left">
  <cfinput name="vat" id="vat" value="#Trim(getOptions.vat)#" autocomplete="off" style="width:100%">
</div></td>
</tr>
<tr>
<td valign="top"><div align="right">TIN No.:</div></td>
<td><div align="left">
  <cfinput name="tin" id="tin" value="#Trim(getOptions.tin)#" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
<td valign="top"><div align="right">Vendor Code.:</div></td>
<td><div align="left">
  <cfinput name="vendor" id="vendor" value="#Trim(getOptions.vendor)#" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
<td valign="top"><div align="right">PR ##:</div></td>
<td><div align="left">
  <cfinput name="pr" id="pr" value="#Trim(getOptions.pr)#" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
<cfquery name="format">
select * from invoiceFormat
</cfquery>
<td valign="top"><div align="right">Print Format:</div></td>
<td><div align="left">
  <cfselect id="formatid" name="formatid"  style="width:100%">
  <cfloop query="format">
  <option value="#formatId#" <cfif format.formatId is getOptions.formatId>
    selected </cfif>>#formatId#</option>
    </cfloop>
    </cfselect>

</div></td>
</tr>
<tr>
<td valign="top"><div align="right">Terms:</div></td>
<td><div align="left">
  <cftextarea rows="5" name="terms" id="terms" style="width:100%">#Trim(getOptions.terms)#</cftextarea>
</div></td>
</tr>
<tr>
<td valign="top"><div align="right">Footer:</div></td>
<td><div align="left">
  <cftextarea rows="5" name="footer" id="footer" style="width:100%">#Trim(getOptions.footer)#</cftextarea>
</div></td>
</tr>
<tr>
<td><div align="right">Current Logo:</div></td>
<td><div align="left">
  <img id="image" src="../Invoices/images/#getOptions.logo#" alt="logo" height="60px" />
</div></td>
</tr>
<tr>
<td valign="top"><div align="right">New Logo:</div></td>
<td><div align="left">
  <cfinput name="FileContents" type="file">
  <cfinput name="FileContents2" type="hidden" value="#getOptions.logo#">  
</div></td>
</tr>
<tr>
  <td colspan="2" align="right"><div align="right">
    <cfinput name="Update" type="submit" value="Update" class="bold_10pt_Button">
  </div></td>
  </tr>
</table>
</cfform>
</cfoutput>
</div>
</cfif>
</cfif>
</p>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>