<!doctype html>
<html>
<head>
<title><cfoutput>Product Assembly :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Product Assembly</h4>
<div id="RightColumn">

<cfparam name="url.Sales" default="">
<cfif url.Sales is "yes">

<cftransaction>
<cftry>
<cfquery>
INSERT INTO AssemInvtry
(RefID,AssemDate,BranchID,ProductId,StaffID,LastUpdated,Creator)
VALUES ('#session.SalesID#', '#session.myDate#', '#session.BranchID#', '#session.customerID#', '#session.StaffID#', '#session.todate#', '#GetAuthUser()#')
</cfquery>

 <cfcatch type="database">
<h3>An Error Has Occured</h3><br>

<cfoutput>
<cfif #cfcatch.SQLstate# is "23000">
Invoice No. #session.SalesID# Already Exits<br>
<p>
<a href="#cgi.SCRIPT_NAME#?">Try Again</a>
</p>
</cfif>
<!--- and the diagnostic message from the ColdFusion server --->
<cfif #GetUserRoles()# is "Administrator">
<p>Type = #CFCATCH.TYPE# </p>
<p>Message = #cfcatch.detail#</p>
<p>Code = #cfcatch.SQLstate#</p>
<cfloop index = i from = 1 to = #ArrayLen(CFCATCH.TAGCONTEXT)#>
<cfset sCurrent = #CFCATCH.TAGCONTEXT[i]#>
Occured on Line #sCurrent["LINE"]#, Column #sCurrent["COLUMN"]#
</cfloop>
</cfif>
</cfoutput>
<cfabort>
</cfcatch>
</cftry>

<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery>
INSERT INTO AssemInvtryDtls
(ProductId, UnitPrice, Qty, RefID)
VALUES ('#session.myInvoice[variables.counter].Name#',
'#session.myInvoice[variables.counter].itemPrice#',  '#session.myInvoice[variables.counter].itemQuantity#', 
'#session.SalesID#')
</cfquery>
</cfloop>
</cftransaction>
<cfoutput>
<div align="right"> <a href="#cgi.SCRIPT_NAME#"> New Invoice </a>  |  <a href="../Reports/InvoicePrnt.cfm?SalesID=#session.SalesID#">Print</a>&nbsp;</div>
 Invoice No. <strong>#session.SalesID#</strong> have been posted successfully
 </cfoutput><br>
<br>
<table>
<cfoutput> 
<tr>
<td><div align="right">Product:</div></td>
<td><strong> #session.CustomerID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Ref No:</div></td>
<td><strong> #session.SalesID#</strong></td>

<td><div align="right">Assembled Date:</div></td><td><strong> #session.myDate#</strong></td>
</tr>
<tr>
<td><div align="right">Location:</div></td><td><strong> #session.BranchID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Signed By:</div></td><td><strong> #session.StaffID#</strong></td>

<td><div align="right">Qunatity:</div></td><td><strong> #session.ProductQty#</strong></td>
</tr>
<tr align="center">
<td> </td>
</tr>
<tr align="center">
<td height="29"> </td>
<td> </td>
<td> </td>
<td> </td>
<td> </td>
</tr>
<tr align="center">
<td > <strong>Item Name</strong></td>
<td colspan="5"> <strong>Description</strong></td>
<td> <strong>Quantity </strong></td>
<td> <strong>Unit Cost</strong></td>
<td> <strong>Amount</strong></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="center"> #session.myInvoice[variables.counter].Name# </td>
<td align="center" colspan="5"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="center"> #session.myInvoice[variables.counter].itemQuantity# </td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#</td>
<td align="right"> #LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')# </td>

</tr>
</cfloop>
</cfoutput>
</table>

<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.sAmount" default="#arraynew(1)#" type="array">
<cfparam name="session.totalAmountSum" default="">
<cfparam name="session.Balance" default="">
<cfparam name="session.AmountPaid" default="">
<cfparam name="session.CustomerID" default="">
<cfparam name="session.SalesID" default="">
<cfparam name="session.mydate" default="">
<cfparam name="session.BranchID" default="">
<cfparam name="session.StaffID" default="">
<cfparam name="session.AccountID" default="">
<cfparam name="session.ProductQty" default="">
<cfparam name="url.reset" default="">

<cfquery name="Accounts">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>

<cfquery name="Branches">
SELECT BranchID, Description
FROM Branches
ORDER BY BranchID ASC 
</cfquery>
<cfquery name="Staff">
SELECT StaffID, LastName, FirstName
FROM Staff
ORDER BY StaffID ASC 
</cfquery>

  <cfquery name="Customers">
SELECT CustomerID
FROM Customers
ORDER BY CustomerID ASC 
  </cfquery>
  

