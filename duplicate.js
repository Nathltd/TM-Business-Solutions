// JavaScript Document
$(document).ready(function(){
	$('#show').click(function(event) {
		var id = $(this).val();
		$.ajax({type: "get", url: "cfc/bind.cfc",
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
		alert(valData);
	});
});