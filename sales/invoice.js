// Check for Invoice Number Duplicate

$(document).ready(function(){
	$('#msg2').hide();
	$('#SalesID').blur(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getSalesId",
			returnFormat: "json",
			ref:$(this).val()
					},
			async: false,
		    cache: false,
		    dataType: 'text',
			dataFilter: function(data) {
			valData = data;
			}
		});
		if($.isNumeric($(this).val())){
			if(id == valData || id == ''){
				$('#AddInvoice').attr('disabled',true);
				$('#post').attr('disabled',true);
				$('#msg2').show(500);
				$(this).focus(function(){
				$('#msg2').hide(500);});
			}
			else {
				$('#AddInvoice').attr('disabled',false);
				$('#post').attr('disabled',false);
			}
		}
		else
		{
  			$('#AddInvoice').attr('disabled',true);
			$('#post').attr('disabled',true);
			$('#stockCheck').show();
			$('#msg').text('Invoice Number must be a number!');
			event.preventDefault();	
		}
		$('#ok').click(function(event){
			$('#stockCheck').hide();
			event.preventDefault();
		});
						
	});
	
	$('#msg2').css({
	'position':'relative',
	'float':'right',
	'color':'#F00',
	'font-size':'8px'
	});
	
});

// Add Inventory Item on Invoice, Check Quantity Available, Validate Selling Price

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

// Check Invoice Value Against Customer's Credit Limit


$(document).ready(function(){
	$('#stockCheck').hide();
	$('#amountPaid').blur(function(event) {
		var balance = $("#balance").val();
			balance = parseInt(balance);
			$.ajax({type: "get", url: "../cfc/bind.cfc",
				data: {
				method: "OutStanding",
				returnFormat: "json",
				customerId:$("#CustomerID").val()
				},
				async: false,
				cache: false,
				dataType: 'text',
				dataFilter: function(data) {
				valData = parseInt(data);
				}
			});
			$.ajax({type: "get", url: "../cfc/bind.cfc",
				data: {
				method: "creditLimit",
				returnFormat: "json",
				customerId:$("#CustomerID").val()
				},
				async: false,
				cache: false,
				dataType: 'text',
				dataFilter: function(data) {
				creditLimit = parseInt(data);
				}
			});
			var total = balance + valData
			if(creditLimit!==0){
			if(total>0){
				var total = (total+"").replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
				$('#stockCheck').show();
				$('#msg').text('Credit Limit Exceeded by N'+total);
				$('#post').attr('disabled',true);
				}
			else {
				$('#stockCheck').hide();
				$('#post').attr('disabled',false);
				}
			
			$(this).focus(function(){
			$('#post').attr('disabled',false);});
			$('#ok').click(function(event){
			$('#stockCheck').hide();
			event.preventDefault();
			});
			};
		});
});


// Calculations on Invoice

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

// Bank Account Selection


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


// Customer Id & Address Selection

	$(document).ready(function($) {
		
		$.ajax({
	   url:"../cfc/bind.cfc?method=getCustomers&returnFormat=json",
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
		   $("#CustomerID").html(options);
			},

    });

  $('#CustomerID').change(function(e) {
    var selectvalue = $(this).val();
		$.ajax({
	   url:"../cfc/bind.cfc?method=getCustomerAdd&customerId="+selectvalue+"&returnFormat=json",
	   dataType:"json",
	   async: false,
	   cache: false,
	   dataFilter: function(data) {
				data = JSON.parse(data);
		   myData = data.DATA;
		   
		   $("#address").val(myData)
		   
			},

    });
		  

 });
});
