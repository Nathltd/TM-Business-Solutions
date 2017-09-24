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
<h4>Branch Modification</h4>
<div id="RightColumn">



<cfif IsDefined("form.Update") is True>
<cfgridupdate grid = "DPgrid" dataSource = "#request.dsn#"
tableName = "Inventory">
<br />
<br />
<br />

<cfoutput><strong>Updated successfully.</strong> <br /><br />
<br />

Click here to <a href="../index/index.cfm"> continue </a></cfoutput>
<cfelse>
<br />
<br />

<cfquery name="ProductDetails" datasource="#request.dsn#">
SELECT ID,ProductID,Description,CategoryID, Creator
FROM Inventory
</cfquery>
<cfquery name="Category" datasource="#request.dsn#">
select CategoryID
from InventoryCategory
</cfquery>
<cfif #ProductDetails.recordcount# is 0>
<cfoutput><strong> No Record found</strong> </cfoutput><br />
<br />
Click <a href="deleteProductDisplay.cfm">here</a> for another search
<cfelse>
<cfoutput><strong>#ProductDetails.recordcount# Products Available</strong> </cfoutput>
<br />
<br />
<cfform>
<table>
<tr>
<td>
<cfif #GetUserRoles()# is "administrator">
<cfset ddelete = "yes">
<cfelse>
<cfset ddelete = "no">
</cfif>
<cfgrid name="DPgrid" height="400" width="550" query="ProductDetails"  delete="#ddelete#" deletebutton="remove" gridlines="no" format="html" fontsize="11"colheaderbold="Yes" colheaders="yes"
font = "Tahoma" selectcolor="##949494" selectmode = "Edit" >

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center">
<cfgridcolumn name = "ProductID" header = "Products" width="200" headeralign="center">
<cfgridcolumn name = "Description" header = "Description" width="220" headeralign="center"  dataalign="right">
<cfgridcolumn name = "CategoryID" header = "Category" width="80" headeralign="center" values="#valuelist(Category.CategoryID)#"  dataalign="right">
</cfgrid>
</td>
</tr>
<tr>
<td align="right">
<cfinput type="submit" name="Update" value="Update">
</td>
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