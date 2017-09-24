
<html>
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>


<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Sales By Invoice</h4>
<div id="RightColumn">

<div align="right"><a href="AllSalesByDate.cfm">reset&nbsp;</a> | <a href="##">print&nbsp;</a></div>
<cfparam name="url.SalesID" default="">

<cfif IsDefined("url.ID") is True>
<cfquery name="Sales" datasource="#request.dsn#">
SELECT BranchID,SalesID,AmountPaid,AccountID,SalesDate,CustomerID,StaffID
FROM Sales
WHERE SalesID = <cfqueryparam value="#Trim(url.ID)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="SalesDetails" datasource="#request.dsn#">
SELECT ID,SalesID,ProductID,Qty,UnitPrice
FROM SalesDetails
WHERE SalesID = <cfqueryparam value="#Trim(url.ID)#" cfsqltype="cf_sql_clob">
</cfquery>
<cfoutput>


<cfform enctype="multipart/form-data">


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
    </table><br>



<cfgrid name="SalesUpdate"  query="SalesDetails" gridlines="no" format="html" fontsize="12"colheaderbold="Yes" colheaders="yes" font = "Tahoma" selectcolor="##949494" width="350">

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center" width="10">
<cfgridcolumn name = "ProductID" header = "Products" width="220" headeralign="center">
<cfgridcolumn name = "Qty" header = "Quantity" width="60" headeralign="right"  dataalign="right">
<cfgridcolumn name = "UnitPrice" display="Yes" header = "Unit Price" headeralign="right" width="70" dataalign="right">
</cfgrid><br>


</cfform>
</cfoutput>

<cfelse>

<cfquery name="SalesByInvoice" datasource="#request.dsn#">
SELECT SalesDate, BranchID, ProductID, Qty, SalesID
FROM vwSalesUpdate
WHERE ProductID = <cfqueryparam value="#url.ProductID#" cfsqltype="cf_sql_clob"> AND BranchID = <cfqueryparam value="#url.BranchID#" cfsqltype="cf_sql_clob"> AND SalesDate = <cfqueryparam value="#dateformat(url.SalesDate,"dd/mm/yyyy")#" cfsqltype="cf_sql_clob">
ORDER BY BranchID, SalesID ASC 
</cfquery>


<cfif #SalesByInvoice.recordcount# eq 0><br />
<br />

No Item sold on <cfoutput><strong> #url.SalesDate#</strong> </cfoutput><br /><br />

<cfelse>

<div>
<p>
<cfoutput><strong>#SalesByInvoice.recordcount# record(s)</strong> found on <strong>  #url.SalesDate#</strong> </cfoutput></strong>
</p>



<table width="366" border="0" cellpadding="5" cellspacing="0">
<tr>
<td width="64"><strong>Branch</strong></td>
<td width="69"><strong>Invoice No</strong></td>
<td width="135"><strong>Item Name</strong></td>
<td width="58"><div align="right"><strong>Qty Sold</strong></div></td>
</tr>
<tr>
<td></td>
</tr>
<cfoutput>
<cfloop query="SalesByInvoice">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onmouseover="this.bgColor='FFCCCC';" onmouseout="this.bgColor='#rowColor#';">
<td>#BranchID#</td>
<td><a href="#cgi.SCRIPT_NAME#?ID=#SalesID#">#SalesID#</a></td>
<td>#ProductID#</td><td align="right"><div align="right">#Qty#</div></td>
</tr>
</cfloop>
</cfoutput>
</table>
</div>
</cfif><br />

</div>



</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>