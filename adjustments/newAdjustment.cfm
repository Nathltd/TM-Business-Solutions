<!doctype html>
<html>
<head>
<title><cfoutput>Inventory Adjustment :: #request.title#</cfoutput></title>
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
<h4>Inventory Adjustment</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Manager'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Stock Keeper'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant2'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>
<cfparam name="url.Sales" default="">
<cfif url.Sales is "yes">

<cftransaction>
<cfquery>

INSERT INTO AdjInventory
(AdjID,AdjDate,BranchId,StaffID,Comment,LastUpdated,Creator)
VALUES ('#session.AdjID#',<cfqueryparam value="#CreateODBCDate(session.myDate)#" cfsqltype="cf_sql_date">, '#session.BranchID#', '#session.StaffID#', '#session.Comment#',<cfqueryparam value="#CreateODBCDate(session.todate)#" cfsqltype="cf_sql_date">, '#GetAuthUser()#')
</cfquery>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">

<cfquery>

INSERT INTO AdjInvtryDetails
(ProductId, CurQty, NewQty, AdjID)
VALUES ('#session.myInvoice[variables.counter].Name#', '#session.myInvoice[variables.counter].CurQty#',  '#session.myInvoice[variables.counter].NewQty#','#session.AdjID#')
</cfquery>
</cfloop>
</cftransaction>

<table>
<cfoutput> 
<tr>
<td><div align="right">
  <div align="right">Ref No:</div>
</div></td>
<td><strong> #session.AdjID#</strong></td>
<td></td>
<td>&nbsp;</td>
<td>&nbsp;</td>

<td><div align="right">Invoice Date:</div></td><td><strong> #session.myDate#</strong></td>
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
<td> <strong>Cur. Qty</strong></td>
<td> <strong>New Qty</strong></td>
<td> <strong>Diff. Qty</strong></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="center"> #session.myInvoice[variables.counter].Name# </td>
<td align="center" colspan="5"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="center"> <div align="right">#session.myInvoice[variables.counter].CurQty# </div></td>
<td align="right"> <div align="right">#session.myInvoice[variables.counter].NewQty#</div></td>
<td align="right"> <div align="right">#session.myInvoice[variables.counter].DiffQty#</div></td>
</cfloop>
</cfoutput>
</table>


<br />
<br />

<cfoutput> Adj Ref. No. <strong>#session.AdjID#</strong> have been posted successfully. Make a<a href="#cgi.SCRIPT_NAME#"> New Inventory Adjustment </a></cfoutput>

