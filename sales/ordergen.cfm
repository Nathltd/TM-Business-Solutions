<!doctype html>
<html>
<head>
<title><cfoutput>Sales Invoice :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
<script src="googleJquery-min.js"></script>
<link rel="stylesheet" type="text/css" href="googleJquery-ui.css">
<script src="googleJquery-ui.min.js"></script>
<script src="../style.js"></script>
<script src="checkDup.js" type="application/javascript"></script>

<!---Auto Creat New General Customer--->
<script type="text/javascript">
	$(document).ready(function(){
		$('#AddInvoice').click(function(event) {
			var CustomerID = $('#CustomerID').val();
			var phone = $('#phone').val();
			var address = $('#address').val();
		if(CustomerID == '' || phone == '' || address == ''){
			$('#CustomerID').val('General');
			$('#phone').val('080');
			$('#address').val('Address');
			}

});
$(function(e){
  			if (e.which == 13) {
				$('#CustomerID').val('General');
				$('#phone').val('080');
				$('#address').val('Address');
    			return false;
		  }
		 });
});
</script>

<!---Bank Account Selection--->

<script type="text/javascript">
	$(document).ready(function($) {
		$('#BranchID').change(function(e) {
			$('#AccountType').val('Cash');
		});
		
  $('#AccountType').change(function(e) {
    var selectvalue = $(this).val();
	  
    if (selectvalue == 'Cash') {
		$('#AccountID').find('option').remove().end();
		  var branchId = $("#BranchID").val();
		  $("#AccountID").html("<option value="+branchId+">" + branchId + "</option>");
		
    }
	  else{
		  var branchId = $("#BranchID").val();
		  $('#AccountID').find('option').remove().end();
		$.ajax({
	   url:"../cfc/bind.cfc?method=ChequeAccounts&Branch="+branchId+"&returnFormat=json",
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
		   $("#AccountID").html(options);
		   console.log(options);
			},

    });
		  
	  }
 });
});
</script>
<script type="text/javascript">

