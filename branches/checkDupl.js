// JavaScript Document
$(document).ready(function(){
	$('#msg').hide();
	$('#BranchName').blur(function(event) {
		 id = $(this).val();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getBranchId",
			returnFormat: "json",
			branchId:$(this).val()
					},
			async: false,
		    cache: false,
		    dataType: 'text',
			dataFilter: function(data) {
			valData = data;
			}
			
		});
		if(JSON.stringify(id).toLowerCase() == valData.toLowerCase() || id == ""){
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