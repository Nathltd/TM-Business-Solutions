<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>

</head>


<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm"><br />

<div id="Content">

<h4>Suppliers' Invoice Details</h4>
<br />


<div id="RightColumn">
<br />


  <cfquery name="getDepts">
SELECT distinct VendorId
FROM Vendors
ORDER BY VendorId ASC
  </cfquery>
  
    <cfquery name="MemberList">
SELECT ReceiptID, ReceiptDate, BranchId, TotalAmount, AmountPaid, VendorId
FROM vwVendInvoiceTotalAmt
ORDER BY ReceiptDate ASC 
  </cfquery>
  


<div align="center">
<cfform name="myForm" width="600" >
   
   <cfgrid name="data" query="MemberList" height="400" width="500" rowheaders="no" format="html" highlighthref="no">
      	<cfgridcolumn header="Date" name="ReceiptDate" type="date"/>
         <cfgridcolumn header="Invoice No" name="ReceiptID"  href="../reports/PurchasePrnt.cfm" hrefkey="ReceiptID"/>
         <cfgridcolumn header="Branch" name="BranchId" />
         <cfgridcolumn header="Total Amount"  name="TotalAmount" mask="000,00"/>
         <cfgridcolumn header="Amount Paid"  name="AmountPaid" />
         <cfgridcolumn header="Supplier Id" name="VendorId" display="false" />
      </cfgrid>
</cfform>
</div>
<br />

</div>


</div>  
</div>
</body>
</html>