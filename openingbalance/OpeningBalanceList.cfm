<!doctype html>
<html>
<head>
<title><cfoutput>Opening Balance List :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>


<body>
<cfquery name="getBranch">
select BranchID
from Branches
</cfquery>


<div align="center">
<cfinclude template="../shared/allMenu.cfm">
<div id="Content">
<h4>Opening Balance Listing</h4>

<div id="RightColumn">
<cfparam name="url.print" default="">
<cfif url.print is "yes">
<cfdocument format="flashpaper" unit="in" margintop=".1">
<div align="center">
<img src="../TMlogoSmall.jpg" width="50" height="37">
<p>
<cfoutput>
<font size="+2" face="Segoe UI">#request.Company# Accounts</font>
<table width="577">
  <tr>
    <td colspan="2" valign="top"><font size="2" face="Segoe UI">Opening Balance Listing For <br>
<strong>#Trim(session.BranchID)#</strong></font></td>
    <td></td>
    <td valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
  </tr>
  <tr>
    <td width="32" valign="top"><div align="left"><font face="Segoe UI" size="-2"></font></div></td>
    <td width="172" valign="top"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
    <td width="181"></td><td width="41" valign="baseline"><div align="left"><font face="Segoe UI" size="-2"></font></div></td><td width="127" valign="baseline"><div align="left"><strong><font face="Segoe UI" size="-2"></font></strong></div></td>
</tr>
</table>
</cfoutput>
</p>
<cfquery name="OPdetails">
SELECT ID,BranchID,ProductID,Qty,costprice
FROM OpeningBalance
WHERE BranchID = <cfqueryparam value="#Trim(session.BranchID)#" cfsqltype="cf_sql_clob">
ORDER BY ProductID ASC
</cfquery>
<cfif #OPdetails.recordcount# is 0>
<p>
<cfoutput><strong> No Record found</strong> </cfoutput><br />
<br />
<a href="updateOpeningBalance.cfm">Click here for another search</a>
</p>
<cfelse>

<cfoutput><strong>#OPdetails.recordcount# Records Available.</strong> </cfoutput>
<br />
<br />

<table width="100%" cellpadding="0" cellspacing="0">
<tr>
<td width="150"><strong>Product</strong></td><td width="100"><div align="right"><strong>Quantity</strong></div></td><td width="100"><div align="right"><strong>Cost Price</strong></div></td>
</tr>
<cfoutput query="OPdetails">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td width="400">#ProductID#</td><td><div align="right">#lsnumberformat(Qty)#</div></td><td><div align="right">#lsnumberformat(costprice,".00")#</div></td>
</tr>
</cfoutput>
</table>
</cfif>
</div>
<cfoutput>
<cfdocumentitem type="footer">
Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
</cfdocumentitem>
</cfoutput>
</cfdocument>
<cfelse>

<cfif isdefined ("form.search")>
<cfparam name="session.BranchID" default="">
<cfset session.BranchID = "#form.BranchID#">


<cfquery name="OPdetails">
SELECT ID,BranchID,ProductID,Qty,costprice
FROM OpeningBalance
WHERE BranchID = <cfqueryparam value="#Trim(form.BranchID)#" cfsqltype="cf_sql_clob">
ORDER BY ProductID ASC
</cfquery>
<cfif #OPdetails.recordcount# is 0>
<p>
<cfoutput><strong> No Record found</strong> </cfoutput><br />
<br />
<a href="updateOpeningBalance.cfm">Click here for another search</a>
</p>
<cfelse>

<cfoutput><strong>#OPdetails.recordcount# Records Available for #Trim(session.BranchID)#.</strong> </cfoutput><a href="?print=1"> Print </a>
<br />
<br />

<table width="80%" cellpadding="0" cellspacing="0">
<tr>
<td width="100"><strong>Product</strong></td><td width="120"><div align="right"><strong>Quantity</strong></div></td><td width="150"><div align="right"><strong>Cost Price</strong></div></td>
</tr>
<cfoutput query="OPdetails">
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
<td width="400">#ProductID#</td><td><div align="right">#lsnumberformat(Qty,",")#</div></td><td><div align="right">#lsnumberformat(costprice,",0.00")#</div></td>
</tr>
</cfoutput>
</table>
</cfif>

<cfelse>
<p> Select A Branch </p>
<cfform action="#cgi.Script_Name#" enctype="multipart/form-data">
<table width="40%" >
 <tr>
<td width="40%" ><div align="right">Branch Name:</div></td>
<td width="40%" colspan="2" ><div align="left">
  <cfselect name="BranchID" required="yes" message="Choose a Branch" style="width:100">
        <cfoutput query="getBranch">
      <option value="#Trim(BranchID)#">#Trim(BranchID)#</option>
      </cfoutput>
    </cfselect>
</div></td>
    </tr>
    <tr>
    <td align="right"></td>
    <td width="20%" align="right"><div>
      <cfinput type="submit" name="Search" value="Search">
    </div></td>
    <td width="1" align="right">&nbsp;</td>
    </tr>
  </table>
    </div>

  </cfform>
</cfif>
</cfif>
</div>
</div>
</div>
</body>
</html>