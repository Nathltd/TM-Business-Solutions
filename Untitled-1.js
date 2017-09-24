// JavaScript Document\
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
    			if(qty>currentQty){
			$('#stockCheck').show();
			$('#msg').text(qty+ ' Quantity not available in stock!')
			event.preventDefault();
				}
		}
		 });

