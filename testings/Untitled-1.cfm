<cfquery name="products" maxrows="50">
select productid, description from vwInventory
order by productid
</cfquery>
<table border="1" width="70%">
<tr>
<td width="5%">#</td><td width="60%">Product</td><td width="10%" align="right">IN</td><td width="10%" align="right">OUT</td><td width="10%" align="right">Balance</td>
</tr>

<cfoutput query="products">
<tr>
<cfstoredproc procedure = "productTransact" >
<cfprocparam cfsqltype="cf_sql_varchar" type="in" value="#productid#">
<cfprocparam cfsqltype="cf_sql_varchar" type="in" value="B 055 Niger 3 Plaza">
<cfprocparam cfsqltype="cf_sql_date" type="in" value="02-01-2017">
<cfprocparam cfsqltype="cf_sql_integer" type="out" variable="QtyIN">
<cfprocparam cfsqltype="cf_sql_integer" type="out" variable="QtyOUT">
</cfstoredproc>
<td>#currentrow#<td>#productid#</td><td align="right">#QtyIN#</td><td align="right">#QtyOUT#</td><td align="right">#val(QtyOUT-QtyIN)#</td>
</tr> 
</cfoutput>