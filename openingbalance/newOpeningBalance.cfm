<!doctype html>
<html>
<head>
<title><cfoutput>Opening Balance ::: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>


<body>

<div align="center">

<cfinclude template="../shared/allMenu.cfm">


<div id="Content">
<h4>Inventory Opening Balance</h4>
<div id="RightColumn">

<cfquery name="Obalance" >
SELECT BranchID FROM vwOBalanceBranchs
ORDER BY BranchID
</cfquery>
<cfquery name="balanceAvailable" >
SELECT * FROM OpeningBalance
ORDER BY BranchID
</cfquery>
<cfif #Obalance.recordcount# eq 0>
<p>
<cfoutput><strong> Opening Balance have been created for all branches</strong> </cfoutput>
<br />
<br>
<a href="updateOpeningBalance.cfm"> Click here to modify Opening Balance </a>
</p>
<cfelse>
<cfparam name="url.Sales" default="">
<cfif url.Sales is "yes">

<cftransaction>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery>
INSERT INTO OpeningBalance(OpNo,ProductID, CostPrice, Qty, BranchID,OpeningDate,LastUpdated,Creator)
VALUES ('#session.OpNo#','#session.myInvoice[variables.counter].Name#', '#session.myInvoice[variables.counter].CostPrice#',
'#session.myInvoice[variables.counter].itemQuantity#','#session.BranchID#',
<cfqueryparam value="#lsDateFormat(CreateODBCDate(request.StartYear), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,
<cfqueryparam value="#lsDateFormat(CreateODBCDate(Now()), "dd/mm/yyyy")#" cfsqltype="cf_sql_date">,'#GetAuthUser()#')
</cfquery>
</cfloop>
</cftransaction>
<br>
<cfoutput> O/P No. <strong>#session.OpNo#</strong> have been posted successfully. Create a<a href="#cgi.SCRIPT_NAME#"> New Opening Balance </a></cfoutput>
<br>
<br>
<table>
<cfoutput> 
<tr>
<td><div align="right">
  <div align="right">Ref No:</div>
</div></td>
<td><strong> #session.OpNo#</strong></td>
<td></td>
<td>&nbsp;</td>
<td>&nbsp;</td>

<td><div align="right">Date:</div></td><td><strong> #session.myDate#</strong></td>
</tr>
<tr>
<td><div align="right">Branch:</div></td><td><strong> #session.BranchID#</strong></td>
<td><div align="right"></div></td>
<td></td>
<td></td>
<td><div align="right">Signed By:</div></td><td><strong> #session.StaffID#</strong></td>

<td></td><td></td>
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
<td colspan="5"> <strong>Unit Cost</strong></td>
<td> <strong>Quantity</strong></td>
<td><div align="right"> <strong>Amount</strong></div></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="center"> #session.myInvoice[variables.counter].Name# </td>
<td align="center" colspan="5"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="center" colspan="5"> #session.myInvoice[variables.counter].CostPrice# </td>
<td align="center"> #session.myInvoice[variables.counter].itemQuantity# </td>
<td align="right"><div align="right"> #LSNumberFormat(session.myInvoice[variables.counter].Amount,',99999999999.99')#</div></td>
</tr>
</cfloop>
</cfoutput>
</table>


<br />

<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.tAmount" default="#arraynew(1)#" type="array">
<cfparam name="session.OpNo" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchID" default="">
<cfparam name="session.StaffID" default="">
<cfparam name="session.Damage" default="">
<cfparam name="url.reset" default="">

<cfquery name="ItemList">
SELECT ProductID, Description, SalePrice
FROM Inventory
ORDER BY ProductID 
</cfquery>
<cfquery name="BranchCode">
SELECT BranchID, Description
FROM Branches
ORDER BY BranchID ASC 
</cfquery>
<cfquery name="RepCode">
SELECT StaffID, LastName, FirstName
FROM Staff
ORDER BY StaffID ASC 
</cfquery>