$(document).ready(function(){
	$('#stockCheck').hide();
	$(function(){
 		$("#itemCode").keydown(function (e) {
  			if (e.which == 13) {
    			return false;
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
			$('#msg').text(qty+ ' Quantity not available in stock!')
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
	 		$("#Quantity").keydown(function (e) {
				if (e.which == 13) {
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
					
						if(qty>currentQty){
					$('#stockCheck').show();
					$('#msg').text(qty+ ' Quantity not available in stock!');
					return false;
					e.preventDefault();
					
						}
				}
				 });

	
});

function checkValue() {
	if (document.form) {
		var itemQuantity = document.form.Quantity.value;
		var itemPrice = document.form.Price.value;
		var itemAmount = (document.form.Quantity.value)*(document.form.Price.value);
		/*For Percentage discount*/
		/*var itemDiscount = (document.form.Discount.value -0)/100;*/
		var itemDiscount = (document.form.Discount.value);
		var totalAmt = itemAmount - itemDiscount;

		var totalAmt = parseFloat(totalAmt);
		document.form.Amount.value = totalAmt.toFixed(2);
	} 
}

function setPrice() {
	if (document.form) {
		var itemQuantity = document.form.Quantity.value;
		var itemAmount = document.form.Amount.value;
		var itemPrice = itemAmount/itemQuantity;
		var itemPrice = parseFloat(itemPrice);
		document.form.Price.value = itemPrice.toFixed(4);
		document.form.Discount.value = 0;		
	} 
}

function checkBalance(){
	if (document.form){
		var totalAmount = document.form2.totalAmount.value;
		var amountPaid = document.form2.amountPaid.value;
		if (totalAmount>'' && amountPaid>'') { extBalance = totalAmount-amountPaid;} else { extBalance='';}
		document.form2.balance.value = extBalance.toFixed(2);
	}
}

$(document).ready(function(){
//setup before functions
var typingTimer;                //timer identifier
var doneTypingInterval = 30;  //time in ms, 5 second for example
var $input = $('#itemCode');

//on keyup, start the countdown
$input.on('keyup', function () {
  clearTimeout(typingTimer);
  typingTimer = setTimeout(doneTyping, doneTypingInterval);
});

//on keydown, clear the countdown 
$input.on('keydown', function () {
  clearTimeout(typingTimer);
});

//user is "finished typing," do something
function doneTyping () {
  //do something

  $.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getBarcode",
			returnFormat: "json",
			itemCode:$('#itemCode').val(),
			branchid:$('#BranchID').val()
					},
			async: false,
		    cache: false,
		    dataType: "json",
			dataFilter: function(data) {
				myData = JSON.parse(data);
			}
		});
		$('#itemName').val(myData[2]);
		$('#Description').val(myData[3]);
		$('#Price').val(myData[4]);
		$('#Quantity').val(myData[5]);
		$('#Quantity').select();
}
});

$(function() {
         
            $('#Description').val("");
             
            $("#itemName").autocomplete({
                source: "JQueryCFitems.cfm",
                minLength: 1,
                select: function(event, ui) {

					$('#Description').val(ui.item.description);
					$('#Price').val(ui.item.salePrice);
					$('#Quantity').val(ui.item.balance);
					$('#Quantity').select();
                }
            });
        });
        </script>
</head>


<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Invoice Posting </h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is not 'Administrator' AND #GetUserRoles()# is not 'Alpha' AND #GetUserRoles()# does not contain 'Sales'>
<h1> Unauthrised Zone </h1>
<cfelse>
<cfset access = hash(#session.URLToken#,'SHA-512')>
<cfparam name="url.post" default="">
<cfparam name="form.Amount" default="">

<cfif url.post is #access#>

<cfset form.newDate = #dateformat(session.myDate,"dd/mm/yyyy")#>
<cfif #DateDiff("d", "#dateformat(request.clsDate,"mm/dd/yyyy")#","#dateformat(form.newDate,"mm/dd/yyyy")#" )# lte 0>


<h3>Posting for <cfoutput>#dateformat(form.newDate,"dd-mmm-yyyy")#</cfoutput> not Allowed. Please contact the administrator.</h3>
<cfabort>
</cfif>


<cftransaction>

<cfquery name="data" maxrows="1">
select salesid from sales
where salesid not like '%m%'
order by salesid desc
</cfquery>

<cfset InvNumber =Val(data.salesid)>

<cfif #session.SalesID# lte #invNumber#>
<cfset #session.SalesID# = #invNumber#+1>
<cfset #session.SalesID# = #ToString(session.SalesID)#>
</cfif>

<!---<cftry>--->
<cfquery name="gCustomer">
Select customerId from customers
where customerId = 'General'
</cfquery>

<cfif gCustomer.recordCount eq 0>

<cfquery>
INSERT INTO Customers (Address, Company, customerEmail,CustomerID,customerPhone,OpeningBalance,Creator, dateUpdated, CurrentDate, creditLimit)
VALUES (<cfqueryparam value="Address" cfsqltype="cf_sql_char">, <cfqueryparam value="Company" cfsqltype="cf_sql_char">, <cfqueryparam value="customerEmail" cfsqltype="cf_sql_char">,<cfqueryparam value="General" cfsqltype="cf_sql_char">,<cfqueryparam value="080" cfsqltype="cf_sql_char">, <cfqueryparam value="0" cfsqltype="cf_sql_double">,<cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_char">,<cfqueryparam value="#lsDateFormat(CreateODBCDate(now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,<cfqueryparam value="0" cfsqltype="cf_sql_double">) 
</cfquery>
</cfif>

<cfquery>
INSERT INTO Sales
(SalesID,SalesDate,BranchId,CustomerId,StaffID,AmountPaid,LastUpdated,Creator,AccountId,paymode)
VALUES (<cfqueryparam cfsqltype="cf_sql_clob" maxlength="8" value="#session.SalesID#">,<cfqueryparam value="#dateformat(session.myDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_timestamp">, '#session.BranchID#',  'General', '#session.StaffID#', <cfqueryparam value="#amountPaid#" cfsqltype="cf_sql_double">, <cfqueryparam value="#dateformat(session.todate,"dd/mm/yyyy")#" cfsqltype="cf_sql_timestamp">, '#GetAuthUser()#', '#session.AccountID#','#session.AccountType#')
</cfquery>

<cfquery>
INSERT INTO CustomersGen
(salesId,customerId,address,phone)
VALUES (<cfqueryparam cfsqltype="cf_sql_clob" maxlength="8" value="#session.SalesID#">,<cfqueryparam value="#session.customerId#" cfsqltype="cf_sql_clob">, <cfqueryparam value="#session.address#" cfsqltype="cf_sql_clob">, <cfqueryparam value="#session.phone#" cfsqltype="cf_sql_clob">)
</cfquery>


<!--- <cfcatch type="database">
<h3>An Error Has Occured</h3><br>
<cfoutput>
<cfif #cfcatch.NativeErrorCode# is "0">
Invoice No. #session.SalesID# Already Exits<br>
<p>
<a href="#cgi.SCRIPT_NAME#?">Try Again</a>
</p>
</cfif>
<!--- and the diagnostic message from the ColdFusion server --->
<cfif #GetUserRoles()# is "Administrator">
<p>Type = #CFCATCH.TYPE# </p>
<p>Message = #cfcatch.detail#</p>
<p>Code = #cfcatch.NativeErrorCode#</p>
<cfloop index = i from = 1 to = #ArrayLen(CFCATCH.TAGCONTEXT)#>
<cfset sCurrent = #CFCATCH.TAGCONTEXT[i]#>
Occured on Line #sCurrent["LINE"]#, Column #sCurrent["COLUMN"]#
</cfloop>
</cfif>
</cfoutput>
<cfabort>
</cfcatch>
</cftry>--->

<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery>
INSERT INTO SalesDetails
(ProductId, UnitPrice, Qty, SalesID, discount,branchId)
VALUES ('#session.myInvoice[variables.counter].Name#',
<cfqueryparam value="#session.myInvoice[variables.counter].itemPrice#" cfsqltype="cf_sql_double">,  <cfqueryparam value="#session.myInvoice[variables.counter].itemQuantity#" cfsqltype="cf_sql_double">,
<cfqueryparam value="#session.SalesID#" cfsqltype="cf_sql_clob">, <cfqueryparam value="#session.myInvoice[variables.counter].discount#" cfsqltype="cf_sql_double">,'#session.001BranchID#')
</cfquery>
</cfloop>
</cftransaction>
<cfoutput>
<cfset url.cfgridkey = #session.SalesID#>
<div align="right"> <a href="#cgi.SCRIPT_NAME#"> New Invoice </a>  |  <a href="../invoices/#request.invoiceFormat#.cfm?cfgridkey=#url.cfgridkey#&InvoiceType=Original">Print</a>&nbsp;</div>
 Invoice No. <strong>#session.SalesID#</strong> have been posted successfully
 </cfoutput><br>
<br>
<table>
<cfoutput> 
<tr>
<td><div align="right">Customer:</div></td>
<td><strong> #session.CustomerID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Invoice No:</div></td>
<td><strong> #session.SalesID#</strong></td>

<td><div align="right">Invoice Date:</div></td><td><strong> #session.myDate#</strong></td>
</tr>
<tr>
<td><div align="right">Location:</div></td><td><strong> #session.BranchID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Signed By:</div></td><td><strong> #session.StaffID#</strong></td>

<td><div align="right">Account:</div></td><td><strong> #session.AccountID#</strong></td>
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
<td> <strong>Discount</strong></td>
<td> <strong>Amount</strong></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="center"> #session.myInvoice[variables.counter].Name# </td>
<td align="center" colspan="5"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="center"> #session.myInvoice[variables.counter].itemQuantity# </td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#</td>
<td align="center"> #session.myInvoice[variables.counter].discount#</td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')# </td>

</tr>
</cfloop>
</cfoutput>
</table>

<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.sAmount" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="session.CustomerID" default="">
<cfparam name="session.SalesID" default="">
<cfparam name="session.mydate" default="">
<cfparam name="session.BranchID" default="">
<cfparam name="session.StaffID" default="">
<cfparam name="session.AccountID" default="">
<cfparam name="form2.totalAmount" default="0">
<cfparam name="form2.amountPaid" default="0">
<cfparam name="url.reset" default="">
<cfparam name="session.phone" default="">
<cfparam name="session.address" default="">
<cfparam name="session.AccountType" default="">




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

  <cfquery name="Customers">
SELECT CustomerID
FROM Customers
ORDER BY CustomerID ASC 
  </cfquery>
  

<cfif isdefined("AddInvoice") >
<cfif form.Discount eq ''>
<cfset form.Discount = 0>
</cfif>

<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].Name = #form.itemName#>
<cfset session.myInvoice[position].itemDescription = #form.Description#>
<cfset session.myInvoice[position].itemQuantity = #form.Quantity#>
<cfset session.myInvoice[position].itemPrice = #form.Price#>
<cfset session.myInvoice[position].itemAmount = #form.Amount#>
<cfset session.myInvoice[position].Discount = #form.Discount#>
<cfset session.CustomerID = #form.CustomerID#>
<cfset session.SalesID = #form.SalesID#>
<cfset session.BranchID = #form.BranchID#>
<cfset session.mydate = #form.myDate#>
<cfset session.StaffID = #form.StaffID#>
<cfset session.AccountID = #form.AccountID#>
<cfset session.totalAmountSum = #form2.totalAmount#>
<cfset todayDate = #now()#>
<cfset session.todate = #todayDate#>
<cfset session.amountPaid = #form2.AmountPaid#>
<cfset session.phone = #form.phone#>
<cfset session.address = #form.address#>
<cfset session.AccountType = #form.AccountType#>


<!--- Remove items from invoice list --->
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.myInvoice#,#url.id#)#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.sAmount#)>

<cfset structdelete(session, 'CustomerID')>
<cfset structdelete(session, 'SalesID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'totalAmountSum')>
<cfset structdelete(session, 'Balance')>
<cfset structdelete(session, 'AccountType')>
</cfif>


<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#?AddInvoice=1" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div>

  <table width="90%" cellpadding="2">
    <tr>
      <td><div align="left">Customer:</div></td>
      <td width="20%"><div align="left">
        <cfif isdefined('AddInvoice')>
          <cfset CustomerID = "#form.CustomerID#">
          <cfinput type="text" name="CustomerID" id="CustomerID" required="yes"  value="#CustomerID#" title="Invoice Number" readonly="yes"  style="text-align:left; width:100%">
          <cfelse>
          <cfinput name="CustomerID"  id="CustomerID" placeholder="Customer's Name" title="Customer's Name" message="Enter a Customer's Name"  tabindex="1" style="text-align:left; width:100%">
        </cfif>
      </div></td>
      <td width="40%">&nbsp;</td>
      <td><div align="left">Date:</div></td>
      <td width="20%"><div align="left">
      <cfif isdefined('AddInvoice')>
       <cfset invDate = "#form.mydate#">
       <cfinput type="text" name="mydate" required="yes" value="#invDate#" readonly="yes" title="Invoice Date" style="width:100%">
       <cfelse>
       <cfinput type="datefield"  mask="dd/mm/yyyy" value="#dateformat(now(),"mm/dd/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Invoice Date" required="yes" message="Enter Invoice Date" autocomplete="off" style="width:100%" />
        
        </cfif>
      </div>
             </td>
    </tr>
    <tr>
      <td><div align="left">Phone No.
        :</div></td>
      <td><div align="left">
        <cfif isdefined('AddInvoice')>
          <cfset phone = "#form.phone#">
          <cfinput type="text" name="phone" required="yes"  value="#phone#" tooltip="Invoice Number" readonly="yes" style="text-align:left; width:100%">
          <cfelse>
          <cfinput name="phone" type="text" id="phone" validate="integer" required="yes" message="Enter an Customer's Phone number" tooltip="Customer's Phone Number" tabindex="3" autocomplete="off" placeholder="080xxxxxxxx" style="width:100%">
          
        </cfif>
      </div></td>
      <td>&nbsp;</td>
      <td width="92"><div align="left">Location:</div></td>
      <td width="168"><div align="left">

        <cfif isdefined('AddInvoice')>
               <cfset BranchID = "#form.BranchID#">
               <cfinput type="text" name="BranchID" id="BranchID" required="yes" value="#BranchID#" readonly="yes" style="text-align:left; width:100%">
       		   <cfelse>
               <cfif #GetUserRoles()# contains 'Sales'>
       <cfquery name="user">
       select BranchID from users
       where userid = '#GetAuthUser()#'
       </cfquery>
        <cfinput type="text" name="BranchID" id="BranchID" size="10" required="yes" value="#user.BranchID#" readonly="yes"  style="width:100%">
        <cfelse>
            <cfselect name="BranchID" id="BranchID" required="yes"  title="Select Sales Location" bind="cfc:#request.cfc#cfc.bind.getBranches()" display="BranchID" value="BranchID" bindonload="yes" tabindex="4" style="text-align:left; width:100%"> </cfselect>
         </cfif>            
        </cfif>
        
        </div></td>
      </tr>
      
    <tr>
      <td width="103"><div align="left">Address:</div></td>
      <td width="162"><div align="left">
        <cfif isdefined('AddInvoice')>
          <cfset address = "#form.address#">
          <cfinput type="text" name="address" required="yes"  value="#address#" title="Customer's Address" readonly="yes" style="text-align:left; width:100%">
          <cfelse>
          <cfinput name="address" type="text" id="address" required="yes" message="Enter Customer's Address" title="Customer's Address" tabindex="3" autocomplete="off" style="text-align:right; width:100%">
          
        </cfif>
      </div></td>
      <td width="429">&nbsp;</td>
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
      <td width="103"><div align="left">Invoice No.:</div></td>
      <td width="162"><div align="left">
        <cfif isdefined('AddInvoice')>
          <cfset SalesID = "#form.SalesID#">
          <cfinput type="text" name="SalesID" required="yes"  value="#SalesID#" tooltip="Invoice Number" readonly="yes" style="text-align:left; width:100%">
          <cfelse>
          <cfinput name="SalesID" type="text" id="SalesID" validate="integer" required="yes" message="Enter an Invoice number" tooltip="Invoice Number" tabindex="3" autocomplete="off" bind="cfc:#request.cfc#cfc.bind.invNumber()" bindonload="yes" style="text-align:right; width:100%" readonly="yes">
          
        </cfif>
      </div></td>
      <td width="429">&nbsp;</td>
      <td>Payment Type:</td>
      <td width="162"><div align="left">
        <cfif isdefined('AddInvoice')>
          <cfset AccountType = "#form.AccountType#">
          <cfinput type="text" name="AccountType" id="AccountType" size="10" required="yes" value="#AccountType#" readonly="yes" style="text-align:left; width:100%">
          <cfelse>
          <cfselect name="AccountType" id="AccountType" required="yes"  message="Select an Account" tabindex="5" style="text-align:left; width:100%">
			  <option value="Cash">Cash</option>
         		<option value="Cheque">Cheque</option>
         		<option value="EFT">EFT</option>
          </cfselect>
        </cfif>
      </div></td>
      </tr> 
      <tr>
      <td colspan="2">
		  </td>
      
      <td width="429">&nbsp;</td>
      <td>Account:</td>
      <td width="162"><div align="left">
        <cfif isdefined('AddInvoice')>
          <cfset AccountID = "#form.AccountID#">
          <cfinput type="text" name="AccountID" id="AccountID" size="10" required="yes" value="#AccountID#" readonly="yes" style="text-align:left; width:100%">
          <cfelse>
          <cfselect name="AccountID" id="AccountID" required="yes"  message="Select an Account" bind="cfc:#request.cfc#cfc.bind.getBankAccounts({BranchID})" display="AccountID" value="AccountID" bindonload="yes" tabindex="5" style="text-align:left; width:100%"> </cfselect>
        </cfif>
      </div></td>
      </tr>
    
    
  </table>


  
  <table width="90%" bgcolor="##E6F2FF" border="0" cellpadding="3" cellspacing="0" bordercolor="999999">
    <tr align="center" bgcolor="##E9E9E9">
    <td align="center" width="5%"> <strong>Barcode</strong></td>
        <td align="center" width="25%"> <strong>Item Name</strong></td>
        <td  width="27%"> <strong>Description</strong></td>
        <td align="center"  width="7%"> <strong>Qty</strong></td>
        <td align="center"  width="8%"> <strong>Rate</strong></td>
        <td align="center"  width="7%"> <strong>Discount</strong></td>
        <td align="center" width="13%"> <strong>Amount</strong></td>
        <td align="center" width="5%">&nbsp;</td>
    </tr>
<div id="stockCheck" align="center">
<h5 id="msg"> </h5>
<button name="ok" id="ok">Ok</button>
</div>
    <tr>
    <td><input type="text" name="itemCode" id="itemCode"  style="width:100%" message="Select A Product" tabindex="8" title="Item Code" placeholder="Item Code" autofocus></td>  
    <td><input type="text" name="itemName" id="itemName"  style="width:100%" required="yes"  message="Enter A Product" placeholder="Product Id" tabindex="8" title="Item Name"></td>
    <td><input name="Description" id="Description" type="text" readonly style='width:100%' title="Description" placeholder="Description" required></td>
    <td> <input type="text" name="Quantity" id="Quantity" validate="float" tabindex="9" required="yes" message="Enter quantity sold" onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no"> </td>
    <td> <input type="text" name="Price" id="Price" validate="float" tabindex="10" required="yes" message="Enter item price"  onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no" placeholder="Price"> </td>
    <td> <input type="text" name="Discount" id="Discount" validate="float" tabindex="11" title="Enter Discount" onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no" placeholder="Discount"> </td>
    <td align="center"> <input type="text" name="Amount" validate="float" required="yes" style="text-align:right; width:100%" onKeyUp="setPrice();" tabindex="12"placeholder="Amount"></td>
    <td align="center" valign="bottom"> <div align="right"> <cfinput type="submit" name="AddInvoice" id="AddInvoice" value="Add" tabindex="11"></div></td>
    </tr>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "D5D5FF"><cfset rowColor="FFFFFF"><cfelse><cfset rowColor="D5D5FF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';" >
<td>&nbsp;</td>
<td >&nbsp; #session.myInvoice[variables.counter].Name# </td>
<td > #session.myInvoice[variables.counter].itemDescription# </td>
<td > <div align="right">#session.myInvoice[variables.counter].itemQuantity# </div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#&nbsp; </div></td>
<td> <div align="right">#session.myInvoice[variables.counter].Discount# </div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')#&nbsp; </div></td>
<td> <div align="right" title="Remove this Item"><a href="#cgi.SCRIPT_NAME#?id=#counter#"><font color="##FF0000"><strong>X</strong></font></a>&nbsp; </div></td>
</tr>
</cfloop>


<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.sAmount,#form.Amount#)>
<cfset position = arraylen(session.sAmount)>
<cfset session.sAmount[position] = #form.Amount#>
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.sAmount#,#url.id#)#>
</cfif>
<cfset Amount = #arraySum(session.sAmount)#>
<cfset session.Amount = #Amount#>
</cfform>

<cfform action="#cgi.SCRIPT_NAME#?post=#access#" name="form2" format="html" id="form2" enctype="application/x-www-form-urlencoded">
<tr>
	<td>&nbsp;</td>
  <td colspan="5" align="right"><div align="right"><strong>Total:&nbsp;</strong></div></td>
  <td align="right"><div align="right"><strong>
    <cfinput type="text" name="totalAmount1" id="totalAmount1"  validate="float" value="#LSNumberFormat(Amount,',99.99')#" readonly="true" style="text-align:right; width:100%">
    <cfinput type="hidden" name="totalAmount" id="totalAmount" validate="float" value="#Amount#" readonly="true" >
  </strong></div></td>
  </tr>

<tr>
 <td colspan="7" >
  </td>
</tr>

    <tr>
    <td>&nbsp;</td>
      <td colspan="5" align="right"><div align="right"><strong>Amount Paid:&nbsp;</strong></div></td>
      <td align="right" ><div align="right"><strong>
        <cfinput type="text" name="amountPaid" message="Enter Amount Paid" required="yes" validate="float" id="amountPaid"  style="text-align:right; width:100%" tabindex="7" autocomplete="off" onKeyUp="checkBalance();" value="#Amount#">
        <cfinput type="hidden" name="amountPaid2" id="amountPaid2" value="#LSNumberFormat(Amount,',9.99')#" readonly="yes" >
      </strong></div></td>
      <td align="center">&nbsp;</td>
    </tr>
    <tr bgcolor="##4AA5FF">
    <td>&nbsp;</td>
<td colspan="5" align="right"><div align="right"><strong>Balance:&nbsp;</strong></div></td>
<td align="right"><div align="left"><strong>

  <cfinput type="text" name="balance" id="Balance"  align="right" style="text-align:right; width:100%" readonly="yes">
  
</strong></div></td>

<td align="right"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##FF0000"><strong>Reset</strong></font></a><cfinput name="post" id="post" type="submit" value="Post"></td>
</tr>
</cfform>

</table>
</div>


<cfif url.reset is "1">
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.sAmount#)>
<cfset structdelete(session, 'CustomerID')>
<cfset structdelete(session, 'SalesID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'totalAmountSum')>
<cfset structdelete(session, 'AmountPaid')>
<cfset structdelete(session, 'Balance')>
<cfset structdelete(session, 'myInvoice')>
<cfset structdelete(session, 'sAmount')>

</cfif>

</cfoutput>

</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
