<!doctype html>
<head>
<title><cfoutput>New Product :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDup.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#uom").hide();
	$("#purchaseUomTR").hide();
	$("#basicUoM").change(function(){
	var salesBasicUoM = $("#basicUoM").val();
	$("#salesUoMval2").text(salesBasicUoM);
	$("#purchaseUoMval2").text(salesBasicUoM);
	});
	$("#salesUoM").change(function(){
    $("#uom").show();
	var salesUoM = $("#salesUoM").val();
	$("#salesUoMval1").text(salesUoM);
	});
	
	$("#purchaseUoM").change(function(){
    $("#purchaseUomTR").show();
	var purchaseUoM = $("#purchaseUoM").val();
	$("#purchaseUoMval1").text(purchaseUoM);
	});
	
	$(function(){
 		$("#barcode").keydown(function (e) {
  			if (e.which == 13) {
				$('#productId').select();
    			return false;
		  }
		  });
		  });
		  });
</script>
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
INSERT INTO Inventory (barcode, ProductID, CategoryID, Description, CostPrice, SalePrice, reOrderLevel, Creator, DateUpdated, UoM, salesUoM, salesUoMConvert1, salesUoMConvert2, purchaseUoM, purchaseUoMConvert1, purchaseUoMConvert2)
VALUES ('#trim(form.barcode)#', '#trim(form.productID)#', '#trim(form.category)#', '#form.productDescription#', '#form.CostPrice#','#form.SalePrice#', '#form.reOrder#', '#GetAuthUser()#',<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="CF_SQL_DATE">,'#form.basicUoM#','#form.salesUoM#','#form.salesUoM1#','#form.salesUoM2#','#form.purchaseUoM#','#form.purchaseUoM1#','#form.purchaseUoM2#') 
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
<td height="24">Bar Code:</td>
<td><cfinput type="text" name="barcode" id="barcode" class="bold_10pt_black" autocomplete="off" autofocus></td>
</tr>
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
<cfquery name="invUnits">
select name from inventoryUnits
where name <> 'Pcs'
order by name
</cfquery>
<tr>
<td height="24">Basic UoM:</td>
<td><cfselect name="basicUoM" id="basicUoM" style="text-align:left">
<option value="Pcs" selected>Pcs</option>
<cfoutput query="invUnits">
<option value="#name#">#name#</option>
</cfoutput>
</cfselect></td>
</tr>
<tr>
<td height="24">Sales UoM:</td>
<td><cfselect name="salesUoM" id="salesUoM" style="text-align:left">
<option value="Pcs" selected>Pcs</option>
<cfoutput query="invUnits">
<option value="#name#">#name#</option>
</cfoutput>
</cfselect></td>
</tr>
<tr id="uom">
<td height="24">Conversion:</td>
<td><cfinput id="salesUoM1" name="salesUoM1" size="5"/><span id="salesUoMval1"></span>=<input id="salesUoM2" name="salesUoM2" size="5"/><span id="salesUoMval2"></span>
</td>
</tr>
<tr>
<td height="24">Purchase UoM:</td>
<td><cfselect name="purchaseUoM" id="purchaseUoM" style="text-align:left">
<option value="Pcs" selected>Pcs</option>
<cfoutput query="invUnits">
<option value="#name#">#name#</option>
</cfoutput>
</cfselect></td>
</tr>
<tr id="purchaseUomTR">
<td height="24">Conversion:</td>
<td><input id="purchaseUoM1" name="purchaseUoM1"  size="5"/><span id="purchaseUoMval1"></span>=<input id="purchaseUoM2" name="purchaseUoM2" size="5"/><span id="purchaseUoMval2"></span>
</td>
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