<!doctype html>
<html>
<head>
<title><cfoutput>Fund Transfer :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../style.js"></script>
<script src="checkDup.js" type="application/javascript"></script>
<script src="googleJquery-min.js"></script>
<script type="text/javascript">
	$(document).ready(function($) {
		
		$.ajax({
	   url:"../cfc/bind.cfc?method=getBankAccount&returnFormat=json",
	   dataType:"json",
	   async: false,
	   cache: false,
	   dataFilter: function(data) {
				data = JSON.parse(data);
		   myData = data.DATA;
		   var options = "";
     for (var i = 0; i < myData.length; i++) {
         options += "<option>" + myData[i] + "</option>";
     }
		   $("#SourceID").html(options);
			},

    });

  $('#SourceID').change(function(e) {
    var selectvalue = $(this).val();
		$.ajax({
	   url:"../cfc/bind.cfc?method=getAcctBalance&SourceID=" + selectvalue + "&returnFormat=json",
	   dataType:"json",
	   async: false,
	   cache: false,
	   dataFilter: function(data) {
				data = JSON.parse(data);
		   myData = data;
		   
		   $("#Amount").attr("placeholder", myData);
		   
			},

    });
		  

 });
});
</script>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Fund Transfers</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Cashier'AND #GetUserRoles()# is not 'Alpha'AND #GetUserRoles()# is not 'Sales Cashier'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="url.Sales" default="">
<cfif url.Sales is "yes">

