// JavaScript Document
$(document).ready(function(){
//setup before functions
var typingTimer;                //timer identifier
var doneTypingInterval = 30;  //time in ms, 5 second for example
var $input = $('#itemCode');

//on keyup, start the countdown
$input.on('keyup', function () {
  clearTimeout(typingTimer);
  typingTimer = setTimeout(doneTyping, doneTypingInterval);
});

//on keydown, clear the countdown 
$input.on('keydown', function () {
  clearTimeout(typingTimer);
});

//user is "finished typing," do something
function doneTyping () {
  //do something

  $.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getBarcode",
			returnFormat: "json",
			itemCode:$('#barCode').val(),
			branchid:$('#branchId').val()
					},
			async: false,
		    cache: false,
		    dataType: "json",
			dataFilter: function(data) {
				myData = JSON.parse(data);
			}
		});
		$('#itemName').val(myData[2]);
		$('#Description').val(myData[3]);
		$('#Price').val(myData[4]);
		$('#Quantity').val(myData[5]);
		$('#Quantity').select();
}
});

$(function() {
         
            $('#Description').val("");
             
            $("#itemName").autocomplete({
                source: "JQueryCFitems.cfm",
                minLength: 1,
                select: function(event, ui) {

					$('#Description').val(ui.item.description);
					$('#Price').val(ui.item.salePrice);
					$('#Quantity').val(ui.item.balance);
					$('#Quantity').select();
                }
            });
        });

