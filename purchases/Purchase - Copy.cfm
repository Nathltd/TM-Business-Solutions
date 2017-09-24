<!doctype html>
<html>
<head>
<title><cfoutput>Purchase ::: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
<script src="checkDup.js" type="application/javascript"></script>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>New Purchase</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
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
<cfquery>

INSERT INTO Purchase
(ReceiptID,ReceiptDate,BranchId,VendorID,StaffID,AmountPaid,LastUpdated,Creator,AccountId)
VALUES ('#session.PurchaseID#', '#lsDateFormat(CreateODBCDate(session.myDate), "dd/mm/yyyy")#', '#session.BranchID#',  '#session.SupplierID#', '#session.StaffID#', <cfqueryparam value="#amountPaid#" cfsqltype="cf_sql_double">, '#lsDateFormat(CreateODBCDate(session.todate), "dd/mm/yyyy")#', '#GetAuthUser()#', '#session.AccountID#')
</cfquery>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">

<cfquery>

INSERT INTO PurchaseDetails
(ProductId, UnitPrice, Qty, ReceiptID,discount)
VALUES ('#session.myInvoice[variables.counter].Name#',
'#session.myInvoice[variables.counter].itemPrice#',  '#session.myInvoice[variables.counter].itemQuantity#', 
'#session.PurchaseID#',  '#session.myInvoice[variables.counter].discount#')
</cfquery>
</cfloop>
</cftransaction>

<div align="Right">
<cfset url.cfgridkey = #session.PurchaseID#>
<cfoutput><a href="../reports/PurchasePrnt.cfm?cfgridkey=#url.cfgridkey#">Print</a></cfoutput>&nbsp;&nbsp;
</div>
<cfoutput> Purchase No. <strong>#session.PurchaseID#</strong> have been posted successfully<a href="Purchase.cfm"> New Purchase </a></cfoutput><br>
<br>
<table>
<cfoutput> 
<tr>
<td><div align="right">Supplier:</div></td>
<td><strong> #session.SupplierID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Invoice No:</div></td>
<td><strong> #session.PurchaseID#</strong></td>

<td><div align="right">Purchase Date:</div></td><td><strong> #session.myDate#</strong></td>
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
<td> <strong>Quantity</strong></td>
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
<td align="center"> #session.myInvoice[variables.counter].discount#&##37;</td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')# </td>

</tr>
</cfloop>
</cfoutput>
</table>


<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.pAmount" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="form.AmountPaid" default="">
<cfparam name="session.SupplierID" default="">
<cfparam name="session.PurchaseID" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchID" default="">
<cfparam name="session.StaffID" default="">
<cfparam name="session.AccountID" default="">
<cfparam name="form2.totalAmount" default="0">
<cfparam name="form2.amountPaid" default="0">
<cfparam name="url.reset" default="">



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
<cfset session.SupplierID = #form.VendorID#>
<cfset session.PurchaseID = #form.PurchaseID#>
<cfset session.BranchID = #form.BranchID#>
<cfset session.mydate = #form.mydate#>
<cfset session.StaffID = #form.StaffID#>
<cfset session.AccountID = #form.AccountID#>
<cfset session.totalAmountSum = #form2.totalAmount#>
<cfset session.AmountPaid = #form2.AmountPaid#>
<cfset todayDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset session.todate = #todayDate#>

