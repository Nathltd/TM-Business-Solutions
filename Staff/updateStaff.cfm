<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Staff Modification</h4>

<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.Update" default="">
<cfparam name="form.StaffID" default="">
<cfparam name="form.StaffID2" default="">
<cfparam name="form.search" default="">

<cfif isdefined (#form.update#)>
<cftransaction>
<cfquery datasource="#request.dsn#">
UPDATE Staff
SET BranchID = '#Trim(form.BranchID)#',
	Creator = '#GetAuthUser()#',
    Designation = '#Trim(form.Designation)#',
    StaffID = '#Trim(form.StaffID2)#',
    LastName = '#Trim(form.LastName)#',
    FirstName = '#Trim(form.FirstName)#',
    Phone = '#Trim(form.Phone)#'
WHERE StaffID='#form.StaffID#'
</cfquery>
</cftransaction>
<p>&nbsp;</p>
 <cfoutput>#form.StaffID2#</cfoutput> Has been updated. Click <a href="updateStaff.cfm">here to update</a> another Staff
<p>&nbsp;</p>
<cfelseif isdefined (#form.search#)>
<cfquery name="getStaff" datasource="#request.dsn#">
SELECT FirstName, LastName, Designation, StaffID, BranchID, Phone
FROM Staff
WHERE StaffID = <cfqueryparam value="#Trim(form.StaffID)#" cfsqltype="cf_sql_clob"> 
</cfquery>
<cfquery name="getDesignation" datasource="#request.dsn#">
SELECT DesignationID
FROM Designation
ORDER BY DesignationID
</cfquery>
<cfquery name="getBranch" datasource="#request.dsn#">
SELECT BranchID
FROM Branches
ORDER BY BranchID
</cfquery>
<div class="font1">
<p><strong>Make Adjustments</strong></p>
<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellspacing="5" class="font1">
<tr>
<td><div align="left">First Name:</div></td>
<td><div align="left">
  <cfinput name="FirstName" id="FirstName" value="#Trim(getStaff.FirstName)#" class="bold_10pt_black" required="yes" message="Enter First Name">

</div></td>
</tr>
<tr>
<td><div align="left">Last Name:</div></td>
<td><div align="left">
  <cfinput name="LastName" id="LastName" value="#Trim(getStaff.LastName)#" class="bold_10pt_black" message="Enter Last Name">
</div></td>
</tr>
<tr>
<td><div align="left"> Designation:</div></td>
<td><div align="left">
  <cfselect name="Designation" required="yes" class="bold_10pt_black" message="Enter Designation">
    <cfoutput query="getDesignation">
      <option value="#Trim(DesignationID)#" <cfif getDesignation.DesignationID is getStaff.Designation>
    selected </cfif>>#DesignationID#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<tr>
<td><div align="left">Staff ID:</div></td>
<td><div align="left">
  <cfinput name="StaffID2" value="#Trim(getStaff.StaffID)#" type="text" required="yes" message="Enter Staff ID" class="bold_10pt_black">
      <cfinput name="StaffID" id="StaffID" type="hidden" value="#Trim(getStaff.StaffID)#">
</div></td>
</tr>
<tr>
<td><div align="left">Location:</div></td>
<td><div align="left">
  <cfselect name="BranchID" required="yes" class="bold_10pt_black" message="Select a Branch">
    <cfoutput query="getBranch">
      <option value="#Trim(BranchID)#" <cfif getBranch.BranchID is getStaff.BranchID>
    selected </cfif>>#BranchID#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<tr>
  <td align="right"><div align="left">Phone:</div></td>
  <td align="right"><cfinput name="Phone" value="#Trim(getStaff.Phone)#" type="text" class="bold_10pt_black"></td>
<tr>
<td colspan="2" align="right"><div align="right">
  <cfinput name="Update" type="submit" value="Update" class="bold_10pt_Button">
</div></td>
</table>
</cfform>
</div>
<cfelse>
<div class="font2">
<p><strong>Select Staff to modify</strong></p>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5" class="font1">
<tr>
<td><div align="right">Staff ID:</div></td>
<td><div align="left">
  <cfselect name="StaffID" class="bold_10pt_black"  bind="cfc:#request.cfc#cfc.bind.getstaffs()" display="StaffID" value="StaffID" bindonload="yes" tabindex="5">
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
</cfif>
</div>
</div>
</div>
</body>
</html>