<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
<cfinclude template="../shared/header.cfm">
</head>


<body>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div class="mainBody"><br />
<br />


<table class="font2">
<cfoutput> 
<!---<tr>
<td><div align="right">Authorised by:</div></td><td><strong> #session.RepCode#</strong></td>
<td></td>
<td><div align="right">Transfer No:</div></td><td><strong> #session.TransferNo#</strong></td>
<td width="20"> </td>
<td colspan="1"><div align="right">Transfer Date:</div></td><td><strong> #session.mydate#</strong></td>
</tr>
<tr>
<td><div align="right"></div></td><td><div align="left"><strong> </strong></div></td>
<td></td>
<td><div align="right">Branch:</div></td><td><div align="left"><strong> #session.DestineBr#</strong></div></td>
<td></td>
<td>Destination Branch:</td><td><strong> #session.DestineBr#</strong></td>


</tr>--->

<tr align="center">
<td height="10"> <div align="right"></div></td>

</tr>
<tr align="center">
<td colspan="3"> <div ><strong>Item Name</strong></div></td>
<td colspan="3"> <strong>Description</strong></td>
<td colspan="3"> <strong>Quantity</strong></td>
<td colspan="3"> <strong>Damages</strong></td>
</tr>


<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr bgcolor="#rowColor#" onmouseover="this.bgColor='FFCCCC';" onmouseout="this.bgColor='#rowColor#';">
<td align="center" colspan="3"> <div>#session.myInvoice[variables.counter].Name# </div></td>
<td align="center" colspan="3"> #session.myInvoice[variables.counter].itemDescription# </td>
<td align="center" colspan="3"> #session.myInvoice[variables.counter].itemQuantity# </td>
<td align="center" colspan="3"> #session.myInvoice[variables.counter].Damages# </td>

</tr>
</cfloop>
</cfoutput>
</table>
<cftransaction>
<cfloop from="1" to="#arraylen(session.myInvoice)#" index="counter">
<cfquery datasource="#request.dsn#">

INSERT INTO OpeningBalance
(ProductID, Qty, Damages, BranchID,OpeningDate,LastUpdated,Creator)
VALUES ('#session.myInvoice[variables.counter].Name#',
'#session.myInvoice[variables.counter].itemQuantity#',
'#session.myInvoice[variables.counter].Damages#','#session.DestineBr#', '#session.mydate#','#dateformat(now(),"dd/mm/yyyy")#','#GetAuthUser()#')
</cfquery>
</cfloop>

</cftransaction>
<br />
<br />

<cfoutput>Openning Balance for <strong>#session.DestineBr#</strong> on <strong>#session.mydate# </strong> have been posted successfully. Click here to create a <a href="../OpeningBalance/newOpeningBalance.cfm"> New Opening Balance </a></cfoutput>
<cfset Temp = arrayclear(#session.myInvoice#)>
<cfset structdelete(session, 'CustomerCode')>
<cfset structdelete(session, 'Account')>
<cfset structdelete(session, 'mydate')>
<cfset structdelete(session, 'DestineBr')>
<cfset structdelete(session, 'RepCode')>
<cfset structdelete(session, 'select')>
<cfset structdelete(session, 'Account')>

</div>
</div>
</body>
</html>


