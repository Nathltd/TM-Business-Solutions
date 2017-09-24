// JavaScript Document
$(document).ready(function(){
	$('#msg2').hide();
	$('#SalesID').blur(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getDebitNoteId",
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