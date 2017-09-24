<!doctype html>
<html>
<head>
<title><cfoutput>Customer Update :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Customer Modification</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="form.Update" default="">
<cfparam name="form.CustomerID" default="">
<cfparam name="form.CustomerID2" default="">
<cfparam name="form.search" default="">

<cfquery name="getBranch" datasource="#request.dsn#">
SELECT CustomerID
FROM Customers
ORDER BY CustomerID ASC
</cfquery>

<cfif isdefined (#form.update#)>

<cftransaction>
<cfquery>
UPDATE Customers
SET Company = '#Trim(form.Company)#',
	Creator = '#GetAuthUser()#',
    Address = '#Trim(form.Address)#',
    CustomerID = '#Trim(form.CustomerID2)#',
    CustomerPhone = '#Trim(form.CustomerPhone)#',
    CustomerEmail = '#Trim(form.CustomerEmail)#',
    OpeningBalance = '#Trim(form.OpeningBalance)#',
    creditLimit = '#Trim(form.creditLimit)#',
    status = '#Trim(form.status)#',
    dateUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(form.opendate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
    CurrentDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
    WHERE CustomerID='#form.CustomerID#'
</cfquery>
</cftransaction>

<p>
 <cfoutput>#form.CustomerID2# Has been updated. Click <a href="#cgi.SCRIPT_NAME#">here to update</a> another Customer</cfoutput>
</p>

<cfelseif isdefined (#form.search#)>
<cfquery name="getCustomer" datasource="#request.dsn#">
SELECT CustomerID, Address, CustomerPhone, Company, CustomerEmail, OpeningBalance,creditLimit,status, dateUpdated
FROM Customers
WHERE CustomerID = <cfqueryparam value="#form.CustomerID#" cfsqltype="cf_sql_clob"> 
</cfquery>

<cfquery name="status">
  select statusId from status
  </cfquery>
<div>

<cfform enctype="multipart/form-data" action="#cgi.SCRIPT_NAME#">
<table cellspacing="5">
<tr>
<td><div align="left">Customer Name:</div></td>
<td><div align="left">
  <cfinput name="CustomerID2" id="CustomerID2" value="#Trim(getCustomer.CustomerID)#" style="width:100%" required="yes" message="Enter Branch Name">
    <cfinput name="CustomerID" id="CustomerID" type="hidden" value="#Trim(getCustomer.CustomerID)#" class="bold_10pt_black">
</div></td>
</tr>
<tr>
<td><div align="left">Company:</div></td>
<td><div align="left">
  <cfinput name="Company" style="width:100%" required="yes" type="text" value="#Trim(getCustomer.Company)#" >
    
</div></td>
</tr>
<tr>
<td><div align="left">Address:</div></td>
<td><div align="left">
  <cftextarea name="Address" rows="2" id="Address" style="width:100%" value="#Trim(getCustomer.Address)#">
  </cftextarea>
</div></td>
</tr>
<tr>
<td><div align="left">Phone:</div></td>
<td><div align="left">
  <cfinput name="CustomerPhone" style="width:100%" required="yes" type="text" value="#Trim(getCustomer.CustomerPhone)#" >
</div></td>
</tr>
<tr>
<td><div align="left">Status:</div></td>
<td><div align="left">
  <cfselect name="status" style="width:100%" required="yes">
  <cfoutput query="status">
  <option value="#statusId#" <cfif status.statusId is getCustomer.status>
    selected </cfif>>#statusId#</option>
  </cfoutput>
  </cfselect>
</div></td>
</tr>
<tr>
<td><div align="left">Email:</div></td>
<td><div align="left">
  <cfinput name="CustomerEmail" style="width:100%" type="text" value="#Trim(getCustomer.CustomerEmail)#">
</div></td>
</tr>
<tr>
<td height="24"><div align="right">Opening Date:</div></td>
<td><div align="left">
  <cfinput type="datefield" name="openDate" id="openDate" mask="dd/mm/yyyy"  autosuggest="no" required="yes" message="Enter Opening Date" value="#dateformat(getCustomer.dateUpdated,"mm/dd/yyyy")#">
</div></td>
</tr>
<tr>
<td height="24"><div align="left">Credit Limit:</div></td>
<td><div align="left">
  <cfinput type="text" name="creditLimit" validate="integer" id="creditLimit" style="width:100%;text-align:right" required="yes" value="#Trim(getCustomer.creditLimit)#">
</div></td>
</tr>
<tr>
<td height="24"><div align="left">Opening Balance:</div></td>
<td><div align="left">
  <cfinput type="text" name="OpeningBalance" validate="integer" id="OpeningBalance" style="width:100%;text-align:right" required="yes" value="#Trim(getCustomer.OpeningBalance)#">
</div></td>
</tr>
<tr>
<td></td>
<td align="right"><div align="right">
  <cfinput name="Update" type="submit" value="Update">
</div></td>
</table>
</cfform>
</div>
<cfelse>
<div>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table cellspacing="5">
<tr>
<td><div align="right">Customer Name:</div></td>
<td><div align="left">
  <cfselect name="CustomerID" required="yes" style="width:100%" message="Choose Location" bind="cfc:#request.cfc#cfc.bind.getCustomers()" display="CustomerID" value="CustomerID" bindonload="yes">
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td></td>
    <td align="right"><div align="right">
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