<!--- Remove items from invoice list --->
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.myInvoice#,#url.id#)#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.pAmount#)>
<cfset structdelete(session, 'SupplierID')>
<cfset structdelete(session, 'PurchaseID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'totalAmountSum')>
<cfset structdelete(session, 'AmountPaid')>
<cfset structdelete(session, 'Balance')>
</cfif>

<script> 

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
		var itemAmount = (document.form.Quantity.value)*(document.form.Price.value);
		var itemDiscount = (document.form.Discount.value -0)/100;
		var totalAmt = itemAmount * itemDiscount;
		var totalAmt = itemAmount - totalAmt;
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

</script>

<cfoutput>
  <cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">
  <div>
  <table width="90%" border="0">
     <tr>
      <td><div align="left">Supplier:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset Vendor = "#form.VendorID#">
          <cfinput type="text" name="VendorID" id="VendorID" style="text-align:left; width:100%" required="yes" value="#Vendor#" readonly="yes" >
          <cfelse>
          <cfselect name="VendorID" id="VendorID" required="yes" style="text-align:left; width:100%" message="Select A Warehouse" bind="cfc:#request.cfc#cfc.bind.Suppliers()" display="VendorID" value="VendorID" bindonload="yes" tabindex="1" autofocus title="Supplier's Name"> </cfselect>
          </cfif>
      </div></td>
      <td>&nbsp;</td>
      <td><div align="left">Date:</div></td>
      <td><div align="left">
      <cfif isdefined('form.AddInvoice')>
       <cfset invDate = "#form.mydate#">
       <cfinput type="text" name="mydate" style="text-align:left; width:100%" required="yes" value="#invDate#" readonly="yes">
       <cfelse>
       <cfinput type="datefield" mask="dd/mm/yyyy" style="width:100%" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Purchase Date" required="yes" message="Enter valid date"/>
        </cfif>
      </div>
             </td>
    </tr>
    <tr>
      <td><div align="left">Invoice No.
        :</div></td>
      <td width="242"><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset invNo = "#form.PurchaseID#">
          <cfinput type="text" name="PurchaseID" style="text-align:left; width:100%" required="yes"  value="#invNo#" title="Invoice Number" readonly="yes" autocomplete="off">
          <cfelse>
          <cfinput name="PurchaseID" type="text" id="PurchaseID" style="text-align:left; width:100%" required="yes" message="Enter an Invoice number" autocomplete="off" tabindex="3" title="Invoice Number" validate="integer" />
          <span id="msg">&nbsp;Invoice ## already exist</span>
          </cfif>
      </div></td>
      <td width="289">&nbsp;</td>
      <td width="77"><div align="left">Warehouse:</div></td>
      <td width="240"><div align="left">

        <cfif isdefined('form.AddInvoice')>
               <cfset Branch = "#form.BranchID#">
               <cfinput type="text" name="BranchID" id="BranchID" style="text-align:left; width:100%" required="yes" value="#Branch#" readonly="yes">
       		<cfelse>
            <cfselect name="BranchID" id="BranchID" required="yes" title="Select Purchase Location" bind="cfc:#request.cfc#cfc.bind.Warehouse()" display="BranchID" value="BranchID" bindonload="yes" tabindex="4" style="text-align:left; width:100%"> </cfselect>
            
        </cfif>
        
        </div></td>
      </tr>
      
    <tr>
      <td width="80"><div align="left">Account:</div></td>
      <td width="242"><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset Account = "#form.AccountID#">
          <cfinput type="text" name="AccountID" id="AccountID" style="text-align:left; width:100%" required="yes" value="#Account#" readonly="yes" title="Account Name">
          <cfelse>
          <cfselect name="AccountID" id="AccountID" required="yes" style="text-align:left; width:100%" message="Select an Account" bind="cfc:#request.cfc#cfc.bind.getBankAccount()" display="AccountID" value="AccountID" bindonload="yes" tabindex="5"  title="Account Name"> </cfselect>
          </cfif>
      </div></td>
      <td width="289">&nbsp;</td>
      <td><div align="left">Authorised:</div></td>
      <td><div align="left">

            <cfif isdefined('form.AddInvoice')>

               <cfset Staffd = "#form.StaffID#">
            <cfinput type="text" name="StaffID"  required="yes"  value="#Staffd#" title="Signatory" readonly="yes" style="text-align:left; width:100%">   
            <cfelse>
        <cfselect name="StaffID"  id="StaffID" title="Staff that authorised the invoice" required="yes" message="Select Authorised" bind="cfc:#request.cfc#cfc.bind.getStaffFund({BranchID})" display="FirstName" value="FirstName" bindonload="yes" tabindex="6" style="text-align:left; width:100%">
        </cfselect>
        </cfif>
      </div></td>
      </tr>
      <tr>
      <td colspan="3">&nbsp;</td><td></td>
      <td></td>
      </tr>
  </table>
  </div>
  <div align="center">
  
  <table width="90%" bgcolor="##E6F2FF" border="0" cellpadding="3" cellspacing="0" bordercolor="999999">
<tr align="center">
<td align="center"  width="25%"> <strong>Item Name</strong></td>
<td  width="27%"> <strong>Description</strong></td>
<td align="center"  width="7%"> <strong>Qty</strong></td>
<td align="center"  width="8%"> <strong>Unit Price</strong></td>
<td align="center"  width="7%"> <strong>Discount</strong></td>
<td align="center" width="13%"> <strong>Amount</strong></td>
<td align="center" width="5%">&nbsp;</td>
</tr>

<tr>

<td> <cfselect name="itemName" id="itemName" style="width:100%" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.allProducts()" display="ProductID" value="ProductID" tabindex="8" bindonload="yes" title="Item Name">
</cfselect>
      </td>
   <td><cfinput name="Description" id="Description" type="text"  bind="cfc:#request.cfc#cfc.bind.getDescription({itemName})" readonly="true" style='width:100%' bindonload="yes" title="Description"></td>

<td><cfinput type="text" name="Quantity" validate="float" tabindex="9"  required="yes" message="Enter quantity sold" value="1" onKeyUp="checkValue();" style="text-align:right; width:100%" autocomplete="off"></td>
<td> <cfinput type="text" name="Price" validate="float" tabindex="10"  required="yes" message="Enter item price" bind="cfc:#request.cfc#cfc.bind.CostPrice({itemName})" onKeyUp="checkValue();" style="text-align:right; width:100%" autocomplete="off"> </td>
<td> <cfinput type="text" name="Discount" validate="float" tabindex="11" title="Enter Discount in Percentage" placeholder="0&##37;" onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no"> </td>
<td align="center"> <cfinput type="text" name="Amount" validate="float" tabindex="12" required="yes" style="text-align:right; width:100%" onKeyUp="setPrice();"></td>
<td align="center" valign="bottom"> <div align="right"> <cfinput type="submit" name="AddInvoice" value="Add" tabindex="13" class="bold_10pt_Button" id="AddInvoice"></div></td>

</tr>

<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td > #session.myInvoice[variables.counter].Name# </td>
<td > #session.myInvoice[variables.counter].itemDescription# </td>
<td > <div align="right">#session.myInvoice[variables.counter].itemQuantity# </div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#&nbsp; </div></td>
<td> <div align="right">#session.myInvoice[variables.counter].Discount#&##37;</div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')#&nbsp; </div></td>
<td> <div align="right" title="Remove this Item"><a href="#cgi.SCRIPT_NAME#?id=#counter#"><font color="##FF0000"><strong>X</strong></font></a>&nbsp; </div></td>
</tr>
</cfloop>
 
<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.pAmount,#form.Amount#)>
<cfset position = arraylen(session.pAmount)>
<cfset session.pAmount[position] = #form.Amount#>
<cfelseif isdefined("url.id") >
<cfset #ArrayDeleteAt(#session.pAmount#,#url.id#)#>
</cfif>
<cfset Amount = #arraySum(session.pAmount)#>
<cfset session.Amount = #Amount#>
</cfform>

<cfform action="#cgi.SCRIPT_NAME#?post=#access#" name="form2" format="html" id="form2" enctype="application/x-www-form-urlencoded">
<tr>

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
      <td colspan="5" align="right"><div align="right"><strong>Amount Paid:&nbsp;</strong></div></td>
      <td align="right" ><div align="right"><strong>
        <cfinput type="text" name="amountPaid" message="Enter Amount Paid" required="yes" validate="float" id="amountPaid" onKeyUp="checkBalance();" style="text-align:right; width:100%" tabindex="7" autocomplete="off" placeholder="#LSNumberFormat(Amount,',9.99')#" >
      </strong></div></td>
      <td align="center">&nbsp;</td>
    </tr>
    
<tr bgcolor="##4AA5FF">
<td colspan="5" align="right"><div align="right"><strong>Balance:&nbsp;</strong></div></td>
<td align="right"><div align="left"><strong>
<!---<cfparam name="Bl" default="">
<cfparam name="form.AmountPaid" default="">
    <cfif isdefined('form.AddInvoice')>
      <cfset Bl = #session.amount#-#Amount#>
      </cfif>--->
  <cfinput type="text" name="balance" id="Balance"  align="right" style="text-align:right; width:100%" readonly="yes" placeholder="0.00" >
  
</strong></div></td>

<td align="center"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##FF0000"><strong>Reset</strong></font></a><font color="##FFFFFF"><strong>|</strong></font><cfinput name="post" id="post" type="submit" value="Post"></td>
</tr>
</cfform>

</table>
</div>
<cfif url.reset is "1">
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.pAmount#)>
<cfset structdelete(session, 'SupplierID')>
<cfset structdelete(session, 'PurchaseID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'totalAmountSum')>
<cfset structdelete(session, 'AmountPaid')>
<cfset structdelete(session, 'Balance')>
</cfif>

</cfoutput>
</cfif>
</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>