<cfset Temp = arrayclear(#session.myInvoice#)>
<cfset structdelete(session, 'AdjID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'toDate')>
<cfset structdelete(session, 'Comment')>

<cfelse>

<cfparam name="session.myInvoice" default="#arraynew(1)#" type="array">
<cfparam name="session.AdjID" default="">
<cfparam name="session.mydate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchID" default="">
<cfparam name="session.StaffID" default="">
<cfparam name="session.Comment" default="">
<cfparam name="url.reset" default="">


<cfif isdefined("AddInvoice") >
<cfset arrayappend(session.myinvoice,structnew())>
<cfset position = arraylen(session.myinvoice)>
<cfset session.myInvoice[position].Name = #form.itemName#>
<cfset session.myInvoice[position].itemDescription = #form.Description#>
<cfset session.myInvoice[position].CurQty = #form.CurQty#>
<cfset session.myInvoice[position].NewQty = #form.NewQty#>
<cfset session.myInvoice[position].DiffQty = #form.DiffQty#>
<cfset session.AdjID = #form.AdjID#>
<cfset session.BranchID = #form.BranchID#>
<cfset session.mydate = #form.mydate#>
<cfset session.StaffID = #form.StaffID#>
<cfset session.Comment = #form.Comment#>
<cfset todayDate = #dateformat(now(),"dd/mm/yyyy")#>
<cfset session.todate = #todayDate#>

<cfelse>
<cfset arrayclear(#session.myInvoice#)>
<cfset structdelete(session, 'AdjID')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'BranchID')>
<cfset structdelete(session, 'StaffID')>
<cfset structdelete(session, 'todate')>
<cfset structdelete(session, 'Comment')>
</cfif>

<script> 

function checkValue() {
	if (document.form) {
		var CurQty = document.form.CurQty.value;
		var NewQty = document.form.NewQty.value;
		if (CurQty>'' && NewQty>'') { extAmount1 = CurQty-NewQty; } else { extAmount1=''; }
		var extAmount = parseFloat(extAmount1);
		document.form.DiffQty.value = extAmount.toFixed();
	} 
}

</script>




<cfoutput>


<cfform action="#cgi.SCRIPT_NAME#" name="form" format="html" id="form" enctype="application/x-www-form-urlencoded">

<div align="center">
  <table width="90%" border="0">
    <tr>
      <td><div align="left">Ref No:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset invNo = "#form.AdjID#">
          <cfinput type="text" name="AdjID" required="yes" value="#invNo#" style="width:100%" title="Ref No." readonly="yes">
          <cfelse>
          <cfinput name="AdjID" type="text" id="AdjID" required="yes" message="Enter an Ref No." title="Ref No." style="width:100%" />
          </cfif>
      </div></td>
      <td width="803">&nbsp;</td>
      <td width="75"><div align="left">Date:</div></td>
      <td width="281"><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset invDate = "#form.mydate#">
          <cfinput type="text" name="mydate" style="width:100%" required="yes" value="#invDate#" readonly="yes">
          <cfelse>
          <cfinput type="datefield" style="width:100%" mask="dd/mm/yyyy" placeholder="#dateformat(now(),"dd/mm/yyyy")#" name="mydate" id="mydate" tabindex="2" title="Adjustment Date" required="yes" message="Enter valid Date"/>
          
          
          </cfif>
        </div></td>
    </tr>
      
    <tr>
      <td width="119"><div align="left">Authorised:</div></td>
      <td width="300"><div align="left">
        
        <cfif isdefined('form.AddInvoice')>
          
          <cfset Staffd = "#form.StaffID#">
          <cfinput type="text" name="StaffID" style="width:100%" required="yes" value="#Staffd#" tooltip="Signatory" readonly="yes">   
          <cfelse>
          <cfselect name="StaffID" id="StaffID" tooltip="Staff that signed the invoice" required="yes" message="Select Authorised" bind="cfc:#request.cfc#cfc.bind.getStaffFund({BranchID})" display="FirstName" value="FirstName" bindonload="yes" style="width:100%">
            </cfselect>
          </cfif>
        </div></td>
      <td>&nbsp;</td>
      <td><div align="left">Branch:</div></td>
      <td><div align="left">
        
        <cfif isdefined('form.AddInvoice')>
          <cfset BranchID = "#form.BranchID#">
          <cfinput type="text" name="BranchID" id="BranchID" required="yes" style="width:100%" value="#BranchID#" readonly="yes">
          <cfelse>
          <cfselect name="BranchID" id="BranchID" required="yes" style="width:100%" message="Choose Location" bind="cfc:#request.cfc#cfc.bind.AllBranches()" display="BranchID" value="BranchID" bindonload="yes"> </cfselect>
          
          
          </cfif>
        
        </div></td>
    </tr>
    <tr>
      <td><div align="left">Comment:</div></td>
      <td><div align="left">
        <cfif isdefined('form.AddInvoice')>
          <cfset Comment = "#form.Comment#">
          <cfinput type="text" name="Comment" size="6" required="yes" style="width:100%" value="#Comment#" title="O/P Number" readonly="yes">
          <cfelse>
          <cfinput name="Comment" type="text" id="Comment"  size="25" required="yes" message="Leave a Comment" title="Comment"  style="width:100%">
        </cfif>
      </div></td>
      <td></td>
      <td></td>
      <td><label>
        
        </label></td>
    </tr>
  </table></div><br>

  <div align="center">
  <table width="90%" bgcolor="##D5EAFF" border="0" cellpadding="5" cellspacing="0" bordercolor="999999">
<thead>
<tr align="center">
<td align="center" width="25%"> <strong>Item Name</strong></td>
<td width="30%"> <strong>Description</strong></td>
<td width="10%" align="center"><strong>Cur. Qty</strong></td>
<td width="10%" align="center"> <strong>New Qty</strong></td>
<td width="10%" align="center"><strong>Diff.</strong></td>
<td align="center">&nbsp;</td>
</tr>
</thead>
<tbody>

<tr>

<td> <cfselect name="itemName" id="itemName" style="width:100%" required="yes"  message="Select A Product" bind="cfc:#request.cfc#cfc.bind.allProducts()" display="ProductID" value="ProductID" tabindex="1" bindonload="yes">
</cfselect>
      </td>
        <td><cfinput name="Description" id="Description" type="text"  bind="cfc:#request.cfc#cfc.bind.getDescription({itemName})" readonly="true" bindonload="yes" style="width:100%"></td>

<td> <div align="right">
  <cfinput type="text" name="CurQty" tabindex="2" style="text-align:right; width::100%" readonly="yes" bind="cfc:#request.cfc#cfc.bind.getQuantity({itemName},{BranchID})" bindonload="yes"> 
</div></td>
<td> <div align="right">
  <cfinput type="text" name="NewQty" validate="float" tabindex="3" required="yes" message="Enter Quantity Damaged" value="0" style="text-align:right;width:100%" autosuggest="off" onKeyUp="checkValue();"> 
</div></td>
<td><cfinput type="text" name="DiffQty" validate="integer" tabindex="3" required="yes" message="Enter Quantity Damaged" value="0"  style="text-align:right;width:100%" autosuggest="off"></td>
<td align="center" valign="bottom">  <cfinput type="submit" name="AddInvoice" value="Add" tabindex="4"></td>

</tr>



<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left"> #session.myInvoice[variables.counter].Name# </td>
<td align="left"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="right"> <div align="right">#session.myInvoice[variables.counter].CurQty# </div></td>
<td align="right"> <div align="right">#session.myInvoice[variables.counter].NewQty#</div></td>
<td align="right"> <div align="right">#session.myInvoice[variables.counter].DiffQty#</div></td>
<td align="right">&nbsp;</td>
</tr>
</cfloop> 

<tr>
  <td colspan="5">&nbsp;</td>
</tr>
<tr bgcolor="##C6C6FF">
  <td colspan="5" align="right"><strong>&nbsp;</strong></td>
  <td align="center"><a href="#cgi.SCRIPT_NAME#?reset=1"><font color="##000000"><strong>Reset</strong></font></a>&nbsp;<a href="#cgi.SCRIPT_NAME#?sales=yes"><font color="##000000"><strong>Post</strong></font></a></td>
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
<cfset arrayclear(#session.myInvoice#)>
</cfif>

</cfform></cfoutput>
</cfif>
</cfif>
</div>
</div>
</div>
</body>