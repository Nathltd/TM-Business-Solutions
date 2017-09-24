<!doctype html>
<html>
<head>
<title><cfoutput>Sales Invoice :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
<script src="googleJquery-min.js"></script>
<link rel="stylesheet" type="text/css" href="googleJquery-ui.css">
<script src="googleJquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="../css/styles2.css">
<script type="text/javascript" src="jquery.scannerdetection.js"></script>
<script type="text/javascript">
    $(document).scannerDetection({

    });

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

</script>
<script src="barcode.js"></script>
</head>
<body>
<form>
<table>
<tr align="center" bgcolor="##E9E9E9">
        <td align="center" width="8%"> <strong>Item Code</strong></td>
        <td align="center" width="22%"> <strong>Item Name</strong></td>
        <td  width="25%"> <strong>Description</strong></td>
        <td align="center"  width="7%"> <strong>Qty</strong></td>
        <td align="center"  width="8%"> <strong>Rate</strong></td>
        <td align="center"  width="7%"> <strong>Discount</strong></td>
        <td align="center" width="8%"> <strong>Amount</strong></td>
        <td align="center" width="5%">&nbsp;</td>
    </tr>
<tr>    
    <td><input type="text" name="itemCode" id="itemCode"  style="width:100%" message="Select A Product" tabindex="8" title="Item Code" placeholder="Item Code" autofocus></td>
    <td><input type="text" name="itemName" id="itemName"  style="width:100%" required="yes"  message="Select A Product" placeholder="Product Id" tabindex="8" title="Item Name"></td>
    <td><input name="Description" id="Description" type="text" readonly style='width:100%' title="Description" placeholder="Description" required></td>
    <td> <input type="text" name="Quantity" id="Quantity" validate="float" tabindex="9" required="yes" message="Enter quantity sold" onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no" value="1"> </td>
    <td> <input type="text" name="Price" id="Price" validate="float" tabindex="10" required="yes" message="Enter item price"  onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no" placeholder="Price"> </td>
    <td> <input type="text" name="Discount" id="Discount" validate="float" tabindex="11" title="Enter Discount" onKeyUp="checkValue();" style="text-align:right; width:100%" autosuggest="no" placeholder="Discount"> </td>
    <td align="center"> <input type="text" name="Amount" validate="float" required="yes" style="text-align:right; width:100%" onKeyUp="setPrice();" tabindex="12"placeholder="Amount"></td>
    <td align="center" valign="bottom"> <div align="right"> <input type="submit" name="AddInvoice" id="AddInvoice" value="Add" tabindex="13"></div></td>
    </tr>
    </table>
</form>
</body>
</html>