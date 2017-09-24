<!doctype html>
<html>
<head>
<title><cfoutput>Product Activities :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>
<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div>



<h4><cfif isdefined ("form.search")><cfoutput>Inventory Valuation for #form.BranchID#  (#form.StartDate# - #form.EndDate#)</cfoutput><cfelse>Inventory Valuation</cfif></h4>
<div id="RightColumn">
<div align="right"> <a href="productAnalysis.cfm">Reset</a>&nbsp;&nbsp;</div>


<cfparam name="startRow" default="1">
<cfparam name="endRow" default="50">
<cfparam name="displayRow" default="50">


<cfquery name="products">
select productid, description from vwInventory
order by productid
</cfquery>

<cfif isdefined('form.search')>
<cfset session.startDate = #createODBCDate(Dateformat(form.StartDate,"dd/mm/yyyy"))#>
<cfset session.EndDate = #createODBCDate(Dateformat(form.EndDate,"dd/mm/yyyy"))#>
<cfset session.branchId = #form.branchId#>
</cfif>




<cfquery name="Transact" timeout="300">
SELECT ProductID, SUM(Qty) as Quantity,TypeID, BranchID FROM vwProductTransactUnion
WHERE ddate >= #CreateODBCDate(session.StartDate)# AND ddate <= #CreateODBCDate(session.EndDate)# AND BranchID = '#session.branchId#'
GROUP BY ProductID, TypeID, BranchID
</cfquery>

<!---<cfif #DateDiff("d", session.StartDate, session.EndDate)# gt 31>
<h2 title="Maximum range - 31 days"> Search exceeds range!</h2>
<cfabort>
</cfif>--->

<cfif #products.recordCount# eq 0>
<h2>No Record Found! </h2>
<cfabort>
</cfif>

