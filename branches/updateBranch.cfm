<!doctype html>
<html>
<head>
<title><cfoutput>Branch Modification :: #request.title#</cfoutput></title>
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
<h4>Branch Modification</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.Update" default="">
<cfparam name="form.BranchID" default="">
<cfparam name="form.BranchID2" default="">
<cfparam name="form.search" default="">

<cfquery name="getBranch" datasource="#request.dsn#">
SELECT BranchID
FROM Branches
ORDER BY BranchID ASC
</cfquery>


<cfif isdefined (#form.update#)>

<cftransaction>
<cfquery>
UPDATE Branches
SET BranchType = '#Trim(form.BranchType)#',
	Creator = '#GetAuthUser()#',
    Description = '#Trim(form.BranchDesc)#',
    BranchID = '#Trim(form.BranchID2)#',
    DateUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE BranchID='#form.BranchID#'
</cfquery>

<cfquery>
UPDATE Accounts
SET AccountID = '#Trim(form.BranchID2)#',
	Creator = '#GetAuthUser()#',
    DateUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
WHERE AccountID='#form.BranchID#'
</cfquery>
</cftransaction>

<br />

 <cfoutput>#form.BranchID2#</cfoutput> Has been updated. Click <a href="updateBranch.cfm">here to update</a> another item
<br />

<cfelseif isdefined (#form.search#)>
<cfquery name="getBranch" datasource="#request.dsn#">
SELECT BranchID, BranchType, Description, Creator
FROM Branches
WHERE BranchID = <cfqueryparam value="#form.BranchID#" cfsqltype="cf_sql_clob"> 
</cfquery>
<cfquery name="getAllBranch" datasource="#request.dsn#">
SELECT BranchType
FROM BranchType
ORDER BY BranchType
</cfquery>
<div class="font1">

<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellpadding="2" width="30%">
<tr>
<td><div align="right">Branch Name:</div></td>
<td><div align="left">
  <cfinput name="BranchID2" id="BranchID2" value="#Trim(getBranch.BranchID)#" style="width:100%" required="yes" message="Enter Branch Name">
    <cfinput name="BranchID" id="BranchID" type="hidden" value="#Trim(getBranch.BranchID)#">
</div></td>
</tr>
<tr>
<td><div align="right">Category:</div></td>
<td><div align="left">
  <cfselect name="BranchType" style="width:100%" required="yes">
    <cfoutput query="getAllBranch">
      <option value="#Trim(BranchType)#" <cfif getAllBranch.BranchType is getBranch.BranchType>
    selected </cfif>>#BranchType#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<tr>
<td><div align="right">Description:</div></td>
<td><div align="left">
  <cfinput name="BranchDesc" id="BranchDesc" value="#Trim(getBranch.Description)#" required="yes" style="width:100%" autocomplete="off">
</div></td>
</tr>
<tr>
<td></td>
<td align="right"><div align="right">
  <cfinput name="Update" type="submit" value="Update">
</div></td>
</table>
</cfform>
</div>
<cfelse>
<div>
<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5">
<tr>
<td><div align="right">Branch Name:</div></td>
<td><div align="left">
  <cfselect name="BranchID" required="yes" message="Choose Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes">
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td></td>
    <td align="right"><div align="right">
      <cfinput type="submit" name="Search" value="Search">
    </div></td>
    </tr>
  </table>
    </div>
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