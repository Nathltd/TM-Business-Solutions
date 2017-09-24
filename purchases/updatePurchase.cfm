<!doctype html>
<html>
<head>
<title><cfoutput>Purchase Modification :: #request.title#</cfoutput></title>
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
<h4>Purchase Modification</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif IsDefined("form.Update") is True>

<cftransaction>
<cfloop index = "counter" from = "1" to = #arraylen(Form.PurchaseUpdate.rowstatus.action)#>
<cfif Form.PurchaseUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertPurchaseUpdate">
INSERT into PurchaseDetails (ReceiptID,ProductID,Qty,UnitPrice,discount,BranchId) 
VALUES ('#form.InvoiceNo#','#Form.PurchaseUpdate.ProductID[counter]#','#Form.PurchaseUpdate.Qty[counter]#','#Form.PurchaseUpdate.UnitPrice[counter]#','#Form.PurchaseUpdate.discount[counter]#','#trim(form.BranchCode)#')
</cfquery>
<cfelseif  Form.PurchaseUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdatePurchaseUpdate">
UPDATE PurchaseDetails
SET
BranchId = '#trim(form.BranchCode)#',
ProductID = '#trim(Form.PurchaseUpdate.ProductID[counter])#',
Qty = '#trim(Form.PurchaseUpdate.Qty[counter])#',
UnitPrice = '#trim(Form.PurchaseUpdate.UnitPrice[counter])#',
ReceiptID = '#trim(form.InvoiceNo)#',
Discount = '#Form.PurchaseUpdate.discount[counter]#'
WHERE ID = #trim(Form.PurchaseUpdate.ID[counter])#
</cfquery>
<cfelseif Form.PurchaseUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeletePurchaseUpdate">
DELETE from PurchaseDetails
WHERE ID = #trim(Form.PurchaseUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
<cfquery datasource="#request.dsn#">

