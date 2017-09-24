<cfquery name="data">
SELECT VendorID FROM Vendors
Where VendorType = 'Supplier'
ORDER BY VendorID
</cfquery>


<cfdump var="#data#">

<cfform>
<cfselect name="VendorID" id="VendorID" required="yes" style="text-align:left; width:100%" message="Select A Warehouse" bind="cfc:#request.cfc#cfc.bind.Suppliers()" display="VendorID" value="VendorID" bindonload="yes" tabindex="1" autofocus title="Supplier's Name"> </cfselect>
	</cfform>