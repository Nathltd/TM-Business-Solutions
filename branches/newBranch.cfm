<!doctype html>
<html>
<head>
<title><cfoutput>New Branch :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDupl.js" language="javascript" type="application/javascript"></script>
</head>
<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>New Branch</h4>
<div id="RightColumn">
<cfquery name="branch">
select * from branches
	</cfquery>
<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha'>
<h1> Unauthrised Zone </h1>
<cfelseif #branch.recordCount# gte 1 AND #GetUserRoles()# is 'Administrator'>
<h1> Maximum Expansion Exhausted </h1>
<cfelse>

<cfif isdefined("form.submit")>
<cftransaction>
<cfquery>
INSERT INTO Branches (BranchID, BranchType, Description, Creator, DateUpdated)
VALUES ('#form.BranchName#', '#form.BranchType#', '#form.BranchDesc#','#GetAuthUser()#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">) 
</cfquery>
<cfquery>
INSERT INTO Accounts (AccountID, AccountName, OpeningBalance, Creator, dateUpdated)
VALUES ('#form.BranchName#', '#form.BranchName#', '#form.OBalance#', '#GetAuthUser()#', <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">) 
</cfquery>
</cftransaction>
<p>
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.BranchName# </strong></font>has been created successfully <a href="newBranch.cfm">click here</a> to continue </cfoutput>
</p>

<cfelse>
<cfform action="newBranch.cfm" enctype="multipart/form-data">
<table width="30%" cellpadding="2">
<tr>
<td>Branch Name:</td>
<td><cfinput type="text" name="BranchName" id="BranchName" title="Branch Name" required="yes" message="Enter Branch Name" style="width:100%">
	<span id="msg">&nbsp;Branch Already exist</span></td>
</tr>
<tr>
<td>Branch Type:</td>
<td><cfselect name="BranchType" message="Enter Branch Type" style="width:100%"required="yes" bind="cfc:#request.cfc#cfc.bind.getBranchTypes()" display="BranchType" value="BranchType" bindonload="yes" title="Branch Type">
</cfselect></td>
</tr>
<tr>
<td>Description:</td>
<td><cfinput type="text" name="BranchDesc" id="BranchDesc"  required="yes" message="Enter Description" style="width:100%" title="Description"></td>
</tr>
<tr>
<td>Opening Balance:</td>
<td><cfinput type="text" name="OBalance" id="OBalance" validate="float" placeholder="0" required="yes" title="Financial Balance for this Branch" message="Enter Opening Balance" style="width:100%; text-align:right"></td>
</tr>
<tr>
<td></td>
<td align="right"><div align="right"><cfinput type="submit" name="submit" value="Create"></div></td>
</tr>
</table>
</cfform>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>