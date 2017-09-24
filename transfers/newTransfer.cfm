<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><cfoutput>Goods Transfer ::: #request.title#</cfoutput></title>
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
<h4>New Product Transfer</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>
<cfparam name="url.Transfer" default="">
<cfif url.Transfer is "yes">

<cftransaction>
<cfquery name="data" maxrows="1">
select transferid from transfers
where transferid not like '%m%'
order by id desc
</cfquery>

<cfset InvNumber =ValueList(data.transferid)>
<cfif #InvNumber# is "">
<cfset #invNumber# = 1>
<cfelse>
<!---<cfset InvNumber = #InvNumber#+1>--->
</cfif>

<cfif #session.TransferNo# lte #invNumber#>
<cfset #session.TransferNo# = #invNumber#+1>
<cfset #session.TransferNo# = #ToString(session.TransferNo)#>
</cfif>

<cfquery>

INSERT INTO Transfers
(AccountId,TransferID,TransferDate,Source,Destination,StaffID,LastUpdated,Creator)
VALUES ('#session.Account#', '#session.TransferNo#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(session.myDate), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">, '#session.SourceBr#', '#session.DestineBr#', '#session.repCode#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">, '#GetAuthUser()#')
</cfquery>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery>

INSERT INTO TransferDetails
(ProductID, Quantity, TransferID, UnitPrice)
VALUES ('#session.myInvoice[variables.counter].Name#',
'#session.myInvoice[variables.counter].itemQuantity#', 
'#session.TransferNo#', '#session.myInvoice[variables.counter].ItemPrice#')
</cfquery>
</cfloop>

</cftransaction>
<br>
<br>
<cfoutput> Transfer No. <strong>#session.TransferNo#</strong> have been posted successfully<a href="#cgi.SCRIPT_NAME#"> New Transfer </a></cfoutput>
<br>
<br>


<table class="font2">
<cfoutput> 
<tr>
<td><div align="right">Authorised by:</div></td><td><strong> #session.RepCode#</strong></td>
<td></td>
<td><div align="right">Transfer No:</div></td><td><strong> #session.TransferNo#</strong></td>
<td width="20"> </td>
<td colspan="1"><div align="right">Transfer Date:</div></td><td><strong> #session.mydate#</strong></td>
</tr>
<tr>
<td><div align="right"></div></td><td><div align="left"><strong> </strong></div></td>
<td></td>
<td><div align="right">Source Branch:</div></td><td><div align="left"><strong> #session.SourceBr#</strong></div></td>
<td></td>
<td>Destination Branch:</td><td><strong> #session.DestineBr#</strong></td>


</tr>

<tr align="center">
<td height="10"> <div align="right"></div></td>

</tr>
<tr align="center">
<td colspan="3"> <div ><strong>Item Name</strong></div></td>
<td colspan="3"> <strong>Description</strong></td>
<td colspan="3"> <strong>Quantity</strong></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="center" colspan="3"> <div>#session.myInvoice[variables.counter].Name# </div></td>
<td align="center" colspan="3"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="center" colspan="3"> #session.myInvoice[variables.counter].itemQuantity# </td>

</tr>
</cfloop>
</cfoutput>
</table>
<br />
<br />



<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">

<cfparam name="url.reset" default="">
<cfparam name="session.TransferNo" default="">
<cfparam name="session.SourceBr" default="">
<cfparam name="session.DestineBr" default="">
<cfparam name="session.mydate" default="">
<cfparam name="session.RepCode" default="">
<cfparam name="session.StaffID" default="">
<cfparam name="session.Account" default="">
<cfparam name="session.Amount" default="">
<cfparam name="session.UnitePrice" default="">


<!--- Remove items from invoice list --->
<cfif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.myInvoice#,#url.id#)#>


<cfelseif isdefined("AddTransfer") >
<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].Name = #form.itemName#>
<cfset session.myInvoice[position].itemDescription = #form.Description#>
<cfset session.myInvoice[position].itemQuantity = #form.Quantity#>
<cfset session.myInvoice[position].itemPrice = #form.Price#>
<cfset session.myInvoice[position].itemAmount = #form.Amount#>
<cfset session.TransferNo = #form.TransferNo#>
<cfset session.SourceBr = #form.SourceBr#>
<cfset session.DestineBr = #form.DestineBr#>
<cfset session.mydate = #form.mydate#>
<cfset session.RepCode = #form.RepName#>
<cfset session.Account = #form.Account#>
<cfset session.UnitePrice = #form.Price#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset structdelete(session, 'TransferNo')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'SourceBr')>
<cfset structdelete(session, 'DestineBr')>
<cfset structdelete(session, 'RepCode')>
<cfset structdelete(session, 'Account')>
<cfset structdelete(session, 'Amount')>
<cfset structdelete(session, 'UnitPrice')>
<cfset structdelete(session, 'trAmount')>
</cfif>

