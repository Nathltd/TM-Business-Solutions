<!doctype html>
<html>
<head>
<title><cfoutput>Payments Modify :: #request.title#</cfoutput></title>
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
INSERT INTO Staff (FirstName, LastName, resAddress, maritalStatus, basicSalary, Designation, department, employType, dob, StaffID, BranchID, Phone, Creator)
VALUES ('#form.firstName#', '#form.LastName#', '#form.resAddress#', '#form.maritalStatus#', '#form.basicSalary#', '#form.designation#', '#form.department#', '#form.employType#', '#form.dob#', '#form.staffId#', '#form.Branch#', '#form.phone#', '#GetAuthUser()#') 
</cfquery>
<div class="Results">
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.FirstName# #form.LastName# </strong></font>has been created successfully <a href="#cgi.SCRIPT_NAME#">click here</a> to continue </cfoutput>
</div>
<cfelse>
<cfquery name="Branches" datasource="#request.dsn#">
SELECT BranchID
FROM Branches
ORDER BY BranchID ASC
</cfquery>
  <cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<br />

  <table cellpadding="5" width="41%">
  <tr>
  <td height="24"><div align="right">First Name:</div></td>
  <td><div align="left">
    <cfinput type="text" name="firstName" required="yes" style="width:100%">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Last Name:</div></td>
  <td><div align="left">
    <cfinput type="text" name="lastName" style="width:100%">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Marital Status:</div></td>
  <td><div align="left">
    <cfselect name="maritalStatus" id="maritalStatus" required="yes" style="width:100%">
    <option value="Single">Single</option>
    <option value="Married">Married</option>
    <option value="Widowed">Widowed</option>
    <option value="Divorced">Divorced</option>
    </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Date of Birth:</div></td>
  <td><div align="left">
    <cfinput type="datefield" name="dob" id="dob" style="width:100%">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Branch:</div></td>
  <td><div align="left">
    <cfselect name="branch" required="yes" message="Select A Branch" bind="cfc:#request.cfc#cfc.bind.allBranches()" display="BranchID" value="BranchID" bindonload="yes" style="width:100%">    
    </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Department:</div></td>
  <td><div align="left">
    <cfselect name="department" required="yes" bind="cfc:#request.cfc#cfc.bind.getDepartment()" display="departName" value="departName" bindonload="yes" style="width:100%">      
      </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Position:</div></td>
  <td><div align="left">
    <cfselect name="designation" required="yes" bind="cfc:#request.cfc#cfc.bind.getStaffPosition()" display="positionName" value="positionName" bindonload="yes" style="width:100%">      
      </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Type:</div></td>
  <td><div align="left">
    <cfselect name="EmployType" id="EmployType" required="yes" bind="cfc:#request.cfc#cfc.bind.getEmployType()" display="typeName" value="typeName" bindonload="yes" style="width:100%">      
      </cfselect>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Staff ID:</div></td>
  <td><div align="left">
    <cfinput type="text" name="staffID" required="yes" message="Staff ID required" style="width:100%">
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Basic Salary:</div></td>
  <td><div align="left">
    <cfinput type="text" name="basicSalary" validate="integer" required="yes" style="width:100%">
  </div></td>
  </tr>
  <tr>
  <td height="24" title="Residential Address"><div align="right">Res. Address:</div></td>
  <td><div align="left">
    <cftextarea name="resAddress" required="yes" height="3" type="text" style="width:100%"></cftextarea>
  </div></td>
  </tr>
  <tr>
  <td height="24"><div align="right">Phone:</div></td>
  <td><div align="left">
    <cfinput type="text" name="phone" id="phone" validate="integer" placeholder="080xxxxxxxx" required="yes" style="width:100%">
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