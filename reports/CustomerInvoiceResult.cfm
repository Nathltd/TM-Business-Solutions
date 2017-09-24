<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div class="mainBody">
<p>&nbsp;

</p>
<div class="font1">

<cfquery name="SalesInvoice" datasource="#request.dsn#">
SELECT ID, SalesID, BranchID, CustomerID, ProductID, Qty, SalesDate
FROM vwSalesUpdate
WHERE SalesID = <cfqueryparam value="#Trim(url.SalesID)#" cfsqltype="cf_sql_clob">
</cfquery>
<br />
<br />
<br /><br />
<cfif #salesInvoice.recordcount# is 0>
<cfoutput><strong> No Item found in Invoice</strong> </cfoutput><br />
<br />
<cfelse>


<cfoutput><strong>Invoice No. #salesInvoice.SalesID# for #salesInvoice.CustomerID# on #dateformat(salesInvoice.SalesDate,"dd/mm/yyyy")# </strong> </cfoutput></<br /><br />
<br />
<br />
<br />
       <cfform name="myForm" format="flash" width="350" height="200">
    <cfgrid name="SalesInvoiceGrid" query="SalesInvoice" gridlines="no" rowheaders="no"  colheaderbold="Yes" fontsize="13"  font = "Tahoma" selectcolor="##949494">

<cfgridcolumn name = "ProductID" header = "Item" width="250" headeralign="center">

<cfgridcolumn name = "Qty" header = "Quantity" width="50" headeralign="center"  dataalign="right">
</cfgrid>
</cfform>
</cfif>
<a href="CustomerInvoice.cfm"> Back to Customers' Invoice </a>
</div>
</div>


    
</div>
</body>
</html>