// JavaScript Document
$(document).ready(function(){
	$('#msg').hide();
	$('#ref').blur(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getExpenseId",
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
				$('#msg').show(500);
				$(this).focus(function(){
				$('#msg').hide(500);});
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
						
	});
	
	$('#accountId').blur(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getExpenseAcc",
			returnFormat: "json",
			accountId:$(this).val()
					},
			async: false,
		    cache: false,
		    dataType: 'text',
			dataFilter: function(data) {
			valData = data;
			}
			
		});
		if(JSON.stringify(id).toLowerCase() == valData.toLowerCase() || id == ''){
			$('#submit').attr('disabled',true);
			$('#msg').show(500);
			$(this).focus(function(){
			$('#msg').hide(500);});
		}
		else {
			$('#submit').attr('disabled',false);
		}
						
	});
	$('#msg').css({
	'position':'relative',
	'float':'right',
	'color':'#F00',
	'font-size':'8px'
	});
	
});