<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].Name = #form.itemName#>
<cfset session.myInvoice[position].itemDescription = #form.Description#>
<cfset session.myInvoice[position].itemQuantity = #form.Quantity#>
<cfset session.myInvoice[position].itemPrice = #form.Price#>
<cfset session.myInvoice[position].itemAmount = #form.Amount#>
<cfset session.CustomerID = #form.CustomerID#>
<cfset session.SalesID = #form.SalesID#>
<cfset session.BranchID = #form.BranchID#>
<cfset session.mydate = #form.mydate#>
<cfset session.StaffID = #form.StaffID#>
<cfset session.ProductQty = #form.ProductQty#>
<cfset session.totalAmountSum = #form.totalAmount#>
<cfset todayDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset session.todate = #todayDate#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.sAmount#)>
<cfset structdelete(session, 'CustomerID')>
<cfset structdelete(session, 'SalesID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'totalAmountSum')>
<cfset structdelete(session, 'Balance')>
<cfset structdelete(session, 'ProductQty')>
</cfif>

<script> 


function checkKeyCode(evt)
{

var evt = (evt) ? evt : ((window.event) ? window.event : "");
var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
if(event.keyCode==116)
{
event.keyCode=0;
return false
}
}
document.onkeydown=checkKeyCode;

function setItemDescription() {
	if (document.form) {
		var itemDescription = document.form.itemName.options[document.form.itemName.selectedIndex].title;
		var itemSale = document.form.itemName.options[document.form.itemName.selectedIndex].SalePrice;
		var itemSalePrice = parseFloat(itemSale);
		document.form.Description.value=itemDescription;
		document.form.Price.value=itemSalePrice.toFixed(2);
	} 
}
function checkValue() {
	if (document.form) {
		var itemQuantity = document.form.Quantity.value;
		var itemPrice = document.form.Price.value;
		if (itemQuantity>'' && itemPrice>'') { extAmount1 = itemQuantity*itemPrice; } else { extAmount1=''; }
		var extAmount = parseFloat(extAmount1);
		document.form.Amount.value = extAmount.toFixed(2);
	} 
}
function checkBalance(){
	if (document.form){
		var totalAmount = document.form.totalAmount.value;
		var amountPaid = document.form.AmountPaid.value;
		if (totalAmount>'' && amountPaid>'') { extBalance = totalAmount-amountPaid;} else { extBalance='';}
		document.form.Balance.value = extBalance.toFixed(2);
	}
}
//
//var width = 1028;
//var height = 800;
//window.moveTo((screen.availWidth/2)-(width/2),(screen.availHeight/2)-(height/2)) 
//window.resizeTo(width,height);
//
//window.onresize = function() {window.resizeTo(width,height); }
</script>

<br>

<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div>
  <table width="750" border="0">
    <tr>
      <td width="80"><div align="left">Product:</div></td>
      <td width="471"><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset CustomerID = "#form.CustomerID#">
          <cfinput type="text" name="CustomerID" id="CustomerID" size="10" required="yes" class="bold_10pt_black" value="#CustomerID#" tooltip="Invoice Number" readonly="yes">
          <cfelse>
          <cfselect name="CustomerID" class="bold_10pt_black" id="CustomerID" tooltip="Customer's Name" message="Select a Customer"  tabindex="1" autofocus bind="cfc:#request.cfc#cfc.bind.AssembledProduct()" display="ProductID" value="ProductID" bindonload="yes">
            </cfselect>
        </cfif>
      </div></td>
      <td><div align="left">Date:</div></td>
      <td><div align="left">
      <cfif isdefined('form.AddInvoice')>
       <cfset invDate = "#form.mydate#">
       <cfinput type="text" name="mydate" size="8" class="bold_10pt_black" required="yes" value="#invDate#" readonly="yes">
       <cfelse>
        <cfinput type="datefield" name="mydate" class="bold_10pt_Date" required="yes" message="Enter valid date"  mask="dd/mm/yyyy" tabindex="2" placeholder="#dateFormat(now(),"dd/mm/yyyy")#">
        </cfif>
      </div>
             </td>
    </tr>
    <tr>
      <td><div align="left">Quantity
        :</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset ProductQty = "#form.ProductQty#">
          <cfinput type="text" name="ProductQty" size="6" required="yes" class="bold_10pt_black" value="#ProductQty#" tooltip="Quantity" readonly="yes">
          <cfelse>
          <cfinput name="ProductQty" type="text" id="ProductQty" class="bold_10pt_black" required="yes" message="Enter Quantity" tooltip="Quantity" tabindex="3" autocomplete="off" validate="integer" value="1" style="text-align:right">
          </cfif>
        </div></td>
      <td width="61"><div align="left">Branch:</div></td>
      <td width="120"><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset BranchID = "#form.BranchID#">
          <cfinput type="text" name="BranchID" id="BranchID" size="10" required="yes" class="bold_10pt_black" value="#BranchID#" readonly="yes">
          <cfelse>
          <cfselect name="BranchID" class="bold_10pt_black" id="BranchID" tooltip="Location of Sales" required="yes" message="Select Branch" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes" tabindex="5"> </cfselect>
          </cfif>
        </div></td>
    </tr>
    <tr>
      <td><div align="left">Ref. No.
        :</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset SalesID = "#form.SalesID#">
          <cfinput type="text" name="SalesID" size="6" required="yes" class="bold_10pt_black" value="#SalesID#" tooltip="Invoice Number" readonly="yes">
          <cfelse>
          <cfinput name="SalesID" type="text" id="SalesID2" class="bold_10pt_black" required="yes" message="Enter an Ref. number" tooltip="Invoice Number" tabindex="3" autocomplete="off">
        </cfif>
      </div></td>
      <td><div align="left">Authorised:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset StaffID = "#form.StaffID#">
          <cfinput type="text" name="StaffID" id="StaffID2" size="10" required="yes" class="bold_10pt_black" value="#StaffID#" readonly="yes">
          <cfelse>
          <cfselect name="StaffID" class="bold_10pt_black" id="StaffID2" tooltip="Staff that signed the invoice" required="yes" message="Select Authorised" bind="cfc:#request.cfc#cfc.bind.getStaff({BranchID})" display="StaffID" value="StaffID" bindonload="yes" tabindex="6"> </cfselect>
        </cfif>
      </div></td>
    </tr>
      
    <tr>
      <td colspan="2">&nbsp;</td><td></td>
      <td><label>
        
        </label></td>
    </tr>
  </table></div>
  <div align="center">
  <table width="600" bgcolor="##E6F2FF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td align="center"> <strong>Item Name</strong></td>
<td> <strong>Description</strong></td>
<td align="center"> <strong>Qty</strong></td>
<td align="center"> <strong>Unit Cost</strong></td>
<td align="center"> <strong>Amount</strong></td>
<td align="center">&nbsp;</td>
</tr>
</thead>
<tbody>

<tr>

<td> <cfselect name="itemName" id="itemName" style="width:120" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.AssemblyProduct({BranchID},{CustomerID})" display="ProductID" value="ProductID" tabindex="8" bindonload="yes" class="stnd_10pt_style">
</cfselect>
      </td>
            <td><cfinput name="Description" id="Description" type="text"  bind="cfc:#request.cfc#cfc.bind.getDescription({itemName})" class="stnd_10pt_style" readonly="true" size="30" bindonload="yes"></td>

<td> <cfinput type="text" name="Quantity" validate="integer" tabindex="9" required="yes" message="Enter quantity sold" value="1" onKeyUp="checkValue();" size="8" style="text-align:right" autosuggest="no"> </td>
<td> <cfinput type="text" name="Price" validate="float" tabindex="10" class="bold_10pt_black" required="yes" message="Enter item price" bind="cfc:#request.cfc#cfc.bind.CostPrice({itemName})" onKeyUp="checkValue();" size="14" style="text-align:right" autosuggest="no"> </td>
<td align="center"> <cfinput type="text" name="Amount" validate="float" class="bold_10pt_black"  readonly="true" size="14" style="text-align:right"></td>
<td align="center" valign="bottom"> <div align="right"> <cfinput type="submit" name="AddInvoice" value="Add" tabindex="11" class="bold_10pt_Button"></div></td>

</tr>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td > #session.myInvoice[variables.counter].Name# </td>
<td > #session.myInvoice[variables.counter].itemDescription# </td>
<td > <div align="right">#session.myInvoice[variables.counter].itemQuantity# </div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemPrice,',99999999999999.99')#</div></td>
<td> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].itemAmount,',99999999999999.99')#&nbsp; </div></td>
</tr>
</cfloop> 
<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.sAmount,#form.Amount#)>
<cfset position = arraylen(session.sAmount)>
<cfset session.sAmount[position] = #form.Amount#>
</cfif>
<cfset Amount = #arraySum(session.sAmount)#>
<cfset session.Amount = #Amount#>

