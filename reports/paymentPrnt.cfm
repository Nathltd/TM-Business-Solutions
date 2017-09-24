<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<style type="text/css">
#Content #RightColumn #custSign {
	float: left;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Invoice Reprint</h4>
<div id="RightColumn">

<cfquery name="Sales">
SELECT paymentId,paymentDate,customerId,type,amount,accountID,payDetails,creator
FROM Payments
WHERE paymentId = <cfqueryparam value="#Trim(url.cfgridkey)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="company">
select logo
from company
</cfquery>


<cfdocument format="flashpaper" unit="in" margintop=".5" marginleft=".5" marginbottom="1">
<div align="left">
<cfoutput>
<img src="../invoices/images/#company.logo#" height="50">
	</cfoutput>
<br>
<cfoutput>
<table width="862">
<tr>
<td colspan="3">
<font size="+4" face="Segoe UI">#request.Company#</font>
<br>
<font size="4"><strong>#request.CompanyAddress#</strong></font>
</td>
<td colspan="2" align="right">
  <font size="+2" face="Segoe UI" color="##666666"><strong>Payment Receipt</strong></font>
</td>
</tr>
<tr>
<td colspan="3">
</td>

<td width="102"><div align="left"><font size="4" face="Segoe UI">Date:</font>  <font size="4" face="Segoe UI"><br>
  Ref ##:</font></div></td>
<td width="161"><div align="left"><font size="4" face="Segoe UI"><strong> #Dateformat(Sales.paymentDate,"dd/mm/yyyy")#</strong></font></div>
<div align="left"><font size="4" face="Segoe UI"><strong>  #Sales.paymentID#</strong></font></div></td>
</tr>
<tr>
  <td colspan="3"></td>
  <td><div align="left"><font size="4" face="Segoe UI">Issued at:</font></div></td>
  <td><div align="left"><font size="4" face="Segoe UI"><strong>#Sales.accountID#</strong></font></div></td>
</tr>
<tr>
<td colspan="3">
<div align="left"><font size="4" face="Segoe UI">From:</font>
<br>
<font size="5" face="Segoe UI"><strong>#Sales.CustomerID#</strong></font></div>
</td>
<td colspan="2">
  <div align="right"></div>
  <div align="right"></div></td>
</tr>
<tr>
<td width="129" bgcolor="EEEEEE">
<div align="left"><font size="4" >Amount Paid:&nbsp;</font></div>
</td>
<td width="207" bgcolor="EEEEEE"><div align="right"><font size="4" face="Segoe UI"><strong>#LSNumberFormat(sales.Amount,',9999999999.99')#</strong></font>&nbsp;</div></td>
<td width="239" >&nbsp;</td>
<td colspan="2">
  <div align="right"></div>
  <div align="right"></div></td>
</tr>
</table>
</cfoutput>
<br>
<br>

<table  width="862">
<cfoutput> 
<tr>
<td></td>
</tr>
</cfoutput>
</table>
<div id="InvoiceRow">
<table width="862">

<tr align="center">
<td colspan="4"><div align="left"> <strong>Purpose:</strong></div></td>
</tr>

<cfoutput query="Sales">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td colspan="4" align="left"><font size="+3">#Sales.payDetails# </font> </td>
</tr>
</cfoutput>
<tr>
  <td width="145" ></td>
</tr>

<tr>
  <td ></td>
</tr>
<cfoutput>
<tr >
  <td align="center" colspan="4"><div align="right"></div></td>
  </tr>
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>
<tr>
  <td align="center" colspan="4"><div align="right"></div></td>
  </tr>
</cfoutput>
</table>
</div>
<br>
<br/>
</div>

<br/>
<div id="Notice" align="center">

                      </div><cfoutput>
<cfdocumentitem type="footer">
<div>
<table align="left">
<tr>
<td>
<div align="right"><font size="3" face="Segoe UI">Customer's Sign:</font></div>
</td>
<td>
<div align="left"><font size="4" face="Segoe UI"><strong>______________</strong></font>
</div>
</td>
</tr>
</table>

<table align="right">
<tr>
<td>
<div align="right"><font size="3" face="Segoe UI">Signed By:</font></div>
</td>
<td>
<cfquery name="userName">
select firstname from users
where userid = '#Sales.creator#'
</cfquery>
<div align="left"><font size="4" face="Segoe UI"><strong> #userName.firstname#</strong></font>
</div>
</td>
</tr>
</table>
</div><br/><br/>
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>
</div>
</div>
</div>
</body>