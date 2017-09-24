<head>
<link href="../css/styles.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#request.title#</cfoutput></title>
</head>

<body>

<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Debit Note Reprint</h4>
<div id="RightColumn">

<cfquery name="DebitNote">
SELECT BranchID,DebitNoteID,ApplyAs,DebitNoteDate,VendorID,StaffID
FROM DebitNote
WHERE DebitNoteID = <cfqueryparam value="#Trim(url.CFGRIDKEY)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="DebitNoteDtls">
SELECT ID,DebitNoteID,ProductID,Qty,Description, UnitPrice, Amt
FROM vwDebitNoteDetails
WHERE DebitNoteID = <cfqueryparam value="#Trim(url.CFGRIDKEY)#" cfsqltype="cf_sql_clob">
</cfquery>

<cfquery name="Amounts" dbtype="query">
Select SUM(Amt) AS TotalAmount
FROM DebitNoteDtls
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
<td width="644">
<font size="+4" face="Segoe UI">#request.Company#</font>
<br>
<font size="-2">#request.CompanyAddress#</font>
</td>
<td colspan="2" align="right">
<font size="+3" face="Segoe UI" color="##666666"><strong>Debit Note</strong></font>
</td>
</tr>
<tr>
<td>
</td>

<td width="95"><div align="left"><font size="-1" face="Segoe UI">Date:</font>  <font size="-1" face="Segoe UI"><br>
  Invoice ##:</font></div></td>
<td width="107"><div align="left"><font size="-1" face="Segoe UI"><strong> #Dateformat(DebitNote.DebitNoteDate,"dd/mm/yyyy")#</strong></font></div>
<div align="left"><font size="-1" face="Segoe UI"><strong>  #DebitNote.DebitNoteID#</strong></font></div></td>
</tr>
<tr>
  <td></td>
  <td><div align="left"><font size="-1" face="Segoe UI">Issued at:</font></div></td>
  <td><div align="left"><font size="-1" face="Segoe UI"><strong>#DebitNote.BranchID#</strong></font></div></td>
</tr>
<tr>
<td>
<div align="left">To:
<br>
#DebitNote.VendorID#</div>
</td>
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
<td width="150"><div align="left"> <strong>Item</strong></div></td>
<td width="452"><strong>Description</strong></td>
<td width="50"> <strong>Qty</strong></td>
<td width="70"> <strong>U/Price</strong></td>
<td width="140"> <div align="right"><strong>Amount</strong></div></td>
</tr>

<cfoutput query="DebitNoteDtls">
<cfif IsDefined("rowColor")Is False or rowColor is "DDDDDD"><cfset rowColor="EEEEEE"><cfelse><cfset rowColor="DDDDDD"></cfif>

<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td align="left">#ProductID#</td>
<td align="left"> #Description# </td>
<td align="right"> #LSNumberFormat(Qty,',999')# </td>
<td align="right"> #LSNumberFormat(UnitPrice,',9999999999.99')#</td>
<td align="right"> <div align="right">#LSNumberFormat(Amt,',9999999999.99')#</div></td>
</tr>
</cfoutput>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>
<tr>
  <td ></td>
</tr>
<cfoutput>
<tr >
  <td align="center" colspan="4"><div align="right">TOTAL:</div></td>
  <td align="right"><div align="right"><strong>#LSNumberFormat(Amounts.TotalAmount,',9999999999.99')#</strong></div></td>
</tr>
</cfoutput>
</table>
</div>
<br>
</div>
<cfoutput>
<cfdocumentitem type="footer">
<div align="right">
<table>
<tr>
<td>
<div align="right"><font size="-1" face="Segoe UI">Signed By:</font></div>
</td>
<td>
<div align="left"><font size="-1" face="Segoe UI"><strong> #DebitNote.StaffID#</strong></font>
</div>
</td>
</tr>
</table>
</div><br>
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>
</div>
</div>
</div>
</body>