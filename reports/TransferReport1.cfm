<!doctype html>
<html>
<head>
<title><cfoutput>Transfer Report :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">
    <cfquery name="MemberList" datasource="#request.dsn#">
SELECT TransferID, TransferDate, Source,  Destination, Quantity, ProductID
FROM vwTransferUpdate
ORDER BY TransferDate ASC 
  </cfquery>
<h4>Product Transfers Details <cfoutput>(#MemberList.recordcount# Records)</cfoutput></h4>

<div id="RightColumn">
<br />
  


<div align="center">
<cfform name="myForm" width="70%" >
<cfgrid name="data" query="MemberList" height="400" width="700" rowheaders="no" format="html" highlighthref="no">
      	<cfgridcolumn header="Date" name="TransferDate" type="date"/>
         <cfgridcolumn header="Transfer No" name="TransferID"/>
         <cfgridcolumn header="Product" headeralign="center"  name="ProductID" />
         <cfgridcolumn header="Source" headeralign="center"  name="Source" />
         <cfgridcolumn header="Destination" headeralign="center"  name="Destination" />
         <cfgridcolumn header="Quantity" headeralign="center"  name="Quantity" dataalign="right"/>
      </cfgrid>
      </cfform>

</div>
</div> 
</div>
</body>
</html>