<tr>
  <td colspan="4" align="right"><div align="right"><strong>Product Cost:&nbsp;</strong></div></td>
  <td align="right"><div align="left"><strong>
    <cfinput type="text" name="totalAmount1" id="totalAmount1" class="bold_10pt_black"  validate="float" value="#LSNumberFormat(Amount,',99999999999.99')#" size="13" readonly="true" style="text-align:right">
    <cfinput type="hidden" name="totalAmount" id="totalAmount" class="stnd_10pt_style"  validate="float" value="#Amount#" size="13" readonly="true" style="text-align:right">
  </strong></div></td>
</tr>
<tr>
  
  
</tr>
<tr bgcolor="##4AA5FF">
<td colspan="4" align="right"><div align="right"></div></td>
<td align="right"><div align="left"></div></td>

<td align="center"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##FF0000"><strong>Reset</strong></font></a><font color="##FFFFFF"><strong>|</strong></font><a href="#cgi.SCRIPT_NAME#?sales=yes"><font color="##FFFFFF"><strong>Post</strong></font></a></td>
</tr>
</tbody>

</table>
</div>


<cfif url.reset is "1">
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.sAmount#)>
<cfset structdelete(session, 'CustomerID')>
<cfset structdelete(session, 'SalesID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'AccountID')>
<cfset structdelete(session, 'totalAmountSum')>
<cfset structdelete(session, 'AmountPaid')>
<cfset structdelete(session, 'Balance')>
</cfif>

</cfform></cfoutput>

</cfif>
</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>