// JavaScript Document
$(document).ready(function(){
	$('#msg').hide();
	$('#ref').blur(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getPayId",
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
		if(id.toLowerCase() == valData.toLowerCase() || id == ''){
			$('#addInvoice').attr('disabled',true);
			$('#msg').show(500);
			$(this).focus(function(){
			$('#msg').hide(500);});
		}
		else {
			$('#addInvoice').attr('disabled',false);
		}
						
	});
	$('#expenseDate').blur(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "closingDate",
			returnFormat: "json"},
			async: false,
		    cache: false,
		    dataType: 'text',
			dataFilter: function(data) {
			valData = data;
			}
		});
		if(id == '' || id == valData){
			$('#addInvoice').attr('disabled',true);
			$('#msg').show(500);
			$(this).focus(function(){
			$('#msg').hide(500);});
		}
		else {
			$('#addInvoice').attr('disabled',false);
		}
						
	});
	$('#msg').css({
	'position':'relative',
	'float':'right',
	'color':'#F00',
	'font-size':'8px'
	});
	
});