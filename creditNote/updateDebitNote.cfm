<!doctype html>
<html>
<head>
<title><cfoutput>Debit Note Modification  :: #request.title#</cfoutput></title>
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
<h4>Debit Note Modification</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif IsDefined("form.Update") is True>

<cftransaction>

<cfquery>
UPDATE DebitNote
SET
DebitNoteDate = '#lsDateFormat(CreateODBCDate(form.myDate), "dd/mm/yyyy")#',
VendorId = '#trim(form.VendorCode)#',
StaffID = '#trim(form.RepName)#',
LastUpdated = '#lsDateFormat(CreateODBCDate(now()), "mm/dd/yyyy")#',
Creator = '#GetAuthUser()#',
BranchID = '#trim(form.select)#',
ApplyAs = '#trim(form.ApplyAs)#',
DebitNoteID = '#trim(Form.InvoiceNo)#'
WHERE DebitNoteID = '#trim(Form.InvoiceNob)#'
</cfquery>

<cfloop index = "counter" from = "1" to = #arraylen(Form.DebitNoteUpdate.rowstatus.action)#>
<cfif Form.DebitNoteUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertDebitNoteDetails">
INSERT into DebitNoteDetails (DebitNoteID,ProductID,Qty,UnitPrice) 
    VALUES ('#form.InvoiceNo#','#Form.DebitNoteUpdate.ProductID[counter]#','#Form.DebitNoteUpdate.Qty[counter]#','#Form.DebitNoteUpdate.UnitPrice[counter]#')
</cfquery>
<cfelseif  Form.DebitNoteUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdateDebitNoteDetails">
UPDATE DebitNoteDetails
SET
ProductID = '#trim(Form.DebitNoteUpdate.ProductID[counter])#',
Qty = '#trim(Form.DebitNoteUpdate.Qty[counter])#',
UnitPrice = '#trim(Form.DebitNoteUpdate.UnitPrice[counter])#',
DebitNoteID = '#trim(form.InvoiceNo)#'
WHERE ID = #trim(Form.DebitNoteUpdate.ID[counter])#
</cfquery>
<cfelseif Form.DebitNoteUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeleteDebitNoteDetails">
DELETE from DebitNoteDetails
WHERE ID = #trim(Form.DebitNoteUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
</cftransaction>
<p>

<cfoutput> Invoice No. <strong>#form.InvoiceNo#</strong> have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> New Debit Note </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>

<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="form.AmountPaid" default="">
<cfparam name="session.AmountPaid" default="form.AmountPaid">
<cfparam name="session.VendorCode" default="">
<cfparam name="session.InvoiceNo" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchCode" default="">
<cfparam name="session.RepCode" default="">
<cfparam name="session.select" default="">
<cfparam name="url.reset" default="">

<cfquery name="DebitNote">
SELECT BranchID,DebitNoteID,DebitNoteDate,vendorID,StaffID, ApplyAs, Creator
FROM DebitNote
WHERE DebitNoteID = <cfqueryparam value="#Trim(form.DebitNoteID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "alpha">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>

<cfquery name="DebitNoteDetails">
SELECT ID,DebitNoteID,ProductID,Qty,UnitPrice
FROM DebitNoteDetails
WHERE DebitNoteID = <cfqueryparam value="#Trim(form.DebitNoteID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "alpha">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>

<cfquery name="BranchCode">
SELECT BranchID
FROM Branches
ORDER BY BranchID ASC 
</cfquery>
<cfquery name="RepCode">
SELECT firstname
FROM users
ORDER BY firstname ASC
</cfquery>

  <cfquery name="VendorCode">
SELECT vendorID
FROM vendors
ORDER BY vendorId ASC 
  </cfquery>

<cfquery name="Products">
SELECT ProductID
FROM Inventory
ORDER BY ProductID
</cfquery>
<cfoutput>
<div align="center">
<strong> Debit Note Modification</strong> - <a href="#cgi.SCRIPT_NAME#?reset"><font size="+1"> reset</font></a><br /><br />

<div align="center">



