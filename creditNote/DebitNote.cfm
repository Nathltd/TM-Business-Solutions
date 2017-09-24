<!doctype html>
<html>
<head>
<title><cfoutput>Debit Note (Purchase) :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDup.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#stockCheck').hide();
	$(function(){
 		$("#form").keydown(function (e) {
  			if (e.which == 13) {
    		$('input[name="AddInvoice"]').trigger('click');
		  }
		 });
		});
	$('#AddInvoice').click(function(event) {
		var qty = parseInt($("#Quantity").val());
		var salePrice = parseInt($("#Price").val());
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getQuantity",
			returnFormat: "json",
			itemname:$('#itemName').val(), 
			branchid:$('#BranchID').val()
					},
			async: false,
		    cache: false,
		    dataType: "json",
			dataFilter: function(data) {
			currentQty = parseInt(data);			
			}
		});
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "CostPrice",
			returnFormat: "json",
			itemName:$('#itemName').val()
					},
			async: false,
		    cache: false,
		    dataType: "json",
			dataFilter: function(data) {
			currentPrice = parseInt(data);			
			}
		});
		if(qty>currentQty){
			$('#stockCheck').show();
			$('#msg').text(qty+ ' Quantity not available in stock!');
			event.preventDefault();
		}
		if(currentPrice>salePrice){
			$('#stockCheck').show();
			$('#msg').text('Sales Price less than Cost Price')
			event.preventDefault();
		}
		$('#ok').click(function(event){
			$('#stockCheck').hide();
			event.preventDefault();
		});
	});
	
});
</script>

</head>


<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Debit Note</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock keeper'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfparam name="url.Sales" default="">
<cfif url.Sales is "yes">

<cftransaction>
<cfquery>

INSERT INTO debitNote
(debitNoteID,debitNoteDate,BranchId,vendorId,StaffID,LastUpdated,Creator,ApplyAs)
VALUES ('#session.SalesID#', '#lsDateFormat(CreateODBCDate(session.myDate), "dd/mm/yyyy")#', '#session.BranchID#',  '#session.vendorID#', '#session.StaffID#', '#lsDateFormat(CreateODBCDate(session.todate), "dd/mm/yyyy")#', '#GetAuthUser()#', '#session.AccountID#')
</cfquery>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">

<cfquery>

INSERT INTO debitNoteDetails
(ProductId, UnitPrice, Qty, debitNoteID)
VALUES ('#session.myInvoice[variables.counter].Name#',
'#session.myInvoice[variables.counter].itemPrice#',  '#session.myInvoice[variables.counter].itemQuantity#', 
'#session.SalesID#')
</cfquery>
</cfloop>
</cftransaction>
<br />
<br />

<cfoutput> Debit No. <strong>#session.SalesID#</strong> have been posted successfully<a href="../CreditNote/debitNote.cfm"> New Debit Note</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="../reports/debitNotePrnt.cfm?CFGRIDKEY=#session.SalesID#">Print</a></cfoutput><br>
<br>
<table class="font2">
<cfoutput> 
<tr>
<td><div align="right">Vendor:</div></td>
<td><strong> #session.VendorID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Debit No:</div></td>
<td><strong> #session.SalesID#</strong></td>

<td><div align="right"> Date:</div></td><td><strong> #session.myDate#</strong></td>
</tr>
<tr>
<td><div align="right">Location:</div></td><td><strong> #session.BranchID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Signed By:</div></td><td><strong> #session.StaffID#</strong></td>

<td><div align="right">Apply As:</div></td><td><strong> #session.AccountID#</strong></td>
</tr>
<tr align="center">
<td> </td>
</tr>
<tr align="center">
<td height="29"> </td>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
</tr>
<tr align="center">
<td > <strong>Item Name</strong></td>
<td colspan="5"> <strong>Description</strong></td>
<td> <strong>Quantity Sold</strong></td>
<td> <strong>Unit Price</strong></td>
<td> <strong>Amount</strong></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="center"> #session.myInvoice[variables.counter].Name# </td>
<td align="center" colspan="5"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="center"> #session.myInvoice[variables.counter].itemQuantity# </td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#</td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')# </td>

