<!doctype html>
<head>
<title><cfoutput>New Product :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDup.js" type="application/javascript"></script>
</head>

<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>New Product</h4>
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
Product name <strong>#form.productID#</strong> Already Exits<br>
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
<cfoutput><font face="Verdana, Geneva, sans-serif" pointsize="12"><strong> #form.productID# </strong></font>has been created successfully <a href="newProduct.cfm">click here</a> to continue </cfoutput>
</p>
</div>
<cfelse>
<cfquery name="category" datasource="#request.dsn#">
Select CategoryID from InventoryCategory
Order by CategoryID
</cfquery>

<cfform action="newProduct.cfm" enctype="multipart/form-data">

<table cellpadding="5">
<tr>
<td height="24">Product Name:</td>
<td><cfinput type="text" name="productId" id="productId" required="yes" message="Enter A Product Name" autocomplete="off"> <span id="msg">&nbsp;Product already exist</span></td>
</tr>
<tr>
<td height="24">Category:</td>
<td><cfselect enabled="Yes" name="category" style="text-align:left">
<cfoutput query="Category">
<option value="#category.CategoryID#">#category.CategoryID#</option>
</cfoutput>
</cfselect></td>
</tr>
<tr>
<td height="24">Description:</td>
<td><cfinput type="text" name="productDescription"  required="yes" autocomplete="off" message="Enter Description"></td>
</tr>
<tr>
<td height="24">Cost Price:</td>
<td><cfinput type="text" name="CostPrice"  required="yes" class="bold_10pt_black" placeholder="0" style="text-align:right" autocomplete="off" message="Enter Cost Price"></td>
</tr>
<tr>
<td height="24">Sale Price:</td>
<td><cfinput type="text" name="SalePrice"  required="yes" placeholder="0" style="text-align:right" autocomplete="off" message="Enter Sales Price"></td>
</tr>
<tr>
<td height="24">Re-order Level:</td>
<td><cfinput type="text" name="Reorder"  required="yes" placeholder="0" style="text-align:right" autocomplete="off" message="Enter Re-order Level"></td>
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