<!doctype html>
<html>
<head>
<title><cfoutput>Credit Note Modification  :: #request.title#</cfoutput></title>
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
<h4>Credit Note Modification</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif IsDefined("form.Update") is True>

<cftransaction>

<cfquery>
UPDATE CreditNote
SET
CreditNoteDate = '#lsDateFormat(CreateODBCDate(form.myDate), "dd/mm/yyyy")#',
CustomerId = '#trim(form.CustomerCode)#',
StaffID = '#trim(form.RepName)#',
LastUpdated = '#lsDateFormat(CreateODBCDate(now()), "dd/mm/yyyy")#',
Creator = '#GetAuthUser()#',
BranchID = '#trim(form.select)#',
ApplyAs = '#trim(form.ApplyAs)#',
CreditNoteID = '#trim(Form.InvoiceNo)#'
WHERE CreditNoteID = '#trim(Form.InvoiceNob)#'
</cfquery>

<cfloop index = "counter" from = "1" to = #arraylen(Form.CreditNoteUpdate.rowstatus.action)#>
<cfif Form.CreditNoteUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertCreditNoteDetails">
INSERT into CreditNoteDetails (CreditNoteID,ProductID,Qty,UnitPrice) 
    VALUES ('#form.InvoiceNo#','#Form.CreditNoteUpdate.ProductID[counter]#','#Form.CreditNoteUpdate.Qty[counter]#','#Form.CreditNoteUpdate.UnitPrice[counter]#')
</cfquery>
<cfelseif  Form.CreditNoteUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdateCreditNoteDetails">
UPDATE CreditNoteDetails
SET
ProductID = '#trim(Form.CreditNoteUpdate.ProductID[counter])#',
Qty = '#trim(Form.CreditNoteUpdate.Qty[counter])#',
UnitPrice = '#trim(Form.CreditNoteUpdate.UnitPrice[counter])#',
CreditNoteID = '#trim(form.InvoiceNo)#'
WHERE ID = #trim(Form.CreditNoteUpdate.ID[counter])#
</cfquery>
<cfelseif Form.CreditNoteUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeleteCreditNoteDetails">
DELETE from CreditNoteDetails
WHERE ID = #trim(Form.CreditNoteUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
</cftransaction>
<p>

<cfoutput> Invoice No. <strong>#form.InvoiceNo#</strong> have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> New Credit Note </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>

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

<cfquery name="CreditNote">
SELECT BranchID,CreditNoteID,CreditNoteDate,CustomerID,StaffID, ApplyAs, Creator
FROM CreditNote
WHERE CreditNoteID = <cfqueryparam value="#Trim(form.CreditNoteID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Alpha">
<cfelseif #GetUserRoles()# is "Cashier">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>

<cfquery name="CreditNoteDetails">
SELECT ID,CreditNoteID,ProductID,Qty,UnitPrice
FROM CreditNoteDetails
WHERE CreditNoteID = <cfqueryparam value="#Trim(form.CreditNoteID)#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Alpha">
<cfelseif #GetUserRoles()# is "staff">
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

  <cfquery name="CustomerCode">
SELECT CustomerID
FROM Customers
ORDER BY CustomerID ASC 
  </cfquery>

<cfquery name="Products">
SELECT ProductID
FROM Inventory
ORDER BY ProductID
</cfquery>

<div align="center">
<strong> Credit Note Modification</strong> - <a href="../CreditNote/updateCreditNote.cfm?reset"><font size="+1"> reset</font></a><br /><br />

