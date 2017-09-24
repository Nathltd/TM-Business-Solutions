
<body>
<cfquery name="getBranch" datasource="#request.dsn#">
select BranchID
from Branches
</cfquery>

<cfparam name="session.OPdate" type="date" default="#DateFormat(now())#">
<cfparam name="session.BranchID" default="">
<cfif isdefined("form.search") is true>
<!---<cfset session.OPdate = "#form.OPdate#">--->
<cfset session.BranchID = "#form.BranchID#">
</cfif>


<cfif IsDefined("form.Update") is True>
<!---<cfgridupdate grid = "OBgrid" dataSource = "#request.dsn#"
tableName = "OpeningBalance">--->
<cfloop index = "counter" from = "1" to = #arraylen(Form.OBgrid.rowstatus.action)#>
<cfif Form.OBgrid.rowstatus.action[counter] is "I">
<cfquery name="InsertOB">
INSERT into OpeningBalance (OpNo,ProductID,Qty,Damages,BranchID,OpeningDate,LastUpdated,Creator) 
                VALUES ('#session.OpNo#','#Form.OBgrid.ProductID[counter]#','#Form.OBgrid.Qty[counter]#','#Form.OBgrid.Damages[counter]#','#session.BranchID#',#dateformat(session.OpeningDate,"dd/mm/yyyy")#,'#dateformat(now(),"dd/mm/yyyy")#','#GetAuthUser()#')
</cfquery>
<cfelseif  Form.OBgrid.rowstatus.action[counter]is "U">
<cfquery name="UpdateOB">
UPDATE OpeningBalance
SET
ProductID = '#trim(Form.OBgrid.ProductID[counter])#',
Qty = '#trim(Form.OBgrid.Qty[counter])#',
Damages = '#trim(Form.OBgrid.Damages[counter])#',
LastUpdated = '#dateformat(now(),"dd/mm/yyyy")#',
Creator = '#GetAuthUser()#'
WHERE ID = #trim(Form.OBgrid.ID[counter])#
</cfquery>
<cfelseif Form.OBgrid.rowstatus.action[counter] is "D">
<cfquery name="DeleteOB">
DELETE from OpeningBalance
WHERE ID = #trim(Form.OBgrid.Original.ID[counter])#
</cfquery>
</cfif>
</cfloop>       
        
<cfoutput>Openning Balance for <strong>#session.BranchID#</strong> on <strong>#session.OPdate# </strong> have been Updated successfully. <br />
Click here to Edit another <a href="../OpeningBalance/updateOpeningBalance.cfm">  Opening Balance </a></cfoutput>
<cfelse>


<cfquery name="OPdetails" datasource="#request.dsn#">
SELECT ID,OpNo,BranchID,OpeningDate,ProductID,Qty, Damages, Creator
FROM OpeningBalance
WHERE BranchID = <cfqueryparam value="#Trim(form.BranchID)#" cfsqltype="cf_sql_clob">

<cfif #GetUserRoles()# is  'Administrator'>
<cfelse>  AND Creator = <cfqueryparam value="#GetAuthUser()#" cfsqltype="cf_sql_clob">
</cfquery>
<cfquery name="Products" datasource="#request.dsn#">
SELECT ProductID
FROM Inventory
ORDER BY ProductID ASC
</cfquery>
<cfif #OPdetails.recordcount# is 0>
<cfoutput><strong> No Record found</strong> </cfoutput><br />
<br />
Click <a href="updateOpeningBalance.cfm">here</a> for another search
<cfelse>

<cfoutput><strong>#OPdetails.recordcount# Records Available for #Trim(form.BranchID)#</strong> </cfoutput><a href="../OpeningBalance/PrntUpdateOBDisplay.cfm"> Print </a>
<br />
<br />
<cfset session.OpNo = "#OPdetails.OpNo#">
<cfset session.OpeningDate = "#OPdetails.OpeningDate#">
<cfset session.BranchID = "#OPdetails.BranchID#">

<cfform action="#cgi.Script_Name#">
<table>
<tr>
<td>
<cfgrid name="OBgrid" width="380"query="OPdetails" insert="yes" insertbutton="Add"  delete="yes" deletebutton="Remove" gridlines="no" format="applet" fontsize="12"colheaderbold="Yes" colheaders="yes"
font = "Tahoma" selectcolor="##949494" selectmode = "Edit" >

<cfgridcolumn name = "ID" display="no" header = "ID" headeralign="center">
<cfgridcolumn name = "ProductID" header = "Products" width="160" headeralign="center" values="#ValueList(Products.ProductID)#">
<cfgridcolumn name = "Qty" header = "Quantity" width="80" headeralign="center"  dataalign="right">
<cfgridcolumn name = "Damages" header = "Damages" width="80" headeralign="center"  dataalign="right">
</cfgrid>
</td>
</tr>
<tr>
<td align="right">
<cfinput type="submit" name="Update" value="Update">
</td>
</tr>
</table>
</cfform>
</cfif>
</cfif>


</body>
</html>