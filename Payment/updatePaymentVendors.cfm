<!doctype html>
<html>
<head>
<title><cfoutput>Payments Modify (Suppliers) :: #request.title#</cfoutput></title>
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
<h4>Payment to Supplier Modification<cfif IsDefined("form.search") is True> for <cfoutput>#form.paymentDate#</cfoutput>
<cfset session.PaymentDate = #form.paymentDate#></cfif></h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Stock Keeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Manager'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfif IsDefined("form.Update") is True>

<cftransaction>
<cfloop index = "counter" from = "1" to = #arraylen(Form.PaymentUpdate.rowstatus.action)#>
<cfif Form.PaymentUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertPaymentUpdate">
INSERT into PaymentsVendors (PaymentID,PaymentDate,Amount,VendorID,Type,AccountID,Creator) 
VALUES ('#form.PaymentUpdate.PaymentID[counter]#', '#lsDateFormat(CreateODBCDate(session.paymentDate),"dd/mm/yyyy")#','#Form.PaymentUpdate.Amount[counter]#','#Form.PaymentUpdate.VendorID[counter]#','#Form.PaymentUpdate.Type[counter]#','#Form.PaymentUpdate.AccountID[counter]#','#GetAuthUser()#')
</cfquery>
<cfelseif  Form.PaymentUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdatePaymentUpdate">
UPDATE PaymentsVendors
SET
PaymentID = '#trim(Form.PaymentUpdate.PaymentID[counter])#',
PaymentDate = '#lsDateFormat(CreateODBCDate(session.PaymentDate), "dd/mm/yyyy")#',
VendorID = '#trim(Form.PaymentUpdate.VendorID[counter])#',
Type = '#trim(form.PaymentUpdate.Type[counter])#',
AccountID = '#trim(form.PaymentUpdate.AccountID[counter])#',
Amount = '#trim(form.PaymentUpdate.Amount[counter])#',
Creator = '#GetAuthUser()#',
LastUpdated = '#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#'
WHERE ID = #trim(Form.PaymentUpdate.ID[counter])#
</cfquery>
<cfelseif Form.PaymentUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeletePaymentUpdate">
DELETE from PaymentsVendors
WHERE ID = #trim(Form.PaymentUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
</cftransaction>

<p>
<cfoutput> Payments have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> Edit Payment </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>


<cfquery name="Payments" datasource="#request.dsn#">
SELECT ID,PaymentID,PaymentDate,VendorID,AccountID,Type,Amount
FROM PaymentsVendors
WHERE PaymentDate = <cfqueryparam value="#Trim(dateformat(form.PaymentDate,"dd/mm/yyyy"))#" cfsqltype="cf_sql_clob">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "staff">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>


  <cfquery name="Vendors">
SELECT VendorID
FROM Vendors
ORDER BY VendorID ASC 
  </cfquery>
  
    <cfquery name="PaymentType">
SELECT PaymentType
FROM PaymentType
ORDER BY PaymentType ASC 
  </cfquery>

<div align="center">
<cfif #Payments.recordcount# eq 0>
<br />
There is no payment on <cfoutput><strong> #form.PaymentDate#</strong> </cfoutput><br /><br />
Click <a href="?">here</a> for another Payment Search.

<cfelse>

<div>
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
<div align="right" style="width:500"><a href="?"><font size="-1"> reset</font></a></div>
  </div><br>

  <div align="center">
  <table width="471" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top"><cfgrid name="PaymentUpdate"  query="Payments"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="550" rowheaders="no">
<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "PaymentID" header = "Ref ##" width="90" headeralign="center">
<cfgridcolumn name = "VendorID" header = "Supplier" width="120" headeralign="center" values="#ValueList(Vendors.VendorID)#" valuesdelimiter=",">
<cfgridcolumn name = "AccountID" header = "Account" width="120" headeralign="center" values="#ValueList(Accounts.AccountID)#" valuesdelimiter=",">
<cfgridcolumn name = "Type" header = "Type" width="80" headeralign="right" values="#ValueList(PaymentType.PaymentType)#" valuesdelimiter=",">
<cfgridcolumn name = "Amount" header = "Amount" width="100" headeralign="right"  dataalign="right">
</cfgrid>  <br></td>
<td width="56" valign="bottom">
    <cfinput type="submit" name="Update" value="Update" class="bold_10pt_button">
  </td>
</tr>
</thead>
  </table>
</div>

</cfform>
</cfoutput>
</div>
</cfif>
</div>
<cfelse>


<br />

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table width="221">
 <tr>
<td width="82" align="right" >Payment Date:</td>
<td width="115" align="right" >
  <div align="right">
  <cfinput type="datefield" mask="dd/mm/yyyy" name="PaymentDate" class="mydate" id="mydate" placeholder="#lsdateformat(now(),"dd/mm/yyyy")#" tabindex="2" required="yes" message="Enter valid date" autosuggest="off"/>
  </div>
</td>
    </tr>
    <tr>
    <td colspan="2" align="right">
      <div align="right">
        <cfinput type="submit" name="Search" value="Search" class="bold_10pt_button">
      </div></td>
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