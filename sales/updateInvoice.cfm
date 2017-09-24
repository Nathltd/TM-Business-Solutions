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
<link rel="stylesheet" type="text/css" media="all" href="../css/styles2.css">
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Invoice Modification</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# contains 'Sales'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# contains 'Account'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# contains 'Stock'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif IsDefined("form.Update") is True>

<cftransaction>
<cfloop index = "counter" from = "1" to = #arraylen(Form.SalesUpdate.rowstatus.action)#>
<cfif Form.SalesUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertSalesDetails">
INSERT into SalesDetails (SalesID,ProductID,Qty,UnitPrice,discount,BranchId) 
    VALUES (#form.InvoiceNo#,'#Form.SalesUpdate.ProductID[counter]#',#Form.SalesUpdate.Qty[counter]#,#Form.SalesUpdate.UnitPrice[counter]#,#Form.SalesUpdate.Discount[counter]#,'#trim(form.BranchCode)#')
</cfquery>
<cfelseif  Form.SalesUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdateSalesDetails">
UPDATE SalesDetails
SET
BranchId = '#trim(form.BranchCode)#',
ProductID = '#trim(Form.SalesUpdate.ProductID[counter])#',
Qty = #Form.SalesUpdate.Qty[counter]#,
UnitPrice = #Form.SalesUpdate.UnitPrice[counter]#,
Discount = #Form.SalesUpdate.Discount[counter]#,
SalesID = #form.InvoiceNo#
WHERE ID = #trim(Form.SalesUpdate.ID[counter])#
</cfquery>
<cfelseif Form.SalesUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeleteSalesDetails">
DELETE from SalesDetails
WHERE ID = #Form.SalesUpdate.Original.ID[counter]#
</cfquery>
</cfif>
</cfloop>
<cfquery>
UPDATE Sales
SET
SalesDate =<cfqueryparam value="#lsDateFormat(CreateODBCDate(form.myDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
BranchId = '#trim(form.BranchCode)#',
CustomerId = '#trim(form.CustomerCode)#',
StaffID = '#trim(form.RepName)#',
AmountPaid = #form.AmountPaid#,
LastUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
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

<cfoutput> Invoice No. <strong>#form.InvoiceNob#</strong> have been Updated successfully<a href="UpdateInvoice.cfm"> New Invoice </a></cfoutput>

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
Where Designation like '%Sales%'
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


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="60%" border="0">
    <tr>
      <td><div align="left"></div></td>
      <td>&nbsp;</td>
      <td><div align="right">Date:</div></td>
      <td><div align="left">
      <cfinput type="datefield" style="width:100%" mask="dd/mm/yyyy" value="#dateformat(Sales.SalesDate,"mm/dd/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Invoice Date" required="yes" message="Enter Invoice Date"/>
       
      </div>
             </td>
    </tr>
    <tr>
      <td width="110"><div align="right">Customer Name:</div></td>
      <td><div align="left">
        <cfselect name="CustomerCode" style="width:100%" id="CustomerCode" tooltip="Employee that signed the invoice">
            <cfloop query="CustomerCode">
              <option value="#Trim(customerID)#" <cfif Sales.customerID is #customerID#>
    selected </cfif>>#CustomerID#</option>
              </cfloop>
            </cfselect>
               </div></td>
      <td width="137"><div align="right">Branch:</div></td>
      <td width="194"><div align="left">

        <cfselect name="BranchCode" id="BranchCode"  style="width:100%">
            <cfloop query="BranchCode">
           <option value="#Trim(BranchID)#" <cfif Sales.BranchID is #BranchID#>
    selected </cfif>>#BranchID#</option>
    </cfloop>
        </cfselect>
                    
        </div></td>
      </tr>
      
    <tr>
      <td width="110"><div align="right">Invoice No.
        :</div></td>
      <td width="174"><div align="left">
      <cfinput type="text" name="InvoiceNob" required="yes" style="width:100%" value="#Sales.SalesID#" tooltip="Invoice Number" autocomplete="off">
      <cfinput type="hidden" name="InvoiceNo" value="#Sales.SalesID#">
      </div></td>
      <td><div align="right">Authorised:</div></td>
      <td><div align="left">

       		<cfselect name="RepName" style="width:100%" id="RepName" tooltip="Employee that signed the invoice">
            <cfloop query="repCode">
           <option value="#Trim(FirstName)#" <cfif Sales.StaffID is #FirstName#>
    selected </cfif>>#FirstName#</option>
    </cfloop>
        </cfselect>
            
      </div></td>
      </tr>
    <tr>
      <td width="110"><div align="right">Amount Paid
        :</div></td>
      <td width="174"><div align="left">
       <cfinput name="AmountPaid" id="AmountPaid" type="text" align="right" style="width:100%" value="#Sales.AmountPaid#" validate="float" onClick="checkBalance();">
        
        </div></td>
      <td><div align="right">Account:</div></td>
      <td><div align="left">
        <cfselect name="select" style="width:100%" id="select">
          <cfloop query="Accounts">
            <option value="#AccountID#" <cfif Sales.AccountID is #AccountID#>
    selected </cfif>>#AccountID#</option>
            </cfloop>
          </cfselect>
        </div></td>
    </tr>
    </table></div><br>

  <div align="center" id="formGrid">
  <table width="600" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top">
<cfgrid name="SalesUpdate"  query="SalesDetails"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="600" height="200">

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "ProductID" header = "Products" width="220" headeralign="center" values="#ValueList(Products.ProductID)#" valuesdelimiter=",">
<cfgridcolumn name = "Qty" header = "Quantity" width="80" headeralign="right"  dataalign="right">
<cfgridcolumn name = "UnitPrice" display="Yes" header = "Unit Price" headeralign="right" width="70" dataalign="right">
<cfgridcolumn name = "Discount" display="Yes" header = "Discount" headeralign="right" width="70" dataalign="right">
</cfgrid>
</td>
<td width="56" valign="bottom">
    <cfinput type="submit" name="Update" value="Update">
  </td>
</tr>
</thead>
  </table>
</div>

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

<cfform action="updateInvoice.cfm" enctype="multipart/form-data">
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