<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].Name = #form.itemName#>
<cfset session.myInvoice[position].itemDescription = #form.Description#>
<cfset session.myInvoice[position].CostPrice = #form.CostPrice#>
<cfset session.myInvoice[position].itemQuantity = #form.Quantity#>
<cfset session.myInvoice[position].Amount = #form.Amount#>
<cfset session.OpNo = #form.OpNo#>
<cfset session.BranchID = #form.BranchID#>
<cfset session.mydate = #form.mydate#>
<cfset session.StaffID = #form.StaffID#>
<cfset todayDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset session.todate = #todayDate#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset arrayclear(#session.tAmount#)>
<cfset structdelete(session, 'OpNo')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'Damage')>
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

function checkValue() {
	if (document.form) {
		var itemQuantity = document.form.Quantity.value;
		var itemPrice = document.form.CostPrice.value;
		if (itemQuantity>'' && itemPrice>'') { extAmount1 = itemQuantity*itemPrice; } else { extAmount1=''; }
		var extAmount = parseFloat(extAmount1);
		document.form.Amount.value = extAmount.toFixed(2);
	} 
}
</script>




<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="90%" border="0">
    <tr>
      <td width="7%"><div align="left">Ref No:</div></td>
      <td width="20%"><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset invNo = "#form.OpNo#">
          <cfinput type="text" name="OpNo" required="yes"  value="#invNo#" tooltip="O/B Number" readonly="yes" >
          <cfelse>
          <cfinput name="OpNo" type="text" id="OpNo" required="yes" message="Enter an O/B number" tooltip="O/B Number" autosuggest="off" tabindex="1" validate="integer"/>
          </cfif>
      </div></td>
      <td width="40%">&nbsp;</td>
      <td width="5%"><div align="left">Date:</div></td>
      <td width="20%" ><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset invDate = "#form.mydate#">
          <cfinput type="text" name="mydate" required="yes" value="#invDate#" readonly="yes">
          <cfelse>
          <cfinput type="datefield" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Invoice Date" required="yes" message="Enter Invoice Date"/>
         
          </cfif>
        </div></td>
    </tr>
      
    <tr>
      <td><div align="left">Authorised:</div></td>
      <td><div align="left">
        
        <cfif isdefined('form.AddInvoice')>
          
          <cfset Staffd = "#form.StaffID#">
          <cfinput type="text" name="StaffID" required="yes" value="#Staffd#" tooltip="Signatory" readonly="yes">   
          <cfelse>
          <cfselect name="StaffID" id="StaffID" tooltip="Staff that signed the invoice" required="yes" message="Select Authorised" bind="cfc:#request.cfc#cfc.bind.getStaffFund({BranchID})" display="FirstName" value="FirstName" bindonload="yes" tabindex="4">
            </cfselect>
          </cfif>
        </div></td>
      <td>&nbsp;</td>
      <td><div align="left">Branch:</div></td>
      <td><div align="left">
        
        <cfif isdefined('form.AddInvoice')>
          <cfset BranchID = "#form.BranchID#">
          <cfinput type="text" name="BranchID" id="BranchID" size="10" required="yes" class="bold_10pt_black" value="#BranchID#" readonly="yes">
          <cfelse>
          <cfselect name="BranchID" id="BranchID" required="yes" class="bold_10pt_black" message="Choose Location" bind="cfc:#request.cfc#cfc.bind.OBranches()" display="BranchID" value="BranchID" bindonload="yes" tabindex="3"> </cfselect>
          
          
          </cfif>
        
        </div></td>
    </tr>
    <tr>
      <td colspan="3">&nbsp;</td><td></td>
      <td><div align="left">Save to post later <cfinput type="checkbox" name="checkbox" id="checkbox" disabled tabindex="5" /></div><label>
        
        </label></td>
    </tr>
  </table></div>
  <div align="center">
  <table width="90%" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td align="center"> <strong>Item Name</strong></td>
