<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>SAMPLE CHECK-OUT PAGE</title>
<script src="googleJquery-min.js"></script>
<link rel="stylesheet" type="text/css" href="googleJquery-ui.css">
<script src="googleJquery-ui.min.js"></script>
    <script type="text/javascript">
	$(document).ready(function(){
		var listItems = '<option selected="selected" value="">- Select -</option>';
		var listStaff = '<option selected="selected" value="">- Select -</option>';
		
		$("#dob").text("N0.00");
    $.ajax({
    type: "get", 
	url: "../cfc/bind.cfc",
	dataType: "json",
    data: {
			method: "AllStates",
			returnFormat: "json",
			},
	async: false,
	cache: false,
	dataFilter: function(data) {
				myData = JSON.parse(data);
			},			
    success: function( json ) {
        for (var i = 0; i < myData.DATA.length; i++) {
             listItems += "<option value='" + myData.DATA[i] + "'>" + myData.DATA[i] + "</option>";
         }
 
         $("#BranchID").html(listItems);
		 $("#StaffID").html(listStaff);
    }
});
$("#BranchID").on('change',function(){
	var listStaff = '<option selected="selected" value="">- Select -</option>';
	$.ajax({
    type: "get", 
	url: "../cfc/bind.cfc",
	dataType: "json",
    data: {
			method: "AllLGAs",
			returnFormat: "json",
			state:$('#BranchID').val()
			},
	async: false,
	cache: false,
	dataFilter: function(data) {
				myData = JSON.parse(data);
			},			
    success: function( json ) {
        for (var i = 0; i < myData.DATA.length; i++) {
             listStaff += "<option value='" + myData.DATA[i] + "'>" + myData.DATA[i] + "</option>";
         }
 
         $("#StaffID").html(listStaff);
    }
	});
	});
	
	$("#StaffID").on('change',function(){
	$.ajax({
    type: "get", 
	url: "../cfc/bind.cfc",
	dataType: "json",
    data: {
			method: "LGAsPrice",
			returnFormat: "json",
			state:$('#BranchID').val(),
			lga:$('#StaffID').val()
			},
	async: false,
	cache: false,
	dataFilter: function(data) {
				cost = JSON.parse(data);
			},			
    success: function( json ) {

         $('#dob').val(cost[1]);
		 var dob = $('#dob').val();
		 var amount = $('#amount').val();
		 var dob = parseInt(dob);
		 var amount = parseInt(amount);
		 $('#totalAmount').val(dob + amount);
		 
    }
	});
	});
});
    </script>
    <style>
	body{
		font-family:"Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", Verdana, sans-serif;
	}
	</style>
    </head>
    <body>
    <h2>SAMPLE CHECK-OUT PAGE</h2>
    <form>
    <table width="546" cellpadding="3" cellspacing="5">
    <tr>
    <td colspan="2">VALUE FOR ITEM PURCHASED</td>
    <td><input type="text" id="amount" style="width:100%; text-align:right" value="25700" readonly></td>
	</tr>
    <tr>
    <td colspan="3">BILLING ADDRESS</td>
    </tr>
    <tr>
    <td width="160">Name:</td>
    <td width="185"><input type="text" id="name" name="name" style="width:100%"></td>
    <td width="117"></td>
    <td width="33"></td>
    </tr>
    <tr>
    <td>Address:</td>
    <td>
    <input type="text" id="add" style="width:100%">
    </td>
    <tr>
    <tr>
    <td>State:</td>
    <td>
    <select id="BranchID" style="width:100%"> </select>
    </td>
    <tr>
    <td>L.G.A</td>
    <td>    
    <select id="StaffID" style="width:100%"> </select>
    </td>
    <td>
    <input type="text" id="dob" name="dob" style="width:100%; text-align:right" readonly>
    </td>
    <td>
    
    </td>
    </tr>
    <tr>
    <td colspan="2">TOTAL AMOUNT</td>
    <td><input type="text" id="totalAmount" style="width:100%; text-align:right" readonly></td>
	</tr>
    </table>
    </form>
    
    </body>
</html>