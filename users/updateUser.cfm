<!doctype html>
<html>
<head>
<title><cfoutput>User Modification :: #request.title#</cfoutput></title>
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
<h4>User Modification</h4>

<div id="RightColumn">

<cfif #GetUserRoles()# is not "Administrator" and #GetUserRoles()# is not "Alpha" ><br />
<br />
<br />


<h1> Access Denied!<br />
You Are Not Authorised </h1><br />
<br />

<a href="../index/index.cfm">click here</a> to continue
<cfabort>
</cfif>
<cfparam name="form.Update" default="">
<cfparam name="form.UserID" default="">
<cfparam name="form.UserID2" default="">
<cfparam name="form.search" default="">

<cfif isdefined (#form.update#)>
<cftransaction>
<cfquery datasource="#request.dsn#">
UPDATE Users
SET LastUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
	Creator = '#GetAuthUser()#',
    Designation = '#Trim(form.Designation)#',
    UserID = '#Trim(form.UserID2)#',
    LastName = '#Trim(form.LastName)#',
    FirstName = '#Trim(form.FirstName)#',
    BranchID = '#Trim(form.BranchID)#'    
WHERE UserID='#form.UserID#'
</cfquery>
</cftransaction>
<p>&nbsp;</p>
 <cfoutput>#form.UserID2#</cfoutput> 
 Has been updated. Click <a href="updateUser.cfm">here to update</a> another User
 <p>&nbsp;</p>
<cfelseif isdefined (#form.search#)>
<cfquery name="getUser" datasource="#request.dsn#">
SELECT FirstName, LastName, Designation, UserID, BranchID
FROM Users
WHERE UserID = <cfqueryparam value="#Trim(form.UserID)#" cfsqltype="cf_sql_clob"> 
</cfquery>
<cfquery name="getDesignation" datasource="#request.dsn#">
SELECT DesignationID
FROM Designation
WHERE DesignationID <> 'Alpha'
ORDER BY DesignationID
</cfquery>
<div class="font1">
<p><strong>Make Adjustments</strong></p>
<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellspacing="5" class="font1">
<tr>
<td><div align="left">First Name:</div></td>
<td><div align="left">
  <cfinput name="FirstName" id="FirstName" value="#Trim(getUser.FirstName)#" class="bold_10pt_black" required="yes" message="Enter First Name">

</div></td>
</tr>
<tr>
<td><div align="left">Last Name:</div></td>
<td><div align="left">
  <cfinput name="LastName" id="LastName" value="#Trim(getUser.LastName)#" class="bold_10pt_black" message="Enter Last Name">
</div></td>
</tr>
<tr>
<td><div align="left"> Designation:</div></td>
<td><div align="left">
  <cfselect name="Designation" required="yes" class="bold_10pt_black" message="Enter Designation">
    <cfoutput query="getDesignation">
      <option value="#Trim(DesignationID)#" <cfif getDesignation.DesignationID is getUser.Designation>
    selected </cfif>>#DesignationID#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<tr>
<td><div align="left">User ID:</div></td>
<td><div align="left">
  <cfinput name="UserID2" value="#Trim(getUser.UserID)#" type="text" required="yes" message="Enter User ID" class="bold_10pt_black">
      <cfinput name="UserID" id="UserID" type="hidden" value="#Trim(getUser.UserID)#">
</div></td>
</tr>
<tr>
<cfquery name="getBranch" datasource="#request.dsn#">
SELECT BranchID
FROM Branches
ORDER BY BranchID
</cfquery>
<td><div align="left">Location:</div></td>
<td><div align="left">
  <cfselect name="BranchID" required="yes" class="bold_10pt_black" message="Select a Branch">
    <cfoutput query="getBranch">
      <option value="#Trim(BranchID)#" <cfif getBranch.BranchID is getUser.BranchID>
    selected </cfif>>#BranchID#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<td colspan="2" align="right"><div align="right">
  <cfinput name="Update" type="submit" value="Update" class="bold_10pt_Button">
</div></td>
</table>
</cfform>
</div>
<cfelse>
<div class="font2">
<p><strong>Select User to modify</strong></p>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5" class="font1">
<tr>
<td><div align="right">User ID:</div></td>
<td><div align="left">
  <cfselect name="UserID" class="bold_10pt_black"  bind="cfc:#request.cfc#cfc.bind.getUsers()" display="UserID" value="UserID" bindonload="yes" tabindex="5">
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td colspan="2" align="right"><div align="right">
      <cfinput type="submit" name="Search" value="Search">
    </div></td>
    </tr>
  </table>
    </div>
  </cfform>
  </div>
</cfif>

</div>
</div>
</div>
</body>
</html>