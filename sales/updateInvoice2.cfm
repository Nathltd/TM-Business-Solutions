<!doctype html>
<html>
<head>
<title><cfoutput>Sales Invoice Modify :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<style>
#formGrid input { border:0;}
#formGrid select {border: 0;}
</style>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Invoice Modification</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is 'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is 'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is 'Stock Keeper'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif structKeyExists(form, "submit")>

<cftransaction>

<cfloop from="1" to="#form.numberofrecords#" index="idx">
<cfquery>
Update salesDetails
set
productId = '#form["product_" & idx]#',
qty = #form["qty_" & idx]#,
unitPrice = #form["price_" & idx]#,
discount = #form["dis_" & idx]#
Where Id = #form["Id_" & idx]#
</cfquery>
</cfloop>

<cfquery>
UPDATE Sales
SET
SalesDate = '#lsDateFormat(CreateODBCDate(form.myDate), "dd/mm/yyyy")#',
BranchId = '#trim(form.BranchCode)#',
CustomerId = '#trim(form.CustomerCode)#',
StaffID = '#trim(form.RepName)#',
AmountPaid = #form.AmountPaid#,
LastUpdated = #dateformat(now(),"dd/mm/yyyy")#,
Creator = '#GetAuthUser()#',
AccountId = '#trim(form.select)#',
SalesID = #form.InvoiceNob#
WHERE SalesID = #form.InvoiceNo#
</cfquery>
</cftransaction>
<cfquery name="gCustomer">
SELECT Sales.SalesID
FROM Sales INNER JOIN CustomersGen ON Sales.SalesID = CustomersGen.SalesID
Where Sales.CustomerId = 'General'
</cfquery>
<cfif gCustomer.recordCount eq 0>
<cfquery>
UPDATE CustomersGen
SET
Status = 'disabled'
</cfquery>
<cfelse>
<cfquery>
UPDATE CustomersGen
SET
Status = 'enabled'
</cfquery>
</cfif>
<p>

<cfoutput> Invoice No. <strong>#form.InvoiceNob#</strong> have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> New Invoice </a></cfoutput>

</p>
<cfelse>
<cfif isdefined("form.search") or ("url.SalesID") is true>

<cfquery name="SalesDay">
select SalesID, SalesDate
from Sales
Where SalesID = <cfqueryparam value="#form.SalesID#" cfsqltype="cf_sql_clob">
</cfquery>

<cfset SalesDate =ValueList(SalesDay.SalesDate)>

<cfset closedate = #CreateODBCDate(request.clsDate)#>
<cfset current = #CreateODBCDate(SalesDate)#>
<cfset type = "d">
<cfset DayDiff = #DateDiff(type, closedate, current)#>
<cfif #DayDiff# lte 0>

<h3>This Invoice have been closed. Please contact the administrator.</h3>
<cfabort>
</cfif>

