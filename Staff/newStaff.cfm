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
<h4>New Staff</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif isdefined("form.submit")>
<cfquery name="InsertProduct" datasource="#request.dsn#">
INSERT INTO Staff (FirstName, LastName, Designation, StaffID, BranchID, Phone, Creator)
VALUES ('#form.firstName#', '#form.LastName#', '#form.staffDesignation#', '#form.staffId#', '#form.staffBranch#', '#form.staffPhone#', '#GetAuthUser()#') 
</cfquery>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.FirstName# #form.LastName# </strong></font>has been created successfully <a href="newstaff.cfm">click here</a> to continue </cfoutput>
</div>
<cfelse>
<cfquery name="Branches" datasource="#request.dsn#">
SELECT BranchID
FROM Branches
ORDER BY BranchID ASC
</cfquery>
  <cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<br />

  <table cellpadding="5" class="font1">
  <tr>
  <td height="24"><div align="right">First Name:</div></td>
  <td><div align="left">
    <cfinput type="text" name="firstName" required="yes" class="bold_10pt_black">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Last Name:</div></td>
  <td><div align="left">
    <cfinput type="text" name="lastName" class="bold_10pt_black">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Branch:</div></td>
  <td><div align="left">
    <cfselect name="staffBranch" required="yes" message="Select A Branch" bind="cfc:#request.cfc#cfc.bind.allBranches()" display="BranchID" value="BranchID" bindonload="yes" class="bold_10pt_black">    
    </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Department:</div></td>
  <td><div align="left">
    <cfselect name="staffDepartment" required="yes" bind="cfc:#request.cfc#cfc.bind.getDepartment()" display="departName" value="departName" bindonload="yes">      
      </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Position:</div></td>
  <td><div align="left">
    <cfselect name="staffDesignation" required="yes" bind="cfc:#request.cfc#cfc.bind.getStaffPosition()" display="positionName" value="positionName" bindonload="yes">      
      </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Type:</div></td>
  <td><div align="left">
    <cfselect name="staffType" required="yes" bind="cfc:#request.cfc#cfc.bind.getEmployType()" display="typeName" value="typeName" bindonload="yes">      
      </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Staff ID:</div></td>
  <td><div align="left">
    <cfinput type="text" name="staffID" required="yes" message="Staff ID required">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Basic Salary:</div></td>
  <td><div align="left">
    <cfinput type="text" name="staffSalary" validate="integer" required="yes">
  </div></td>
  </tr>
  <tr>
  <td height="24" title="Residential Address"><div align="right">Res. Address:</div></td>
  <td><div align="left">
    <cftextarea name="staffAdd" required="yes" height="3" type="text"></cftextarea>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Phone:</div></td>
  <td><div align="left">
    <cfinput type="text" name="staffPhone" validate="integer" placeholder="080xxxxxxxx" required="yes">
  </div></td>
  </tr>
    <tr>
  <td height="26" colspan="2" align="right"><div align="right">
    <cfinput type="submit" name="submit" value="Create">
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
</html>