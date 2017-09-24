<!doctype html>
<html>
<head>
<title><cfoutput>New Room Category :: #request.title#</cfoutput></title>
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
<h4>New Room </h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha' AND #GetUserRoles()# is not 'Manager' AND #GetUserRoles()# is not 'Procurement'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif isdefined("form.submit")>
<cftry>
<cfquery name="InsertProduct" datasource="#request.dsn#">
INSERT INTO Inventory (ProductID, CategoryID, Description, CostPrice, SalePrice, reOrderLevel, Creator, DateUpdated)
VALUES ('#trim(form.productID)#', '#trim(form.category)#', '#form.productDescription#', '#form.CostPrice#','#form.SalePrice#', '#form.reOrder#', '#GetAuthUser()#','#lsDateFormat(Now())#') 
</cfquery>
 <cfcatch type="database">
<h3>An Error Has Occured</h3><br>

<cfoutput>
<cfif #cfcatch.NativeErrorCode# is "0">
Room name <strong>#form.productID#</strong> Already Exits<br>
<p>
<a href="#cgi.SCRIPT_NAME#?">Try Again</a>
</p>
</cfif>
<!--- and the diagnostic message from the ColdFusion server --->
<cfif #GetUserRoles()# is "Administrator">
<p>Type = #CFCATCH.TYPE# </p>
<p>Message = #cfcatch.detail#</p>
<p>Code = #cfcatch.NativeErrorCode#</p>
<cfloop index = i from = 1 to = #ArrayLen(CFCATCH.TAGCONTEXT)#>
<cfset sCurrent = #CFCATCH.TAGCONTEXT[i]#>
Occured on Line #sCurrent["LINE"]#, Column #sCurrent["COLUMN"]#
</cfloop>
</cfif>
</cfoutput>
<cfabort>
</cfcatch>
</cftry>
<div>
<p>
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.productID# </strong></font>has been created successfully <a href="#cgi.SCRIPT_NAME#">click here</a> to continue </cfoutput>
</p>
</div>
<cfelse>
<cfquery name="category" datasource="#request.dsn#">
Select typeId from roomType
Order by typeId
</cfquery>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table cellpadding="5">
<tr>
<td>Room Id:</td>
<td><cfinput type="text" name="productId" id="productId" required="yes" message="Enter A Room Name" autocomplete="off"></td>
</tr>
<tr>
<td >Category:</td>
<td><cfselect enabled="Yes" name="category" style="text-align:left" width="100%">
<cfoutput query="Category">
<option value="#category.typeID#">#category.typeId#</option>
</cfoutput>
</cfselect></td>
</tr>
<tr>
<td >Description:</td>
<td><cftextarea name="productDescription" id="productDescritption" message="Enter Description"></cftextarea></td>
</tr>
<tr>
<td >Status:</td>
<td><cfselect name="status" id="status">
		<option value="Available">Available</option>
        <option value="Engaged">Engaged</option>
        </cfselect>
        </td>
</tr>
<tr>
<td height="26" align="right"></td>
<td height="26" align="right"><div align="right">
  <cfinput type="submit" name="submit" value="Create" class="bold_10pt_Button">
</div></td>
</tr>
</table>
</cfform>
</cfif>
</cfif>
</div>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>