<script language=JavaScript> 
function checkKeyCode(evt)
{

var evt = (evt) ? evt : ((event) ? event : null);
var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
if(event.keyCode==116)
{
evt.keyCode=0;
return false
}
}
document.onkeydown=checkKeyCode;
function setItemDescription() {
	if (window.form) {
		var itemDescription = window.form.itemName.options[window.form.itemName.selectedIndex].title;
		window.form.Description.value=itemDescription;
	} 
}
function checkValue() {
	if (document.form) {
		var itemQuantity = document.form.Quantity.value;
		var itemPrice = document.form.Price.value;
		if (itemQuantity>'' && itemPrice>'') { extAmount1 = itemQuantity*itemPrice; } else { extAmount1=''; }
		var extAmount = parseFloat(extAmount1);
		document.form.Amount.value = extAmount.toFixed(2);
	} 
}
</script>

<cfoutput>

<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form">

<div align="center">
  <table width="90%" border="0">
    <tr>
      <td><div align="left">Transfer No.
        :</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddTransfer')>
          <cfset invNo = "#form.TransferNo#">
          <cfinput type="text" name="TransferNo" required="yes" value="#invNo#" readonly="yes" style="width:100%">
          <cfelse>
          <cfinput name="TransferNo" validate="integer" type="text" id="TransferNo" required="yes" message="Enter an Transfer number" bind="cfc:#request.cfc#cfc.bind.transNumber()" bindonload="yes" autocomplete="off" style="text-align:right; width:100%"/>
          </cfif>
        </div></td>
      <td></td>
      <td></td>
      <td width="98"><div align="left">Date:</div></td>
      <td width="289"><div align="left">
        <cfif isdefined('form.AddTransfer')>
          <cfset invDate = "#form.mydate#">
          <cfinput type="text" name="mydate" required="yes" value="#invDate#" readonly="yes" style="width:100%">
          <cfelse>
          <cfinput type="datefield"  mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Date of Transfer" required="yes" message="Enter valid Date" style="width:100%"/>
          
          
          </cfif>
        </div></td>
    </tr>
    <tr>
      <td width="133"><div align="left">Account:</div></td>
      <td width="267"><div align="left">
        <cfif isdefined('form.AddTransfer')>
       <cfset Selectd = "#form.Account#">
       <cfinput type="text" name="Account" id="Account" required="yes" style="width:100%" value="#Selectd#" readonly="yes">
        <cfelse>
         <cfselect name="Account" id="Account" required="yes" style="width:100%" message="Select an Account" bind="cfc:#request.cfc#cfc.bind.getBankAccounts({SourceBr})" display="AccountID" value="AccountID" bindonload="yes"> </cfselect>
        </cfif>
      </div></td>
      <td width="253"></td>
      <td width="414"></td>
      <td><div align="left">Source:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddTransfer')>
          <cfset SourceBr = "#form.SourceBr#">
          <cfinput type="text" name="SourceBr" id="SourceBr" required="yes"  value="#SourceBr#" readonly="yes" style="width:100%">
          <cfelse>
          <cfif #GetUserRoles()# is  'Stock Keeper'>
       <cfquery name="user">
       select BranchID from users
       where userid = '#GetAuthUser()#'
       </cfquery>
        <cfselect name="SourceBr" id="SourceBr" required="yes" style="width:100%"  message="Choose Location">
        <cfloop query="user">
        <option value="#branchId#">#branchId#</option>
        </cfloop>
        </cfselect>
        <cfelse>
          <cfselect name="SourceBr" id="SourceBr" required="yes" style="width:100%"  message="Choose Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes"> </cfselect>
        </cfif>
        </cfif>
      </div></td>
      </tr>
    <tr>
      <td><div align="left">Authorised:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddTransfer')>
          <cfset RepNo = "#form.RepName#">
          <cfinput type="text" name="RepName" id="RepName" required="yes" value="#RepNo#" readonly="yes" style="width:100%">
          <cfelse>
          <cfselect name="RepName" style="width:100%" id="RepName" tooltip="Staff that signed the Transfer" required="yes" message="Select Authorised" bind="cfc:#request.cfc#cfc.bind.getStockKeeper({SourceBr})" display="FirstName" value="FirstName" bindonload="yes">
            </cfselect>
          </cfif>
        </div></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><div align="left">Destination:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddTransfer')>
          <cfset DestineBr = "#form.DestineBr#">
          <cfinput type="text" name="DestineBr" id="DestineBr" required="yes" value="#DestineBr#" readonly="yes" style="width:100%">
          <cfelse>
          <cfselect name="DestineBr" id="DestineBr" required="yes"  style="width:100%" message="Choose Location" bind="cfc:#request.cfc#cfc.bind.getDestination({SourceBr})" display="BranchID" value="BranchID" bindonload="yes"> </cfselect>
          </cfif>
        </div></td>
    </tr>
    </table>
  <tr><td height="30">&nbsp;</td> </tr>
  </div>
  
  <table width="90%" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td align="center" width="25%"><strong>Item Name</strong></td>
