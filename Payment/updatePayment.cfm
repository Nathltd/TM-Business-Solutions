<!doctype html>
<html>
<head>
<title><cfoutput>Payments Modify :: #request.title#</cfoutput></title>
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
<h4>Customer Payment Modification<cfif IsDefined("form.search") is True> for <cfoutput>#form.mydate#</cfoutput>
<cfset session.PaymentDate = #form.mydate#></cfif></h4>
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
INSERT into Payments (PaymentID,PaymentDate,Amount,CustomerID,Type,AccountID,Creator) 
VALUES ('#form.PaymentUpdate.PaymentID[counter]#',<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.paymentDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,'#Form.PaymentUpdate.Amount[counter]#','#Form.PaymentUpdate.CustomerID[counter]#','#Form.PaymentUpdate.Type[counter]#','#Form.PaymentUpdate.AccountID[counter]#','#GetAuthUser()#')
</cfquery>
<cfelseif  Form.PaymentUpdate.rowstatus.action[counter]is "U">
<cfquery name="UpdatePaymentUpdate">
UPDATE Payments
SET
PaymentID = '#trim(Form.PaymentUpdate.PaymentID[counter])#',
PaymentDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(session.paymentDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
CustomerID = '#trim(Form.PaymentUpdate.CustomerID[counter])#',
Type = '#trim(form.PaymentUpdate.Type[counter])#',
AccountID = '#trim(form.PaymentUpdate.AccountID[counter])#',
Amount = '#trim(form.PaymentUpdate.Amount[counter])#',
Creator = '#GetAuthUser()#',
LastUpdated = '#lsDateFormat(CreateODBCDate(Now()), "mm/dd/yyyy")#'
WHERE ID = #trim(Form.PaymentUpdate.ID[counter])#
</cfquery>
<cfelseif Form.PaymentUpdate.rowstatus.action[counter] is "D">
<cfquery name="DeletePaymentUpdate">
DELETE from Payments
WHERE ID = #trim(Form.PaymentUpdate.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>
</cftransaction>

<p>
<cfoutput> Payments have been Updated successfully<a href="#cgi.SCRIPT_NAME#"> New Payment </a></cfoutput>
</p>

<cfelse>
<cfif isdefined("form.search") is true>

<cfif #DateDiff("d", "#dateformat(request.clsDate,"dd/mm/yyyy")#","#dateformat(form.mydate,"dd/mm/yyyy")#" )# lt 0>
<cfset form.mydate = #dateformat(form.mydate,"dd/mm/yyyy")#>
<h3>Posting for <cfoutput>#dateformat(form.mydate,"dd-mmm-yyyy")#</cfoutput> not Allowed. Please contact the administrator.</h3>
<cfabort>
</cfif>

<cfquery name="Payments" datasource="#request.dsn#">
SELECT ID,PaymentID,PaymentDate,CustomerID,AccountID,Type,Amount
FROM Payments
WHERE PaymentDate = <cfqueryparam value="#lsDateFormat(CreateODBCDate(form.mydate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">
<cfif #GetUserRoles()# is "Administrator">
<cfelseif #GetUserRoles()# is "Accountant1">
<cfelseif #GetUserRoles()# is "Manager">
<cfelseif #GetUserRoles()# is "Alpha">
  <cfelse>
   AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfif>
</cfquery>


<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>


  <cfquery name="Customers">
SELECT CustomerID
FROM Customers
ORDER BY CustomerID ASC 
  </cfquery>
  
    <cfquery name="PaymentType">
SELECT PaymentType
FROM PaymentType
ORDER BY PaymentType ASC 
  </cfquery>

<div align="center">
<cfif #Payments.recordcount# eq 0>
<br />
There is no payment on <cfoutput><strong> #form.mydate#</strong> </cfoutput><br /><br />
Click <a href="?">here</a> for another Payment Search.

<cfelse>

<div>
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
<div align="right" style="width:500"><a href="?"><font size="+1"> reset</font></a></div>
  </div><br>

  <div align="center">
  <table width="649" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td colspan="6" align="center" valign="top"><cfgrid name="PaymentUpdate"  query="Payments"  insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" selectmode = "Edit" width="650" rowheaders="no" height="250">
<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "PaymentID" header = "Ref ##" width="90" headeralign="center">
<cfgridcolumn name = "CustomerID" header = "Customer" width="120" headeralign="center" values="#ValueList(Customers.CustomerID)#" valuesdelimiter=",">
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

<cfform action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data">

<table width="25%">
 <tr>
<td width="45%" align="right" >Payment Date:</td>
<td width="55%" align="right" >
  <div align="right">
  <cfinput name="mydate" type="datefield" class="mydate" mask="dd/mm/yyyy" id="mydate" placeholder="#lsdateformat(now(),"dd/mm/yyyy")#" tabindex="2" required="yes" message="Enter valid date" autosuggest="off" title="Payment Date"/>
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
</p>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>