UPDATE Purchase
SET
ReceiptDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(form.myDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
BranchId = '#trim(form.BranchCode)#',
VendorID = '#trim(form.CustomerCode)#',
StaffID = '#trim(form.RepName)#',
AmountPaid = '#trim(form.AmountPaid)#',
LastUpdated = <cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
Creator = '#GetAuthUser()#',
AccountId = '#trim(form.select)#',
ReceiptID = '#trim(form.InvoiceNob)#'
WHERE ReceiptID = '#(form.InvoiceNo)#'
</cfquery>
</cftransaction>
<br />
<br />

<cfoutput> Invoice No. <strong>#form.InvoiceNob#</strong> have been Updated successfully<a href="../Purchases/UpdatePurchase.cfm"> New Purchase </a></cfoutput>


<cfelse>
<cfif isdefined("form.search") is true>



<cfquery name="Purchase">
select ReceiptID, Creator, receiptDate
from Purchase
WHERE ReceiptID = <cfqueryparam value="#Trim(form.PurchaseID)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfset receiptDate =ValueList(Purchase.receiptDate)>

<cfset closedate = #CreateODBCDate(request.clsDate)#>
<cfset current = #CreateODBCDate(receiptDate)#>
<cfset type = "d">
<cfset DayDiff = #DateDiff(type, closedate, current)#>
<cfif #DayDiff# lte 0>

<h3>This purchase have been closed. Please contact the administrator.</h3>
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
<cfparam name="url.reset" default="">

<cfquery name="Purchase" datasource="#request.dsn#">
SELECT BranchID,ReceiptID,AmountPaid,AccountID,ReceiptDate,VendorID,StaffID
FROM Purchase
WHERE ReceiptID = <cfqueryparam value="#Trim(form.PurchaseID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Manager">
<cfelseif #GetUserRoles()# is "Alpha">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>

<cfquery name="PurchaseDetails" datasource="#request.dsn#">
SELECT ID,ReceiptID,ProductID,Qty,UnitPrice, discount
FROM PurchaseDetails
WHERE ReceiptID = <cfqueryparam value="#Trim(form.PurchaseID)#" cfsqltype="cf_sql_clob">
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
WHERE AccountType = 'Cheque' OR AccountType = 'Cash/Cheque'
ORDER BY AccountID
</cfquery>

<cfquery name="BranchCode">
SELECT BranchID, Description
FROM Branches
ORDER BY BranchID ASC 
</cfquery>
<cfquery name="RepCode">
SELECT FirstName, BranchID FROM Users
WHERE Designation <> 'Alpha'
ORDER BY FirstName 
</cfquery>

  <cfquery name="CustomerCode">
SELECT VendorID
FROM Vendors
ORDER BY VendorID ASC 
  </cfquery>

<cfquery name="Products">
SELECT ProductID FROM Inventory
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

<div align="center">


<div>
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
<div align="right" style="width:500"><a href="../Purchases/updatePurchase.cfm?reset"><font size="+1"> reset</font></a></div><br /><br />
  <table width="70%" border="0">
    <tr>
      <td><div align="left"></div></td>
      <td>&nbsp;</td>
      <td colspan="2" rowspan="4">&nbsp;</td>
      <td><div align="left">Date:</div></td>
      <td><div align="left">
      <cfinput type="datefield" mask="dd/mm/yyyy" value="#Dateformat(Purchase.ReceiptDate,"mm/dd/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Purchase Date" required="yes" message="Enter valid date" />
      
      
       
      </div>
             </td>
    </tr>
    <tr>
      <td><div align="left">Supplier:</div></td>
      <td><div align="left">
        <cfselect name="CustomerCode" id="CustomerCode" tooltip="Employee that signed the invoice" >
            <cfloop query="CustomerCode">
              <option value="#Trim(vendorID)#" <cfif Purchase.VendorID is #vendorID#>
    selected </cfif>>#vendorID#</option>
              </cfloop>
            </cfselect>
               </div></td>
      <td width="91"><div align="left">Branch Name:</div></td>
      <td width="179"><div align="left">

        <cfselect name="BranchCode" id="BranchCode">
            <cfloop query="BranchCode">
           <option value="#Trim(BranchID)#" <cfif Purchase.BranchID is #BranchID#>
    selected </cfif>>#BranchID#</option>
    </cfloop>
        </cfselect>
                    
        </div></td>
      </tr>
      
    <tr>
      <td width="115"><div align="left">Invoice No.
        :</div></td>
      <td width="174"><div align="left">
      <cfinput type="text" name="InvoiceNob" required="yes" value="#Purchase.ReceiptID#" tooltip="Invoice Number" autocomplete="off">
      <cfinput type="hidden" name="InvoiceNo" value="#Purchase.ReceiptID#">
      </div></td>
      <td><div align="left">Authorised:</div></td>
      <td><div align="left">

       		<cfselect name="RepName" id="RepName" tooltip="Employee that signed the invoice">
            <cfloop query="repCode">
           <option value="#Trim(Firstname)#" <cfif Purchase.StaffID is #Firstname#>
    selected </cfif>>#Firstname#</option>
    </cfloop>
        </cfselect>
            
      </div></td>
      </tr>
    <tr>
      <td width="115"><div align="left">Amount Paid
        :</div></td>
      <td width="174"><div align="left">
        <cfinput name="AmountPaid" id="AmountPaid" type="text" align="right" value="#Purchase.AmountPaid#" autocomplete="off">
        
        </div></td>
      <td><div align="left">Account:</div></td>
      <td><div align="left">
        <cfselect name="select" id="select">
          <cfloop query="Accounts">
            <option  value="#trim(AccountID)#" <cfif Purchase.AccountID is #AccountID#>
    selected </cfif>>#AccountID#</option>
            </cfloop>
          </cfselect>
        </div></td>
    </tr>
    </table></div><br>

  <div align="center">
  <table width="60%" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top"><cfgrid name="PurchaseUpdate"  query="PurchaseDetails"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="700">
<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "ProductID" header = "Products" width="260" headeralign="center" values="#ValueList(Products.ProductID)#" valuesdelimiter=",">
<cfgridcolumn name = "Qty" header = "Quantity" width="70" headeralign="right"  dataalign="right">
<cfgridcolumn name = "UnitPrice" display="Yes" header = "Unit Price" headeralign="right" width="70" dataalign="right">
<cfgridcolumn name = "discount" display="Yes" header = "Discount" headeralign="right" width="70" dataalign="right">
</cfgrid>  <br></td>
<td width="56" valign="bottom">
    <cfinput type="submit" name="Update" value="Update">
  </td>
</tr>
</thead>
  </table>
</div>

</cfform>
</cfoutput>
</div></div>
<cfelse>
<cfquery name="Purchase">
select ReceiptID, Creator, receiptDate
from Purchase
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Manager">
<cfelseif #GetUserRoles()# is "Alpha">
  <cfelse>
WHERE Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob"> AND receiptDate >= <cfqueryparam value="#CreateODBCDate(request.clsDate)#" cfsqltype="cf_sql_date">
</cfif>
ORDER BY ReceiptID ASC
</cfquery>
<cfset Purchase=ValueList(Purchase.ReceiptID)>
<cfset validPurchases = #Listlen(Purchase)#>

<cfif #validPurchases# eq 0>

<h3>You have no Item to update. Please contact the administrator.</h3>
<cfabort>
</cfif>

<br />

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table width="30%" border="0">
 <tr>
<td width="50%" align="right" >Purchase No:</td>
<td width="50%">
  <cfinput type="text" name="PurchaseID" autosuggest="#Purchase#"  autosuggestminlength="2">
</td>
    </tr>
    <tr>
    <td></td>
    <td>
        <cfinput type="submit" name="Search" value="Search">
        </td>
    </tr>
  </table>
  </cfform>
</cfif>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>