<div align="center">
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="850" border="0">
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td colspan="2" rowspan="4">&nbsp;</td>
      <td><div align="right">Date:</div></td>
      <td width="200"><div align="left">
      <cfinput type="datefield" class="bold_10pt_Date" mask="dd/mm/yyyy" value="#Dateformat(CreditNote.CreditNoteDate,"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Transfer Date" required="yes" message="Enter valid date"/>

       
      </div>
             </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td width="150"><div align="right">Customer Name:</div></td>
      <td><div align="left">
        <cfselect name="CustomerCode" class="bold_10pt_black" id="CustomerCode" tooltip="Customer's Name" >
            <cfloop query="CustomerCode">
              <option value="#Trim(customerID)#" <cfif CreditNote.customerID is #customerID#>
    selected </cfif>>#CustomerID#</option>
              </cfloop>
            </cfselect>
               </div></td>
      <td width="64"><div align="right">Branch:</div></td>
      <td width="100"><div align="left">

        <cfselect name="BranchCode" id="BranchCode" class="bold_10pt_black">
            <cfloop query="BranchCode">
           <option value="#Trim(BranchID)#" <cfif CreditNote.BranchID is #BranchID#>
    selected </cfif>>#BranchID#</option>
    </cfloop>
        </cfselect>
                    
        </div></td>
      </tr>
      
    <tr>
      <td width="10">&nbsp;</td>
      <td width="125"><div align="right">Invoice No.
        :</div></td>
      <td width="122"><div align="left">
      <cfinput type="text" name="InvoiceNo"  required="yes" class="bold_10pt_black" value="#CreditNote.CreditNoteID#" tooltip="Credit Note Number" autocomplete="off">
      <cfinput type="hidden" name="InvoiceNob"  required="yes" value="#CreditNote.CreditNoteID#">
      </div></td>
      <td><div align="right">Authorised:</div></td>
      <td><div align="left">

       		<cfselect name="RepName" class="bold_10pt_black" id="RepName" tooltip="Employee that signed the invoice">
            <cfloop query="repCode">
           <option value="#Trim(firstname)#" <cfif CreditNote.StaffID is #firstname#>
    selected </cfif>>#firstname#</option>
    </cfloop>
        </cfselect>
            
      </div></td>
      </tr>
    <tr>
      <cfquery name="ApplyAs">
        Select Type
        From CreditnoteType
        Order by Type
        </cfquery>
      <td width="10">&nbsp;</td>
      <td width="125"><div align="right">
        Apply As:</div></td>
      <td width="122"><div align="left">
      <cfselect name="ApplyAs" class="bold_10pt_black" id="ApplyAs">
          <cfloop query="ApplyAs">
            <option value="#Type#" <cfif CreditNote.ApplyAs is #Type#>
    selected </cfif>>#Type#</option>
            </cfloop>
          </cfselect>
      
       
        
        </div></td>
       
      <td><div align="right">Account:</div></td>
      <td><div align="left">
        <cfselect name="select" class="bold_10pt_black" id="select" bind="cfc:#request.cfc#cfc.bind.getBankAccounts({BranchCode})" display="AccountID" value="AccountID" bindonload="yes">
          
          </cfselect>
        </div></td>
    </tr>
    </table></div><br>

  <div align="center">
  <table width="471" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top">
<cfgrid name="CreditNoteUpdate"  query="CreditNoteDetails"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="600" height="250">

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
<cfquery name="CreditNote">
select CreditNoteID, Creator
from CreditNote
<cfif #GetUserRoles()# is "Administrator" OR #GetUserRoles()# is "Alpha">
<cfelseif #GetUserRoles()# is "staff">
  <cfelse>
WHERE Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
ORDER BY CreditNoteID ASC
</cfquery>
<cfif #creditNote.recordCount# eq 0>
	<h2>No Credit Note created by this User</h2>
<cfabort>
	</cfabort>
	</cfif>
<cfset CreditNote=ValueList(CreditNote.CreditNoteID)>
<p>
<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">
<table width="25%">
 <tr>
<td width="45%" align="right" >C/note No:</td>
<td width="55%" align="left" >
  <cfinput type="text" name="CreditNoteID" required="yes" autosuggest="#CreditNote#" class="bold_10pt_black" autosuggestminlength="2">
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