<!doctype html>
<html>
<head>
<title><cfoutput>Product Modification :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$(function(){
 		$("#barcode").keydown(function (e) {
  			if (e.which == 13) {
				$('#ProductID2').select();
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
<h4>Product Modification</h4>

<div id="RightColumn">
<cfif #GetUserRoles()#  contains 'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()#  contains 'Sales'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.Update" default="">
<cfparam name="form.ProductID" default="">
<cfparam name="form.ProductID2" default="">
<cfparam name="form.search" default="">
<cfquery name="getProduct">
SELECT ProductID
FROM Inventory
ORDER BY ProductID ASC
</cfquery>

<cfif isdefined (#form.update#)>
<cftransaction>
<cfquery>
UPDATE Inventory
SET barCode = '#Trim(form.barcode)#',
	CategoryID = '#Trim(form.Category)#',
	Creator = '#GetAuthUser()#',
    Description = '#Trim(form.ProductDescription)#',
    ProductID = '#Trim(form.ProductID2)#',
    SalePrice = #Trim(form.ProductPrice)#,
    CostPrice = #Trim(form.ProductCost)#,
    ReorderLevel = #Trim(form.Reorder)#,
    Status = '#Trim(form.Status)#',
    UoM = '#form.basicUoM#', 
    salesUoM = '#form.salesUoM#', 
    salesUoMConvert1 = '#form.salesUoM1#',
    salesUoMConvert2 = '#form.salesUoM2#',
    purchaseUoM = '#form.purchaseUoM#',
    purchaseUoMConvert1 = '#form.purchaseUoM1#',
    purchaseUoMConvert2  = '#form.purchaseUoM2#'
WHERE ProductID = '#form.ProductID#'
</cfquery>

</cftransaction>
<p>&nbsp;</p>
 <cfoutput>#form.ProductID2#</cfoutput> Has been updated. Click <a href="updateProduct.cfm">here to update</a> another item
<p>&nbsp;</p>
<cfelseif isdefined (#form.search#)>
<cfset Prod = PreserveSingleQuotes(form.ProductID)>
<cfquery name="getProduct">
SELECT barCode, ProductID, CategoryID, Description, Creator, CostPrice, SalePrice, reorderLevel,Status, UoM, salesUoM, salesUoMConvert1, salesUoMConvert2, purchaseUoM, purchaseUoMConvert1, purchaseUoMConvert2
FROM Inventory
WHERE ProductID = <cfqueryparam value="#Trim(Prod)#" cfsqltype="cf_sql_varchar"> 
</cfquery>
<cfquery name="getAllProduct">
SELECT DISTINCT CategoryID
FROM inventoryCategory
ORDER BY CategoryID
</cfquery>
<cfquery name="Status">
SELECT DISTINCT StatusID
FROM Status
ORDER BY StatusID
</cfquery>
<div class="font1">
<p><strong>Make Adjustments</strong></p>
<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellspacing="5">
<tr>
<td height="24">Bar Code:</td>
<td><cfinput type="text" name="barcode" id="barcode" value="#Trim(getProduct.barcode)#" class="bold_10pt_black" autocomplete="off" autofocus></td>
</tr>
<tr>
<td><div align="left">Product Name:</div></td>
<td><div align="left">
  <cfinput name="ProductID2" id="ProductID2" value="#Trim(getProduct.ProductID)#" autocomplete="off" class="bold_10pt_black" required="yes" message="Enter Product Name">
    <cfinput name="ProductID" id="ProductID" type="hidden" value="#Trim(getProduct.ProductID)#">
</div></td>
</tr>
<tr>
<td><div align="left">Category:</div></td>
<td><div align="left">
  <cfselect name="Category" style="text-align:left; width:100%">
  
    <cfoutput query="getAllProduct">
      <option value="#Trim(categoryID)#" <cfif getAllProduct.CategoryID is getProduct.CategoryID>
    selected </cfif>>#categoryID#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<tr>
<td><div align="left">Description:</div></td>
<td><div align="left">
  <cfinput name="ProductDescription" value="#Trim(getProduct.Description)#" type="text" autocomplete="off">
</div></td>
</tr>
<cfquery name="invUnits">
select name from inventoryUnits
order by name
</cfquery>
<tr>
<td height="24">Basic UoM:</td>
<td><cfselect name="basicUoM" id="basicUoM" style="text-align:left">
<cfoutput query="invUnits">
      <option value="#Trim(name)#" <cfif invUnits.name is getProduct.UoM>
    selected </cfif>>#name#
        </option>
      </cfoutput>
</cfselect></td>
</tr>
<tr>
<td height="24">Sales UoM:</td>
<td><cfselect name="salesUoM" id="salesUoM" style="text-align:left">
<cfoutput query="invUnits">
      <option value="#Trim(name)#" <cfif invUnits.name is getProduct.salesUoM>
    selected </cfif>>#name#
        </option>
      </cfoutput>
</cfselect></td>
</tr>
<tr id="uom">
<td height="24">Conversion:</td>
<td><cfinput id="salesUoM1" name="salesUoM1" value="#Trim(getProduct.salesUoMConvert1)#" size="5"/><span id="salesUoMval1"></span>=<cfinput id="salesUoM2" name="salesUoM2"  value="#Trim(getProduct.salesUoMConvert2)#"size="5"/><span id="salesUoMval2"></span>
</td>
</tr>
<tr>
<td height="24">Purchase UoM:</td>
<td><cfselect name="purchaseUoM" id="purchaseUoM" style="text-align:left">
<cfoutput query="invUnits">
      <option value="#Trim(name)#" <cfif invUnits.name is getProduct.purchaseUoM>
    selected </cfif>>#name#
        </option>
      </cfoutput>
</cfselect></td>
</tr>
<tr id="purchaseUomTR">
<td height="24">Conversion:</td>
<td><cfinput id="purchaseUoM1" name="purchaseUoM1" value="#Trim(getProduct.purchaseUoMConvert1)#" size="5"/><span id="purchaseUoMval1"></span>=<cfinput id="purchaseUoM2" name="purchaseUoM2" value="#Trim(getProduct.purchaseUoMConvert2)#" size="5"/><span id="purchaseUoMval2"></span>
</td>
</tr>
<tr>
  <td align="right"><div align="left">Cost Price:</div></td>
  <td align="right"><cfinput name="ProductCost" value="#Trim(getProduct.CostPrice)#" type="text" autocomplete="off" style="text-align:right"></td>
  </tr>
<tr>
  <td align="right"><div align="left">Sales Price:</div></td>
  <td align="right"><cfinput name="ProductPrice" value="#Trim(getProduct.SalePrice)#" type="text" autocomplete="off" style="text-align:right"></td>
  </tr>
  <tr>
  <td align="right"><div align="left">Re-order Level:</div></td>
  <td align="right"><cfinput name="Reorder" value="#Trim(getProduct.reorderLevel)#" type="text" autocomplete="off" style="text-align:right"></td>
  </tr>
  <tr>
<td><div align="left">Status:</div></td>
<td><div align="left">
  <cfselect name="Status" style="text-align:left; width:100%">
  
    <cfoutput query="Status">
      <option value="#Trim(StatusID)#" <cfif Status.StatusID is getProduct.Status>
    selected </cfif>>#StatusID#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<tr>
<td colspan="2" align="right"><div align="right">
  <cfinput name="Update" type="submit" value="Update" class="bold_10pt_Button">
</div></td>
</table>
</cfform>
</div>
<cfelse>
<div>
<p><strong>Select Product to edit</strong></p>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5" width="30%">
<tr>
<td width="40%"><div align="right">Product Name:</div></td>
<td width="60%"><div align="left">
  <cfselect name="ProductID" style="text-align:left; width:100%">
    <cfoutput query="getProduct">
      <option value="#Trim(ProductID)#">#Trim(ProductID)#</option>
      </cfoutput>
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
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>