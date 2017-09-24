// JavaScript Document
$(document).ready(function(){
	$('#msg').hide();
	$('#ref').blur(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getFtransferId",
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
	});
	$('#mydate').blur(function(event) {
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