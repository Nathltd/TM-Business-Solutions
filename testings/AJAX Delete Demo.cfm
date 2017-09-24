<!doctype html>
<html>
<head>
<title>AJAX Delete Demo</title>
<script src="googleJquery-min.js"></script>
<link rel="stylesheet" type="text/css" href="googleJquery-ui.css">
<script src="googleJquery-ui.min.js"></script>
    <script type="text/javascript">
	$(document).ready(function(){
		$('#delete').click(function(event) {
		$.ajax({
    type: "get", 
	url: "../cfc/bind.cfc",
	dataType: "json",
    data: {
			method: "DeleteCustomer",
			returnFormat: "json",
			customer: $('#customer').val()
			},
	async: false,
	cache: false,		
    success: function( result,status,xhr ) {
        alert(status);
    },
	error: function( xhr,status,error ) {
        alert(error);
    }
});
});
});
</script>
</head>
<body>
<input id="customer">
<button id="delete">Delete</button>
</body>
</html>