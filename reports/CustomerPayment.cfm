<!doctype html>
<html>
<head>
<title><cfoutput>Customer Payments List :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
 
 <style type="text/css">
.x-grid3-hd-4 {text-align:right;}
.x-grid3-hd-5 {text-align:right;}
 .x-grid3-col-4 {text-align:right;}
 .x-grid3-col-5 {text-align:right;}
</style>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<br />
<h4>Customers' Payment Details</h4>
<br />
<div id="RightColumn">


  
<cfquery name="payments">
SELECT paymentId,paymentDate,customerId,type,amount,accountID,payDetails,creator
FROM Payments
ORDER BY paymentDate, ID ASC
</cfquery>
  

<div align="center">
<cfform name="myForm" width="600" >
<br />



      <cfgrid name="data" query="payments" height="400" width="500" rowheaders="no" format="html" highlighthref="no">
      	<cfgridcolumn header="Date" name="paymentDate" type="date"/>
         <cfgridcolumn header="Receipt No" name="paymentId"  href="../reports/paymentPrnt.cfm" hrefkey="paymentId"/>
         <cfgridcolumn header="Account" name="accountID" />
         <cfgridcolumn header="Amount"  name="amount"/>
         <cfgridcolumn header="Customer Id" name="CustomerId" display="false" />
      </cfgrid>

<br />

</cfform>
</div>
</div>


</div>  
</div>
</body>
</html>