<cfset next = #startRow#+50>
<cfset previous = #startRow#-50>
<cfset lastRow = #next#+7>
<cfoutput>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td colspan="2" align="left">Record #startRow# to #endRow# of #products.recordCount#</td>
<td colspan="2" align="right">
  <cfif #previous# GTE 1>
    <a href="#cgi.SCRIPT_NAME#?startRow=#previous#&endRow=#evaluate(next-51)#"><b>Previous #displayRow# Records</b></a>
    <cfelse>
    Previous Records
  </cfif>
  <b>|</b>
  <cfif #next# LTE #products.recordCount#>
    <a href="#cgi.SCRIPT_NAME#?startRow=#next#&endRow=#evaluate(next+49)#"><b>Next
      <cfif (#products.recordCount#-#next#) LT #displayRow#> #evaluate((products.recordCount-next)+1)# 
        <cfelse> #displayRow#
        </cfif> Records</b></a>
    <cfelse>
    Next Records
  </cfif></td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="5%"><strong>
S/N.
</strong></td>
<td><strong>Product</strong></td><td><div align="right"><strong>B/F</strong></div></td><td><div align="right"><strong>Purchase</strong></div></td><td><div align="right"><strong>Sales</strong></div></td><td><div align="right"><strong>Transfer In</strong></div></td><td><div align="right"><strong>Transfer Out</strong></div></td><td><div align="right"><strong>Returned</strong></div></td><td><div align="right"><strong>Retained</strong></div></td><td><div align="right"><strong>Adjusted</strong></div></td><td><div align="right"><strong>Qty on Hand</strong></div></td>
</tr>
<cfloop query="products" startrow="#startRow#" endrow="#endRow#">
<cfquery name="Transact" timeout="300">
SELECT ProductID, SUM(Qty) as Quantity,TypeID FROM vwProductTransactUnion
WHERE ddate >= #CreateODBCDate(session.StartDate)# AND ddate <= #CreateODBCDate(session.EndDate)# AND BranchID = '#session.branchId#' AND ProductID = '#products.productId#'
GROUP BY ProductID, TypeID 
</cfquery>
<cfif IsDefined("rowColor")Is False or rowColor is "FFFFFF"><cfset rowColor="E8E8E8"><cfelse><cfset rowColor="FFFFFF"></cfif>
<tr bgcolor="#rowColor#" onMouseOver="this.bgColor='FFCCCC';" onMouseOut="this.bgColor='#rowColor#';">
	<td>
      #currentRow#.
    </td>
    <td>
    	#productId#
    </td>
    <td>
    	<div align="right">
		<!---Calculation for Brought Forward--->
        <cfquery name="TotalQty"  timeout="300">
			SELECT TypeID, Qty, ddate FROM vwProductTransactUnion
			WHERE ddate < #CreateODBCDate(session.StartDate)# AND ProductID = '#products.ProductID#' AND BranchID = '#session.branchId#'
        </cfquery>
        <cfquery dbtype="query" name="QtyOut" timeout="300">
			SELECT  SUM(Qty) AS Qty1
			FROM TotalQty
			WHERE  TypeID = 'Sales' or TypeID = 'Transfer Out' or TypeID = 'Adj' or TypeID = 'Returned'
		</cfquery>
        <cfquery dbtype="query" name="QtyIN" timeout="300">
			SELECT  SUM(Qty) AS Qty1
			FROM TotalQty
			WHERE TypeID = 'Purchase' or TypeID = 'Transfer IN' or TypeID = 'Opening Balance' or TypeID = 'Retained'
		</cfquery>
        <cfif QtyIN.recordCount eq 0 AND QtyOUT.recordCount gt 0>
			<cfset QtyIN2 = 0>
			<cfset #QtyOUT2# = #Valuelist(QtyOUT.Qty1)#>
			<cfelseif QtyOUT.recordCount eq 0  AND QtyIN.recordCount gt 0>
			<cfset QtyOUT2 = 0>
			<cfset #QtyIN2# = #Valuelist(QtyIN.Qty1)#>
			<cfelseif QtyIN.recordCount eq 0 AND QtyOUT.recordCount eq 0>
			<cfset QtyIN2 = 0>
			<cfset QtyOUT2 = 0>
				<cfelse>
			<cfset #QtyIN2# = #Valuelist(QtyIN.Qty1)#>
			<cfset #QtyOUT2# = #Valuelist(QtyOUT.Qty1)#>
		</cfif>
		<cfset PreviousBal = +#QtyIN2#-(#QtyOUT2#)>
  
		<cfquery name="OBalance">
			SELECT ddate, Qty FROM vwProductTransactUnion
			where typeid = 'Opening Balance' AND ProductID = '#products.ProductID#' AND BranchID = '#session.branchId#'
		</cfquery>
		<cfif #Obalance.ddate# eq "">
		<cfset OBDate = #CreateODBCDate('2010/01/01')#>
		<cfelse>
		<cfset OBDate = #Obalance.ddate#>
		</cfif>
        
		<cfif #DateDiff("d", OBDate, session.StartDate)# lte 0>
		<cfset #previousBal# = #previousBal# + #Obalance.Qty#>
		</cfif>         
		#previousBal#
		</div>
	</td>
	<td>
		<div align="right">
		<cfquery dbtype="query" name="Purchase">
		Select quantity from transact
		where typeid = 'Purchase'
                                        </cfquery>
                                      <cfif #Purchase.quantity# is "">
                                        <cfset purchase = 0>
                                        <cfelse>
                                        <cfset purchase = #Purchase.quantity#>
                                      </cfif>
                                      #purchase#</div></td>
                                     <td><div align="right">
                                       <cfquery dbtype="query" name="sales">
										Select quantity from transact
                                        where typeid = 'Sales'
                                        </cfquery>
                                       <cfif #sales.quantity# is "">
                                         <cfset sales = 0>
                                         <cfelse>
                                         <cfset sales = #sales.quantity#>
                                       </cfif>
                                       #sales#</div></td>
                                     <td><div align="right">
                                       <cfquery dbtype="query" name="TransferIN">
										Select quantity from transact
                                        where typeid = 'Transfer IN'
                                        </cfquery>
                                       <cfif #TransferIN.quantity# is "">
                                         <cfset transferIn = 0>
                                         <cfelse>
                                         <cfset transferIn = #TransferIN.quantity#>
                                       </cfif>
                                       #TransferIN#</div></td>
                                     <td><div align="right">
                                       <cfquery dbtype="query" name="TransferOut">
										Select quantity from transact
                                        where typeid = 'Transfer Out'
                                        </cfquery>
                                       <cfif #TransferOut.quantity# is "">
                                         <cfset transferOut = 0>
                                         <cfelse>
                                         <cfset transferOut = #TransferOut.quantity#>
                                       </cfif>
                                       #TransferOut#</div></td>
                                     <td><div align="right">
                                       <cfquery dbtype="query" name="returned">
										Select quantity from transact
                                        where typeid = 'Returned'
                                        </cfquery>
                                       <cfif #returned.quantity# is "">
                                         <cfset returned = 0>
                                         <cfelse>
                                         <cfset returned = #returned.quantity#>
                                       </cfif>
                                       #returned#</div></td>
                                     <td><div align="right">
                                       <cfquery dbtype="query" name="Retained">
										Select quantity from transact
                                        where typeid = 'Retained'
                                        </cfquery>
                                       <cfif #Retained.quantity# is "">
                                         <cfset retained = 0>
                                         <cfelse>
                                         <cfset retained = #Retained.quantity#>
                                       </cfif>
                                       #retained#</div></td>
                                     <td><div align="right">
                                       <cfquery dbtype="query" name="Adj">
										Select quantity from transact
                                        where typeid = 'Adj'
                                        </cfquery>
                                       <cfif #Adj.quantity# is "">
                                         <cfset adj = 0>
                                         <cfelse>
                                         <cfset adj = #Adj.quantity#>
                                       </cfif>
                                       #adj#</div></td>
                                         <td><div align="right">
                                           <cfset balance = #previousBal#+#purchase#+#transferIn#+#retained#-#Sales#-#TransferOut#-#Adj#-#Returned#>
                                           #balance#</div></td>
                                         </tr>
	</cfloop>
    </table>
    </cfoutput>

</div>
<div id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</div>
</div>
</body>
</html>