<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Invoice Details</h4>
<div id="RightColumn">

<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="form.AmountPaid" default="">
<cfparam name="session.AmountPaid" default="form.AmountPaid">
<cfparam name="session.CustomerCode" default="">
<cfparam name="session.InvoiceNo" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchCode" default="">
<cfparam name="session.RepCode" default="">
<cfparam name="session.select" default="">
<cfparam name="url.reset" default="">

<cfquery name="Sales" datasource="#request.dsn#">
SELECT BranchID,SalesID,AmountPaid,AccountID,SalesDate,CustomerID,StaffID
FROM Sales
WHERE SalesID = <cfqueryparam value="#Trim(url.SalesID)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="SalesDetails" datasource="#request.dsn#">
SELECT ID,SalesID,ProductID,Qty,UnitPrice
FROM SalesDetails
WHERE SalesID = <cfqueryparam value="#Trim(url.SalesID)#" cfsqltype="cf_sql_clob">
</cfquery>
<cfoutput>


<cfform action="UpdateInvoice.cfm" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="510" border="0">
    <tr>
      <td><div align="left"></div></td>
      <td>&nbsp;</td>
      <td><div align="left">Date:</div></td>
      <td><div align="left">
      <cfinput type="text" readonly="yes" name="mydate" class="bold_10pt_black" required="yes" value="#Dateformat(Sales.SalesDate,"dd/mm/yyyy")#">
       
      </div>
             </td>
    </tr>
    <tr>
      <td><div align="left">Customer Name:</div></td>
      <td><div align="left">
        <cfinput name="CustomerCode" class="bold_10pt_black" id="CustomerCode" value="#Trim(Sales.customerID)#" readonly="yes">
            
               </div></td>
      <td width="64"><div align="left">Branch:</div></td>
      <td width="100"><div align="left">

        <cfinput type="text" name="BranchCode" id="BranchCode" class="bold_10pt_black" value="#Trim(Sales.BranchID)#" readonly="yes">
            
                    
        </div></td>
      </tr>
      
    <tr>
      <td width="99"><div align="left">Invoice No.
        :</div></td>
      <td width="194"><div align="left">
      <cfinput type="text" name="InvoiceNo" required="yes" class="bold_10pt_black" value="#Sales.SalesID#" tooltip="Invoice Number" readonly="yes">
      </div></td>
      <td><div align="left">Authorised:</div></td>
      <td><div align="left">

       		<cfinput type="text" name="RepName" class="bold_10pt_black" id="RepName" value="#Trim(Sales.StaffID)#" readonly="yes">
            
            
      </div></td>
      </tr>
    <tr>
      <td width="99"><div align="left">Amount Paid
        :</div></td>
      <td width="194"><div align="left">
        <cfinput name="AmountPaid" id="AmountPaid" type="text" align="right" class="bold_10pt_black" value="#Sales.AmountPaid#" readonly="yes">
        
        </div></td>
      <td><div align="left">Account:</div></td>
      <td><div align="left">
        <cfinput type="text" name="select" class="bold_10pt_black" id="select"  value="#Trim(Sales.AccountID)#" readonly="yes">
         
        </div></td>
    </tr>
    </table></div><br>

  <div align="center">

<cfgrid name="SalesUpdate"  query="SalesDetails" gridlines="no" format="html" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" width="400">

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "ProductID" header = "Products" width="220" headeralign="center">
<cfgridcolumn name = "Qty" header = "Quantity" width="60" headeralign="right"  dataalign="right">
<cfgridcolumn name = "UnitPrice" display="Yes" header = "Unit Price" headeralign="right" width="70" dataalign="right">
</cfgrid><br>
</div>

</cfform>
</cfoutput>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>