</tr>
</cfloop>
</cfoutput>
</table>

<div align="center">

</div>
<cfset structdelete(session, 'VendorCode')>
<cfset structdelete(session, 'InvoiceNo')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchCode')>
<cfset structdelete(session, 'RepCode')>
<cfset structdelete(session, 'select')>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>
<cfset structdelete(session, 'myInvoice')>
<cfset structdelete(session, 'totalAmount')>

<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmount" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="form.AmountPaid" default="">
<cfparam name="session.AmountPaid" default="form.AmountPaid">
<cfparam name="session.VendorID" default="">
<cfparam name="session.SalesID" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchID" default="">
<cfparam name="session.StaffID" default="">
<cfparam name="session.AccountID" default="">
<cfparam name="url.reset" default="">

<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>

<cfquery name="Branches">
SELECT BranchID, Description
FROM Branches
ORDER BY BranchID ASC 
</cfquery>
<cfquery name="Staff">
SELECT StaffID, LastName, FirstName
FROM Staff
ORDER BY StaffID ASC 
</cfquery>

  <cfquery name="Vendors">
SELECT vendorId
FROM vendors
WHERE vendorType = 'Supplier'
ORDER BY vendorId ASC 
  </cfquery>

<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].Name = #form.itemName#>
<cfset session.myInvoice[position].itemDescription = #form.Description#>
<cfset session.myInvoice[position].itemQuantity = #form.Quantity#>
<cfset session.myInvoice[position].itemPrice = #form.Price#>
<cfset session.myInvoice[position].itemAmount = #form.Amount#>
<cfset session.VendorID = #form.VendorID#>
<cfset session.SalesID = #form.SalesID#>
<cfset session.BranchID = #form.BranchID#>
<cfset session.mydate = #form.mydate#>
<cfset session.StaffID = #form.StaffID#>
<cfset session.AccountID = #form.AccountID#>
<cfset session.totalAmountSum = #form.totalAmount#>
<cfset session.AmountPaid = #form.AmountPaid#>
<cfset todayDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset session.todate = #todayDate#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>
<cfset structdelete(session, 'VendorID')>
<cfset structdelete(session, 'SalesID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'totalAmountSum')>
<cfset structdelete(session, 'AmountPaid')>
<cfset structdelete(session, 'Balance')>
</cfif>

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

function setItemDescription() {
	if (document.form) {
		var itemDescription = document.form.itemName.options[document.form.itemName.selectedIndex].title;
		var itemSale = document.form.itemName.options[document.form.itemName.selectedIndex].SalePrice;
		var itemSalePrice = parseFloat(itemSale);
		document.form.Description.value=itemDescription;
		document.form.Price.value=itemSalePrice.toFixed(2);
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
function checkBalance(){
	if (document.form){
		var totalAmount = document.form.totalAmount.value;
		var amountPaid = document.form.AmountPaid.value;
		if (totalAmount>'' && amountPaid>'') { extBalance = totalAmount-amountPaid;} else { extBalance='';}
		document.form.Balance.value = extBalance.toFixed(2);
	}
}
//
//var width = 1028;
//var height = 800;
//window.moveTo((screen.availWidth/2)-(width/2),(screen.availHeight/2)-(height/2)) 
//window.resizeTo(width,height);
//
//window.onresize = function() {window.resizeTo(width,height); }
</script>


<div align="center">
<br />

<div align="center">
<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="90%" cellpadding="2">
    <tr>
      <td><div align="left">Vendor:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset VendorID = "#form.VendorID#">
          <cfinput type="text" name="VendorID" id="VendorID" required="yes" style="width:100%" value="#VendorID#" tooltip="Invoice Number" readonly="yes">
          <cfelse>
          <cfselect name="VendorID" style="width:100%" id="VendorID" tooltip="Vendor's Name" message="Select a Vendor" tabindex="1">
                        <cfloop query="Vendors">
              <option value="#Trim(VendorID)#">#VendorID#</option>
              </cfloop>
            </cfselect>
          </cfif>
      </div></td>
      <td>&nbsp;</td>
      <td><div align="left">Date:</div></td>
      <td><div align="left">
      <cfif isdefined('form.AddInvoice')>
       <cfset invDate = "#form.mydate#">
       <cfinput type="text" name="mydate" style="width:100%" required="yes" value="#invDate#" readonly="yes">
       <cfelse>
       <cfinput type="datefield" style="width:100%" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Credit Note Date" required="yes" message="Enter valid date"/>
       
       
        </cfif>
      </div>
             </td>
    </tr>
    <tr>
      <td><div align="left">Debit No:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset SalesID = "#form.SalesID#">
          <cfinput type="text" name="SalesID" required="yes" style="width:100%" value="#SalesID#" tooltip="Invoice Number" readonly="yes">
          <cfelse>
          <cfinput name="SalesID" type="text" id="SalesID" required="yes" message="Enter an Invoice number" tooltip="Invoice Number" autocomplete="off" bind="cfc:#request.cfc#cfc.bind.debitNote()" bindonload="yes" style="text-align:right; width:100%">
                    <span id="msg2">&nbsp;Invoice Number already exist</span>
          </cfif>
      </div></td>
      <td>&nbsp;</td>
      <td width="94"><div align="left">Location:</div></td>
      <td width="290"><div align="left">

        <cfif isdefined('form.AddInvoice')>
               <cfset BranchID = "#form.BranchID#">
               <cfinput type="text" name="BranchID" id="BranchID" size="10" required="yes" style="width:100%" value="#BranchID#" readonly="yes">
       		   <cfelse>
            <cfselect name="BranchID" id="BranchID" required="yes" style="width:100%" message="Choose Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" tabindex="3"> </cfselect>
            
        </cfif>
        
        </div></td>
      </tr>
      
    <tr>
      <td width="107"></td>
      <td width="310"></td>
      <td width="821">&nbsp;</td>
      <td><div align="left">Authorised:</div></td>
      <td><div align="left">

       <cfif isdefined('AddInvoice')>

               <cfset StaffID = "#form.StaffID#">
               <cfinput type="text" name="StaffID" id="StaffID"  required="yes"  value="#StaffID#" readonly="yes" style="width:100%">
       <cfelse>
        <cfif #GetUserRoles()# contains 'Sales'>
       <cfquery name="user">
       select Firstname from users
       where userid = '#GetAuthUser()#'
       </cfquery>
        <cfinput type="text" name="StaffID" id="StaffID" required="yes"  value="#user.Firstname#" readonly="yes" style="width:100%">
        <cfelse>
        <cfselect name="StaffID" id="StaffID" tooltip="Staff that signed the invoice" required="yes" message="Select Authorised" bind="cfc:#request.cfc#cfc.bind.getStaff({BranchID})" display="FirstName" value="FirstName" bindonload="yes" tabindex="6" style="text-align:left; width:100%">
        </cfselect>
        </cfif>
       </cfif>
      </div></td>
      </tr>
    <tr>
      <td width="107">&nbsp;
        <div align="left"></div></td>
      <td width="310"><div align="left">&nbsp;
      </div></td>
      <td width="821">&nbsp;</td>
      <td><div align="left">Apply As:</div></td>
      <td><div align="left">
      <cfif isdefined('form.AddInvoice')>
       <cfset AccountID = "#form.AccountID#">
       <cfinput type="text" name="AccountID" id="AccountID" required="yes" style="width:100%" value="#AccountID#" readonly="yes">
        <cfelse>
         <cfselect name="AccountID" id="AccountID" required="yes" style="width:100%" message="Select an Account" >
         <option value="Returned">Returned</option>
         </cfselect>
        </cfif>
      </div></td>
    </tr>
    
  </table></div>
  <div align="center">
  <table width="90%" bgcolor="##D5EAFF" border="0" cellpadding="2" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td align="center"> <strong>Item Name</strong></td>
<td> <strong>Description</strong></td>
<td align="center"> <strong>Qty</strong></td>
<td align="center"> <strong>Unit Price</strong></td>
<td align="center"> <strong>Amount</strong></td>
<td align="center">&nbsp;</td>
</tr>
</thead>
<tbody>
<div id="stockCheck" align="center">
<h5 id="msg"> </h5>
<button name="ok" id="ok">Ok</button>
</div>
<tr>

<td> <cfselect name="itemName" id="itemName"required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.AllProducts()" display="ProductID" value="ProductID" tabindex="5" bindonload="yes"  style="width:100%">
</cfselect>
      </td>
            <td><cfinput name="Description" id="Description" type="text"  bind="cfc:#request.cfc#cfc.bind.getDescription({itemName})" style="width:100%"readonly="true" bindonload="yes" tabindex="6"></td>

<td> <cfinput type="text" name="Quantity" id="Quantity" validate="float" tabindex="9" required="yes" message="Enter quantity sold" bind="cfc:#request.cfc#cfc.bind.getQuantity({itemName},{BranchID})" onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no"> </td>
<td> <cfinput type="text" name="Price" validate="float" tabindex="8" required="yes" message="Enter item price" bind="cfc:#request.cfc#cfc.bind.getPrice({itemName})" onKeyUp="checkValue();" style="text-align:right; width:100%"> </td>
<td align="center"> <cfinput type="text" name="Amount" validate="float" style="width:100%; text-align:right;"  readonly="true" ></td>
<td align="center" valign="bottom">  <cfinput type="submit" name="AddInvoice" value="Add" tabindex="9"></td>

</tr>



<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#session.myInvoice[variables.counter].Name#</td>
<td align="left"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="right"> <div align="right">#session.myInvoice[variables.counter].itemQuantity# </div></td>
<td align="right"> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#</div></td>
<td align="right"> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')# </div></td>

</tr>
</cfloop> 
<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.totalAmount,#form.Amount#)>
<cfset position = arraylen(session.totalAmount)>
<cfset session.totalAmount[position] = #form.Amount#>
</cfif>
<cfset Amount = #arraySum(session.totalAmount)#>
<cfset session.Amount = #Amount#>

<tr>
<td colspan="4">&nbsp;</td>
<td align="right">&nbsp;</td>
</tr>
<tr>
<td colspan="4" align="right"><div align="right"><strong>Total:&nbsp;</strong></div></td>
<td align="right"><div align="right">
  <cfinput type="text" name="totalAmount" id="totalAmount" validate="float" value="#Amount#" readonly="true" style="text-align:right; width:100%">
  </div></td>
</tr>
<tr bgcolor="##C6C6FF">
<td colspan="4" align="right"><strong>&nbsp;</strong></td>
<td align="right">&nbsp;</td>

<td align="center"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##000000"><strong>Reset</strong></font></a>&nbsp;<a href="#cgi.SCRIPT_NAME#?sales=yes"><font color="##000000"><strong>Post</strong></font></a></td>
</tr>
</tbody>

</table>
</div>


<cfif url.reset is "1">
<cfset structdelete(session, 'VendorCode')>
<cfset structdelete(session, 'InvoiceNo')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchCode')>
<cfset structdelete(session, 'RepCode')>
<cfset structdelete(session, 'select')>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.totalAmount#)>
<cfset structdelete(session, 'myInvoice')>
<cfset structdelete(session, 'totalAmount')>
</cfif>

</cfform></cfoutput>
</div></div>
</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html>