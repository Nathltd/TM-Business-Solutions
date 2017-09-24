<script src="googleJquery-min.js"></script>
<script type="text/javascript">
	$(document).ready(function($) {
		
		$.ajax({
	   url:"cfc/bind.cfc?method=getCustomers&returnFormat=json",
	   dataType:"json",
	   async: false,
	   cache: false,
	   dataFilter: function(data) {
				data = JSON.parse(data);
		   myData = data.DATA;
		   var options = "";
     for (var i = 0; i < myData.length; i++) {
         options += "<option>" + myData[i] + "</option>";
     }
		   $("#CustomerID").html(options);
			},

    });

  $('#CustomerID').change(function(e) {
    var selectvalue = $(this).val();
		$.ajax({
	   url:"cfc/bind.cfc?method=getCustomerAdd&customerId="+selectvalue+"&returnFormat=json",
	   dataType:"json",
	   async: false,
	   cache: false,
	   dataFilter: function(data) {
				data = JSON.parse(data);
		   myData = data.DATA;
		   
		   $("#address").val(myData)
		   
			},

    });
		  

 });
});
</script>
<cfform>

<select id="CustomerID">
	</select><br>
	<cftextarea id="address" name="address"></cftextarea>

</cfform>