
<script src="../googleJquery-min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#AddInvoice').click(function(event) {
		event.preventDefault();
		$.ajax({type: "get", url: "../cfc/bind.cfc",
			data: {
			method: "getCustomerId",
			returnFormat: "json",
			customerId:'Rep. Stella Anyaoha'
					},
			async: false,
		    cache: false,
		    dataType: "json",
			dataFilter: function(data) {
			currentQty = data;
			}
		});
			alert(currentQty);
			event.preventDefault();
		$('#ok').click(function(event){
			$('#stockCheck').hide();
			event.preventDefault();
		});
	});
	
});
</script>
<form>
<input id="customerId" type="text">
<button id="AddInvoice">Show</button>
</form>