<td width="30%"><strong>Description</strong></td>
<td width="10%" align="center"><strong>Qty</strong></td>
<td width="10%" align="center"><strong>Unit Cost</strong></td>
<td width="10%" align="center"><strong>Amount</strong></td>
<td align="center">&nbsp;</td>
</tr>
</thead>
<tbody>
<tr>

<td> <cfselect name="itemName" id="itemName" style="width:100%" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.getProducts({SourceBr})" display="ProductID" value="ProductID" tabindex="8" bindonload="yes">
</cfselect>
      </td>
            <td><cfinput name="Description" id="Description" type="text"  bind="cfc:#request.cfc#cfc.bind.getDescription({itemName})" style='width:100%' readonly="true"  bindonload="yes"></td>

<td> <cfinput type="text" name="Quantity" validate="float" tabindex="9" required="yes" message="Enter quantity sold" bind="cfc:#request.cfc#cfc.bind.getQtyTransfer({itemName},{SourceBr})" onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no"> </td>
<td> <cfinput type="text" name="Price" validate="float" tabindex="10" required="yes" message="Enter item price" bind="cfc:#request.cfc#cfc.bind.CostPrice({itemName})" onKeyUp="checkValue();" style="text-align:right" autosuggest="no"> </td>
<td align="center"> <cfinput type="text" name="Amount" validate="float"  readonly="true" style="text-align:right"></td>
<td align="center" valign="bottom"> <div align="right"> <cfinput type="submit" name="AddTransfer" id="AddTransfer" tabindex="11" value="Add"></div></td>

</tr>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td > #session.myInvoice[variables.counter].Name# </td>
<td > #session.myInvoice[variables.counter].itemDescription# </td>
<td > <div align="right">#session.myInvoice[variables.counter].itemQuantity# </div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#</div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')#&nbsp; </div></td>
<td> <div align="right" title="Remove this Item"><a href="#cgi.SCRIPT_NAME#?id=#counter#"><font color="##FF0000"><strong>X</strong></font></a>&nbsp; </div></td>
</tr>
</cfloop>

<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddTransfer") >
<cfset arrayappend(session.trAmount,#form.Amount#)>
<cfset position = arraylen(session.trAmount)>
<cfset session.trAmount[position] = #form.Amount#>
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.trAmount#,#url.id#)#>
</cfif>
<cfparam name="session.trAmount" default="#arraynew(1)#" type="array">
<cfset Amount = #arraySum(session.trAmount)#>
<cfset session.Amount = #Amount#> 
<tr>
  <td colspan="4" align="right"><div align="right"><strong>Total Value:&nbsp;</strong></div></td>
  <td align="right"><div align="left"><strong>
    <cfinput type="text" name="totalAmount1" id="totalAmount1" validate="float" value="#LSNumberFormat(Amount,',99999999999.99')#" readonly="true" style="text-align:right; width:100%">
    <cfinput type="hidden" name="totalAmount" id="totalAmount"  validate="float" value="#Amount#" size="13" readonly="true" style="text-align:right">
  </strong></div></td>
</tr>
<tr bgcolor="##4AA5FF">
<td colspan="4" align="right">&nbsp;</td>
<td align="right">&nbsp;</td>

<td align="center"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##FF0000"><strong>Reset</strong></font></a><font color="##FFFFFF"><strong>|</strong></font><a href="#cgi.SCRIPT_NAME#?Transfer=yes"><font color="##FFFFFF"><strong>Post</strong></font></a></td>
</tr>
</tbody>

</table>
<cfif url.reset is "1">
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.trAmount#)>
<cfset structdelete(session, 'Amount')>
<cfset structdelete(session, 'TransferNo')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'SourceBr')>
<cfset structdelete(session, 'DestineBr')>
<cfset structdelete(session, 'RepCode')>
<cfset structdelete(session, 'Account')>


</cfif>

</cfform></cfoutput>
</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html>