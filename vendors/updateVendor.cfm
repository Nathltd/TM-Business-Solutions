<!doctype html>
<html>
<head>
<title><cfoutput>Vendor Modification :: #request.title#</cfoutput></title>
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
<h4>Branch Modification</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>
<cfparam name="form.Update" default="">
<cfparam name="form.VendorID" default="">
<cfparam name="form.VendorID2" default="">
<cfparam name="form.search" default="">

<cfquery name="getBranch" datasource="#request.dsn#">
SELECT VendorID
FROM Vendors
ORDER BY VendorID ASC
</cfquery>

<cfif isdefined (#form.update#)>

<cftransaction>
<cfquery>
UPDATE Vendors
SET Company = '#Trim(form.Company)#',
	Creator = '#GetAuthUser()#',
    Address = '#Trim(form.Address)#',
    VendorID = '#Trim(form.VendorID2)#',
    VendorType = '#Trim(form.VendorType)#',
    Phone = '#Trim(form.Phone)#',
    Email = '#Trim(form.Email)#',
    OpeningBalance = '#Trim(form.OpeningBalance)#',
    dateUpdated = <cfqueryparam value="#dateformat(form.opendate,"dd/mm/yyyy")#" cfsqltype="cf_sql_timestamp">,
    CurrentDate = <cfqueryparam value="#dateformat(Now(),"dd/mm/yyyy")#" cfsqltype="cf_sql_timestamp">
    WHERE VendorID='#form.VendorID#'
</cfquery>
</cftransaction>

<p>
 <cfoutput>#form.VendorID2#</cfoutput> Has been updated. Click <a href="?">here to update</a> another Vendor
</p>

<cfelseif isdefined (#form.search#)>
<cfquery name="getVendor">
SELECT VendorID, Address, Phone, Company, Email, OpeningBalance, VendorType,dateUpdated
FROM Vendors
WHERE VendorID = <cfqueryparam value="#form.VendorID#" cfsqltype="cf_sql_clob"> 
</cfquery>

<cfquery name="VendorType">
SELECT VendorType
FROM VendorType
ORDER BY VendorType
</cfquery>

<div>

<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellspacing="5">
<tr>
<td><div align="left">Supplier Name:</div></td>
<td><div align="left">
  <cfinput name="VendorID2" id="VendorID2" value="#Trim(getVendor.VendorID)#" class="bold_10pt_black" required="yes" message="Enter Name" autocomplete="off">
    <cfinput name="VendorID" id="VendorID" type="hidden" value="#Trim(getVendor.VendorID)#" class="bold_10pt_black">
</div></td>
</tr>
<tr>
<td><div align="left">Company:</div></td>
<td><div align="left">
  <cfinput name="Company" class="bold_10pt_black" required="yes" type="text" value="#Trim(getVendor.Company)#" message="Enter Company Name" autocomplete="off">
    
</div></td>
</tr>
<tr>
<td><div align="left">Type:</div></td>
<td><div align="left">
  <cfselect name="VendorType" class="bold_10pt_black" required="yes">
    <cfoutput query="VendorType">
      <option value="#Trim(VendorType)#" <cfif VendorType.VendorType is getVendor.VendorType>
    selected </cfif>>#VendorType#
        </option>
      </cfoutput>
    </cfselect>
</div></td>
</tr>
<tr>
<td><div align="left">Address:</div></td>
<td><div align="left">
  <cftextarea name="Address" rows="2" id="Address"  class="bold_10pt_black" value="#Trim(getVendor.Address)#">
  </cftextarea>
</div></td>
</tr>
<tr>
<td><div align="left">Phone:</div></td>
<td><div align="left">
  <cfinput name="Phone" class="bold_10pt_black" required="yes" type="text" value="#Trim(getVendor.Phone)#" autocomplete="off">
</div></td>
</tr>
<tr>
<td><div align="left">Email:</div></td>
<td><div align="left">
  <cfinput name="Email" class="bold_10pt_black" type="text" value="#Trim(getVendor.Email)#">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date" value="#dateformat(getVendor.dateUpdated,"mm/dd/yyyy")#">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Balance:</div></td>
<td><div align="left">
  <cfinput type="text" name="OpeningBalance" style="text-align:right" validate="integer" id="OpeningBalance" class="bold_10pt_black" required="yes" value="#Trim(getVendor.OpeningBalance)#" autocomplete="off">
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
<br />
<strong>Select Vendor to Modify</strong>
<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5">
<tr>
<td><div align="right">Customer Name:</div></td>
<td><div align="left">
  <cfselect name="VendorID" required="yes" class="bold_10pt_black">
   <cfoutput query="getBranch">
	<option value="#vendorId#">#vendorId#</option>
	</cfoutput>
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td colspan="2" align="right"><div align="right">
      <cfinput type="submit" name="Search" value="Search" class="bold_10pt_Button">
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