<!doctype html>
<html>
<head>
<title><cfoutput>Fund Transfer Modification :: #request.title#</cfoutput></title>
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
<h4>Fund Transfer Modification<cfif IsDefined("form.search") is True> for <cfoutput>#form.mydate#</cfoutput>
<cfset session.TransferDate = #form.mydate#></cfif></h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is 'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelse>

<p>
<cfif IsDefined("form.Update") is True>

<cftransaction>
<cfloop index = "counter" from = "1" to = #arraylen(Form.PaymentUpdate.rowstatus.action)#>
<cfif Form.PaymentUpdate.rowstatus.action[counter] is "I">
<cfquery name="InsertPaymentUpdate">
INSERT into FundTransfers (TransferID,TransferDate,StaffID,SourceID,DestineID,Amount,Creator,LastUpdated) 
VALUES ('#form.PaymentUpdate.TransferID[counter]#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.TransferDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,'#Form.PaymentUpdate.StaffID[counter]#','#Form.PaymentUpdate.SourceID[counter]#','#Form.PaymentUpdate.DestineID[counter]#','#Form.PaymentUpdate.Amount[counter]#','#GetAuthUser()#',<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">)
</cfquery>
<cfelseif  Form.PaymentUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdatePaymentUpdate">
UPDATE FundTransfers
SET
TransferID = '#trim(Form.PaymentUpdate.TransferID[counter])#',
TransferDate = <cfqueryparam value="#CreateODBCDate(session.TransferDate)#" cfsqltype="cf_sql_date">,
StaffID = '#trim(Form.PaymentUpdate.StaffID[counter])#',
Amount = '#trim(form.PaymentUpdate.Amount[counter])#',
SourceID = '#trim(form.PaymentUpdate.SourceID[counter])#',
DestineID = '#trim(form.PaymentUpdate.DestineID[counter])#',
Creator = '#GetAuthUser()#',
LastUpdated = <cfqueryparam value="#CreateODBCDate(Now())#" cfsqltype="cf_sql_date">
WHERE ID = #trim(Form.PaymentUpdate.ID[counter])#
</cfquery>
<cfelseif Form.PaymentUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeletePaymentUpdate">
DELETE from FundTransfers
WHERE ID = #trim(Form.PaymentUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
</cftransaction>

<p>
<cfoutput> Transfer have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> Update Another Transfer </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>


<cfquery name="Transfers">
SELECT ID,TransferID,StaffID,SourceID,DestineID,Amount
FROM FundTransfers
WHERE TransferDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(form.mydate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Accountant1">
<cfelseif #GetUserRoles()# is "manager">
<cfelseif #GetUserRoles()# is "alpha">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>


  <cfquery name="Staff">
SELECT StaffID
FROM Staff
ORDER BY StaffID ASC 
  </cfquery>


<div align="center">
<cfif #Transfers.recordcount# eq 0>
<br />
There is no Fund Transfer on <cfoutput><strong> #form.mydate#</strong> </cfoutput><br /><br />
Click <a href="?">here</a> for another Transfer Search.

<cfelse>

<div>
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
<div align="right" style="width:500"><a href="?"><font size="-1"> reset</font></a></div>
  </div><br>

  <div align="center">
  <table width="600" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top"><cfgrid name="PaymentUpdate"  query="Transfers"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="480" rowheaders="no">
<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "TransferID" header = "Ref ##" width="90" headeralign="center">
<cfgridcolumn name = "StaffID" header = "Staff" width="120" headeralign="center" values="#ValueList(Staff.StaffID)#" valuesdelimiter=",">
<cfgridcolumn name = "SourceID" header = "Source" width="80" headeralign="right" values="#ValueList(Accounts.AccountID)#" valuesdelimiter=",">
<cfgridcolumn name = "DestineID" header = "Destination" width="80" headeralign="right" values="#ValueList(Accounts.AccountID)#" valuesdelimiter=",">
<cfgridcolumn name = "Amount" header = "Amount" width="100" headeralign="right"  dataalign="right">
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
</div>
</cfif>
</div>
<cfelse>

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table width="35%">
 <tr>
<td width="55%" align="right" >Transfer Date:</td>
<td width="45%" align="right" >
  <div align="right"><cfinput type="datefield" mask="dd/mm/yyyy" name="mydate" class="mydate" id="mydate" placeholder="#lsdateformat(now(),"dd/mm/yyyy")#" tabindex="2" required="yes" message="Enter valid date" autosuggest="off"/></div>
</td>
    </tr>
    <tr>
    <td></td>
    <td>
      
        <cfinput type="submit" name="Search" value="Search" style="width:70%">
      </td>
    </tr>
  </table>
  </cfform>
</cfif>
</cfif>
</p>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>