<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="form.AmountPaid" default="">
<cfparam name="session.AmountPaid" default="form.AmountPaid">
<cfparam name="session.CustomerCode" default="">
<cfparam name="session.InvoiceNo" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchCode" default="">
<cfparam name="session.RepCode" default="">
<cfparam name="session.select" default="">
<cfparam name="url.SalesID" default="">
<cfparam name="url.reset" default="">
<cfif isdefined (#url.SalesID#)>
<cfset #form.SalesID# = #url.SalesID#>
</cfif>
<cfquery name="Sales">
SELECT BranchID,SalesID,AmountPaid,AccountID,SalesDate,CustomerID,StaffID
FROM Sales
WHERE SalesID = <cfqueryparam value="#Trim(form.SalesID)#" cfsqltype="cf_sql_clob" maxlength="8">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "alpha">
<cfelseif #GetUserRoles()# is "Manager">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>

<cfquery name="SalesDetails">
SELECT ID,SalesID,ProductID,Qty,UnitPrice, discount
FROM SalesDetails
WHERE SalesID = <cfqueryparam value="#Trim(form.SalesID)#" cfsqltype="cf_sql_clob">
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>

<cfquery name="BranchCode">
SELECT BranchID, Description
FROM Branches
ORDER BY BranchID ASC 
</cfquery>
<cfquery name="RepCode">
SELECT FirstName
FROM Users
Where Designation = 'Sales Rep'
ORDER BY FirstName ASC 
</cfquery>

  <cfquery name="CustomerCode">
SELECT CustomerID
FROM Customers
ORDER BY CustomerID ASC 
  </cfquery>

<cfquery name="Products">
SELECT ProductID  FROM Inventory
ORDER BY ProductID
</cfquery>

<script> 


function checkKeyCode(evt)
{

var evt = (evt) ? evt : ((window.event) ? window.event : "");
var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
if(event.keyCode==116)
{
event.keyCode=0;
return false
}
}
document.onkeydown=checkKeyCode;
</script>

<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" id="form" method="post">

<div align="center">
  <table width="70%" border="0">
    <tr>
      <td width="28%"><div align="left"></div></td>
      <td width="44%">&nbsp;</td>
      <td width="28%"><div align="left">Date:<br>
  <cfinput type="datefield" style="width:100%" mask="dd/mm/yyyy" value="#dateformat(Sales.SalesDate,"mm/dd/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Invoice Date" required="yes" message="Enter Invoice Date"/></div></td>
      </tr>
    <tr>
      <td><div align="left">Customer Name:<br>
  <cfselect name="CustomerCode" style="width:100%" id="CustomerCode" tooltip="Employee that signed the invoice">
    <cfloop query="CustomerCode">
      <option value="#Trim(customerID)#" <cfif Sales.customerID is #customerID#>
    selected </cfif>>#CustomerID#</option>
      </cfloop>
    </cfselect>
</div></td>
      <td>&nbsp;</td>
      <td><div align="left">Branch:<br>
  <cfselect name="BranchCode" id="BranchCode"  style="width:100%">
    <cfloop query="BranchCode">
      <option value="#Trim(BranchID)#" <cfif Sales.BranchID is #BranchID#>
    selected </cfif>>#BranchID#</option>
      </cfloop>
  </cfselect></div></td>
      </tr>
      
    <tr>
      <td><div align="left">Invoice No.:<br>
  <cfinput type="text" name="InvoiceNob" required="yes" style="width:100%" value="#Sales.SalesID#" tooltip="Invoice Number" autocomplete="off">
        <cfinput type="hidden" name="InvoiceNo" value="#Sales.SalesID#"></div></td>
      <td>&nbsp;</td>
      <td><div align="left">Authorised:<br>
  <cfselect name="RepName" style="width:100%" id="RepName" tooltip="Employee that signed the invoice">
    <cfloop query="repCode">
      <option value="#Trim(FirstName)#" <cfif Sales.StaffID is #FirstName#>
    selected </cfif>>#FirstName#</option>
      </cfloop>
  </cfselect></div></td>
      </tr>
    <tr>
      <td><div align="left">Amount Paid:<br>
  <cfinput name="AmountPaid" id="AmountPaid" type="text" align="right" style="width:100%" value="#Sales.AmountPaid#" validate="float" onClick="checkBalance();"></div></td>
      <td>&nbsp;</td>
      <td><div align="left">Account:<br>
  <cfselect name="select" style="width:100%" id="select">
    <cfloop query="Accounts">
      <option value="#AccountID#" <cfif Sales.AccountID is #AccountID#>
    selected </cfif>>#AccountID#</option>
      </cfloop>
  </cfselect></div></td>
      </tr>
    </table></div><br>

  <table width="70%" border="0" cellpadding="2" cellspacing="0">
<thead>
<td>Item</td><td>Quantity</td><td>Price</td><td>Discount</td><td></td>
</thead>
<!--- include hidden field to indicate the number of records --->
<input type="hidden" name="numberofrecords" value="#SalesDetails.recordcount#">
<cfloop query="SalesDetails">
<tr>
<!--- include hidden field to hold the record id --->
<input type="hidden" name="Id_#CurrentRow#" value="#Id#">
<!--- append current row value to the field name --->
<td><select name="product_#CurrentRow#">
	<cfloop query="products">
	<option value="#Trim(ProductID)#" <cfif SalesDetails.ProductID is #ProductID#>
    selected </cfif>>#ProductID#</option>
    </cfloop>
    </select></td>
<td><input type="text" name="qty_#CurrentRow#" value="#Qty#" style="text-align:right"></td>
<td><input type="text" name="price_#CurrentRow#" value="#UnitPrice#" style="text-align:right"></td>
<td><input type="text" name="dis_#CurrentRow#" value="#Discount#" style="text-align:right"></td>
<td><a href="##">X</a></td>
</tr>
</cfloop>
<tr>
<td colspan="4" valign="bottom" align="right">
    <cfinput type="submit" name="submit" value="Update">
  </td>
</tr>
  </table>

</cfform>
</cfoutput>

<cfelse>

<cfquery name="Sales">
select SalesID, Creator
from Sales
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Manager">
<cfelseif #GetUserRoles()# is "Alpha">
  <cfelse>
WHERE Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob"> AND Salesdate >= <cfqueryparam value="#CreateODBCDate(request.clsDate)#" cfsqltype="cf_sql_date">
</cfif>
ORDER BY SalesID ASC
</cfquery>
<cfset Sales=ValueList(Sales.SalesID)>
<cfset validSales = #Listlen(Sales)#>

<cfif #validSales# eq 0>

<h3>You have no Item to update. Please contact the administrator.</h3>
<cfabort>
</cfif>

<br />

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="300">
 <tr>
<td width="120" align="right" >Invoice No:</td>
<td width="120" align="left" >
  <cfinput type="text" name="SalesID" required="yes" autosuggest="#Sales#"  autosuggestminlength="2">
</td>
    </tr>
    <tr>
    <td colspan="2" align="right">
      <div align="right">
        <cfinput type="submit" name="Search" value="Search">
      </div></td>
    </tr>
  </table>
  </cfform>
</cfif>
</cfif>
</cfif>
</div>
</div>
</div>
</body>