<td> <strong>Description</strong></td>
<td align="center"> <strong>Quantity</strong></td>
<td align="center"> <strong>Unit Cost</strong></td>
<td align="center"> <strong>Amount</strong></td>
<td align="center">&nbsp;</td>
</tr>
</thead>
<tbody>

<tr>

<td> <cfselect name="itemName" id="itemName" style="width:120" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.allProducts()" display="ProductID" value="ProductID" tabindex="6" bindonload="yes" class="bold_10pt_item">
</cfselect>
      </td>
            <td><cfinput name="Description" id="Description" type="text"  bind="cfc:#request.cfc#cfc.bind.getDescription({itemName})" class="stnd_10pt_style" readonly="true" size="30" bindonload="yes"></td>

<td> <div align="right">
  <cfinput type="text" name="Quantity" validate="float" tabindex="7"  required="yes" message="Enter quantity sold" value="1" size="6" style="text-align:right" autosuggest="off" onKeyUp="checkValue();"> 
</div></td>

<td> <div align="right">
  <cfinput type="text" name="CostPrice" id="CostPrice"validate="float" tabindex="8" class="bold_10pt_black" required="yes" message="Enter item price" bind="cfc:#request.cfc#cfc.bind.costPrice({itemName})" onKeyUp="checkValue();" size="14" style="text-align:right" autosuggest="no">
</div></td>

<td> <div align="right">
  <cfinput type="text" name="Amount" validate="float" class="bold_10pt_black"  readonly="true" size="14" style="text-align:right"tabindex="9"> 
</div></td>
<td align="center" valign="bottom">  <cfinput type="submit" name="AddInvoice" value="Add" tabindex="10" class="bold_10pt_button"></td>

</tr>



<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left"> #session.myInvoice[variables.counter].Name# </td>
<td align="left"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="right"> <div align="right">#session.myInvoice[variables.counter].itemQuantity# </div></td>
<td align="left"><div align="right"> #session.myInvoice[variables.counter].CostPrice#</div> </td>
<td align="right"> <div align="right">#LSNumberFormat(session.myInvoice[variables.counter].Amount,',99999999999.99')#&nbsp;</div></td>
</tr>
</cfloop> 
<tr>
<!--- To get the Total Sum & other calculations --->
<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.tAmount,#form.Amount#)>
<cfset position = arraylen(session.tAmount)>
<cfset session.tAmount[position] = #form.Amount#>
</cfif>
<cfset Amount = #arraySum(session.tAmount)#>
<cfset session.Amount = #Amount#>
  <td colspan="4" align="right"><div align="right"><strong>Total Value:&nbsp;</strong></div></td>
  <td align="right"><div align="right"><strong>
    <cfinput type="text" name="totalAmount1" id="totalAmount1" class="bold_10pt_black"  validate="float" size="13" readonly="true" style="text-align:right" value="#LSNumberFormat(Amount,',99999999999.99')#">
    <cfinput type="hidden" name="totalAmount" id="totalAmount" class="stnd_10pt_style"  validate="float"  size="13" readonly="true" style="text-align:right" value="#Amount#">
  </strong></div></td>
</tr>
<tr>
  <td colspan="4">&nbsp;</td>
</tr>
<tr bgcolor="##4AA5FF">
  <td colspan="4" align="right"><strong>&nbsp;</strong></td>
  <td align="right"><strong>&nbsp;</strong></td>
  <td align="center"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##FF0000"><strong>Reset</strong></font></a>&nbsp;<a href="#cgi.SCRIPT_NAME#?sales=yes"><font color="##FFFFFF"><strong>Post</strong></font></a></td>
</tr>
</tbody>

</table>
</div>


<cfif url.reset is "1">
<cfset structdelete(session, 'CustomerCode')>
<cfset structdelete(session, 'OpNo')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchCode')>
<cfset structdelete(session, 'StaffID')>
<cfset arrayclear(#session.tAmount#)>
<cfset arrayclear(#session.myInvoice#)>
</cfif>

</cfform>
</cfoutput>
</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html>