<cfset structdelete(session, 'SourceID')>
<cfset structdelete(session, 'DesstineID')>
<cfset structdelete(session, 'TransferDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'details')>
<cfset structdelete(session, 'amount')>

 <cftransaction>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery>
INSERT INTO FundTransfers
(SourceID,DestineID,TransferDate,TransferID,StaffID,amount,LastUpdated,Creator,remark)
VALUES ('#session.myInvoice[variables.counter].SourceID#', '#session.myInvoice[variables.counter].DestineID#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.myInvoice[variables.counter].TransferDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
  '#session.myInvoice[variables.counter].ref#', '#session.myInvoice[variables.counter].StaffID#', 
  '#session.myInvoice[variables.counter].amount#',<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.todate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">, 
  '#GetAuthUser()#', '#session.myInvoice[variables.counter].remark#')
</cfquery>
</cfloop>
</cftransaction>

<p>
<cfoutput> Funds Transfer posted successfully <a href="#cgi.SCRIPT_NAME#"> New Fund Transfers</a></cfoutput>
</p>
<cfset structdelete(session, 'SourceID')>
<cfset structdelete(session, 'DestineID')>
<cfset structdelete(session, 'TransferDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'amount')>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>

<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmount" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="url.reset" default="">

<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].SourceID = #form.SourceID#>
<cfset session.myInvoice[position].DestineID = #form.DestineID#>
<cfset session.myInvoice[position].TransferDate = #form.mydate#>
<cfset session.myInvoice[position].ref = #form.ref#>
<cfset session.myInvoice[position].Amount = #form.Amount#>
<cfset session.myInvoice[position].StaffID = #form.StaffID#>
<cfset session.myInvoice[position].remark = #form.remark#>
<cfset session.totalAmountSum = #form.totalAmount#>
<cfset todayDate = #dateformat(now(),"mm/dd/yyyy")#>
<cfset session.todate = #todayDate#>
<!--- Remove items from invoice list --->
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.myInvoice#,#url.id#)#>
<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>
<cfset structdelete(session, 'SourceID')>
<cfset structdelete(session, 'DestineID')>
<cfset structdelete(session, 'TransferDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'Amount')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'remark')>
<cfset structdelete(session, 'totalAmountSum')>
</cfif>

<div align="center">

<div align="center">
<cfoutput>

<br>

<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center"></div>
  <div align="center">
  <table width="90%" bgcolor="##D5EAFF" border="0" cellpadding="3" cellspacing="0" bordercolor="999999">
<thead>
<tr>
<td width="17%" colspan="2"><strong>Source</strong></td>
<td width="17%"><strong>Destination</strong></td>
<td width="8%"><strong>Date</strong></td>
<td width="7%"> <strong>Ref. ##</strong></td>
<td width="10%"> <strong>Details</strong></td>
<td hidden="hidden"> <strong> Authorised</strong></td>
<td width="8%"><strong>Amount</strong></td>
<td width="5%">&nbsp;</td>
</tr>
</thead>
<tbody>

<tr>

<td colspan="2" valign="top"><select name="SourceID" id="SourceID" required="yes" style="width:100%"> </select></td>

<td valign="top"><cfselect name="DestineID" id="DestineID" required="yes" bind="cfc:#request.cfc#cfc.bind.getChequeAccount({SourceID})" display="AccountID" value="AccountID" bindonload="yes" tabindex="2" style="width:100%"> </cfselect></td>

<td>
<cfinput type="datefield" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Invoice Date" required="yes" message="Enter Invoice Date" autocomplete="off" style="width:100%"/> </td>

<td valign="top"> <cfinput type="text" name="ref" message="Enter Cheque/Ref No., Figures only." required="yes" id="ref" tabindex="4" autocomplete="off" style="width:100%" validate="integer">
<span id="msg">&nbsp;Ref ## already exist</span></td>
<td valign="top"> <cfinput type="text" name="remark" message="Enter Remark" required="yes" id="remark" tabindex="5" autocomplete="off" style="width:100%"> </td>
<cfquery name="user">
select firstName from users
where userid = '#GetAuthUser()#'
</cfquery>
<td hidden="hidden"><cfinput type="text" name="StaffID" id="StaffID" required="yes"  message="Select Type" tabindex="6" value="#user.firstName#" style="width:100%">
</td>
    
<td align="center" valign="top"> <div align="right">
  <cfinput type="text" name="Amount" id="Amount" validate="float" tabindex="7" style="text-align:right;width:100%" required="yes" message="Enter Amount Paid" autocomplete="off">
</div></td>

<td align="center" valign="top"> <div align="right"> <cfinput type="submit" name="addInvoice" value="Add" tabindex="8" style="width:80%"></div></td>

</tr>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left" valign="top" colspan="2"> <div align="left">#session.myInvoice[variables.counter].SourceID# </div></td>
<td align="left" valign="top"> <div align="left">#session.myInvoice[variables.counter].DestineID# </div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].TransferDate# </div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].ref#</div></td>
<td align="right" valign="top"> <div align="left">#session.myInvoice[variables.counter].remark#</div></td>
<td align="right" valign="top" hidden="hidden"> <div align="left">#session.myInvoice[variables.counter].StaffID#</div></td>
<td align="right" valign="top"><div align="right"> #LSNumberFormat(session.myInvoice[variables.counter].Amount,',999999999999999999.99')#</div> </td>
<td> <div align="right" title="Remove this Item"><a href="#cgi.SCRIPT_NAME#?id=#counter#"><font color="##FF0000"><strong>X</strong></font></a>&nbsp; </div></td>
</tr>
</cfloop> 
<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.totalAmount,#form.Amount#)>
<cfset position = arraylen(session.totalAmount)>
<cfset session.totalAmount[position] = #form.Amount#>
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.totalAmount#,#url.id#)#>
</cfif>
<cfset Amount = #arraySum(session.totalAmount)#>
<cfset session.Amount = #Amount#>
<tr>
  <td colspan="6" align="right"><div align="right"><strong>Total:&nbsp;</strong></div></td>
  <td align="right"><div align="right">
   <strong>#LSNumberFormat(Amount,',99999999.99')#</strong>
    <cfinput type="hidden" name="totalAmount" id="totalAmount" class="stnd_10pt_style"  validate="float" value="#Amount#" style="text-align:right">
  </div></td>
  <td align="center"><div align="right"><a href="#cgi.SCRIPT_NAME#?reset=1"><strong>Reset</strong></a>&nbsp;<a href="#cgi.SCRIPT_NAME#?sales=yes"><strong>Post</strong></a></div></td>
</tr>
</tbody>
</table>
</div>
<cfif url.reset is "1">
<cfset structdelete(session, 'SourceID')>
<cfset structdelete(session, 'DestineID')>
<cfset structdelete(session, 'TransferDate')>
<cfset structdelete(session, 'ref')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'amount')>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>
</cfif>

</cfform></cfoutput>
</div></div>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>