<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="56%" border="0">
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td colspan="2" rowspan="4">&nbsp;</td>
      <td><div align="right">Date:</div></td>
      <td width="200"><div align="left">
      <cfinput type="datefield" style="width:100%" mask="dd/mm/yyyy" value="#Dateformat(DebitNote.DebitNoteDate,"mm/dd/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Transfer Date" required="yes" message="Enter valid date"/>

       
      </div>
             </td>
    </tr>
    <tr>
      <td width="111"><div align="right">Vendor Name:</div></td>
      <td><div align="left">
        <cfselect name="VendorCode" id="VendorCode" title="Vendor's Name" style="width:100%" >
            <cfloop query="VendorCode">
              <option value="#Trim(VendorID)#" <cfif DebitNote.VendorID is #VendorID#>
    selected </cfif>>#VendorID#</option>
              </cfloop>
            </cfselect>
               </div></td>
      <td width="69"><div align="right">Branch:</div></td>
      <td width="200"><div align="left">

        <cfselect name="BranchCode" id="BranchCode" style="width:100%">
            <cfloop query="BranchCode">
           <option value="#Trim(BranchID)#" <cfif DebitNote.BranchID is #BranchID#>
    selected </cfif>>#BranchID#</option>
    </cfloop>
        </cfselect>
                    
        </div></td>
      </tr>
      
    <tr>
      <td width="111"><div align="right">Invoice No.
        :</div></td>
      <td width="164"><div align="left">
      <cfinput type="text" name="InvoiceNo"  required="yes" style="width:100%" value="#DebitNote.DebitNoteID#" tooltip="Debit Note Number" autocomplete="off">
      <cfinput type="hidden" name="InvoiceNob"  required="yes" value="#DebitNote.DebitNoteID#">
      </div></td>
      <td><div align="right">Authorised:</div></td>
      <td><div align="left">

       		<cfselect name="RepName" style="width:100%" id="RepName" tooltip="Employee that signed the invoice">
            <cfloop query="repCode">
           <option value="#Trim(firstname)#" <cfif DebitNote.StaffID is #firstname#>
    selected </cfif>>#firstname#</option>
    </cfloop>
        </cfselect>
            
      </div></td>
      </tr>
    <tr>
      
      <td width="111"><div align="right">
        Apply As:</div></td>
      <td width="164"><div align="left">
      <cfselect name="ApplyAs" id="ApplyAs" style="width:100%">
            <option value="Returned"selected>Returned</option>
          </cfselect>
      
       
        
        </div></td>
       
      <td><div align="right">Account:</div></td>
      <td><div align="left">
        <cfselect name="select" style="width:100%" id="select" bind="cfc:#request.cfc#cfc.bind.getBankAccounts({BranchCode})" display="AccountID" value="AccountID" bindonload="yes">
          
          </cfselect>
        </div></td>
    </tr>
    </table></div><br>

  <div align="center">
  <table width="50%" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top">
<cfgrid name="DebitNoteUpdate"  query="DebitNoteDetails"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="600" height="250">

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "ProductID" header = "Products" width="220" headeralign="center" values="#ValueList(Products.ProductID)#" valuesdelimiter=",">
<cfgridcolumn name = "Qty" header = "Quantity" width="60" headeralign="right"  dataalign="right">
<cfgridcolumn name = "UnitPrice" display="Yes" header = "Unit Price" headeralign="right" width="70" dataalign="right">
</cfgrid><br></td>
<td width="56" valign="bottom">
    <cfinput type="submit" name="Update" value="Update">
  </td>
</tr>
</thead>
  </table>
</div>

</cfform>
</cfoutput>
</div>
</div>

<cfelse>
<cfquery name="DebitNote">
select DebitNoteID, Creator
from DebitNote
<cfif #GetUserRoles()# is "Administrator" AND #GetUserRoles()# is "Alpha">
<cfelseif #GetUserRoles()# is "staff">
  <cfelse>
WHERE Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
ORDER BY DebitNoteID ASC
</cfquery>
<cfif #DebitNote.recordCount# eq 0>
	<h2>No Debit Note created by this User</h2>
<cfabort>
	</cfabort>
	</cfif>
<cfset DebitNote=ValueList(DebitNote.DebitNoteID)>
<p>
<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="25%">
 <tr>
<td width="45%" align="right" >D/note No:</td>
<td width="55%" align="left" >
  <cfinput type="text" name="DebitNoteID" required="yes" autosuggest="#DebitNote#" autosuggestminlength="2">
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
    </p>
    </cfif>
    </cfif>
    </cfif>
    </div>
    </div>
    </div>
    </body>
    </html>