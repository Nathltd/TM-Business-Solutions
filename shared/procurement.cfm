<div align="center">
<cfmenu name="menu" type="horizontal" childstyle="text-align:left" >
<cfmenuitem name="Home"
href="../index/index.cfm" display="Home"/>
<!--- The Inventory menu item has a pop-up menu. --->
<cfmenuitem name="Inventory" display="Inventory">
<cfmenuitem name="Product" display="Product">
<cfmenuitem name="newProducts" href="../products/newproduct.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductsConsting" href="../Products/ProductsCosting.cfm" display="Costing"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListProduct" href="../Products/Productslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Category" display="Category">
<cfmenuitem name="ListCategory" href="../products/CategoryList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductActivities" href="../Reports/ProductActivity.cfm" display="Activities"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductAnalysis" href="../Reports/ProductAnalysis.cfm" display="Analysis"/>
</cfmenuitem>


<!--- The Customers menu item has a pop-up menu. --->
<cfmenuitem name="Customers" display="Customers">
</cfmenuitem>
<!--- The Vendor menu item has a pop-up menu. --->
<cfmenuitem name="Vendor" display="Vendor">
<cfmenuitem name="MaintainVendors" display="Vendor">
<cfmenuitem name="NewVendor" href="../Vendors/newVendor.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListVendor" href="../Vendors/Vendorslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Purchases" display="Purchases">
<cfmenuitem name="NewPurchases" href="../Purchases/Purchase.cfm" display="New"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentVendor" display="Purchase Payment">
<cfmenuitem name="NewPaymentVendor" href="../Payment/PaymentVendors.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="VendorPayList" href="../Payment/PaymentVendorsList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="RefundVendor" display="Refunds">
<cfmenuitem name="newRefundVendor" href="../Payment/refundVendors.cfm" display="New"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="DebitNote" display="Debit Note">
<cfmenuitem name="NewDebitNote" href="../CreditNote/DebitNote.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="PurchaseDebitNote" href="../Reports/DebitNoteList.cfm" display="List"/>
</cfmenuitem>
</cfmenuitem>

<!--- The Company menu item has a pop-up menu. --->
<cfmenuitem name="Company" display="Company" >
<cfmenuitem name="Users"  href="../Users/EditPassword.cfm" display="Change Password" />
</cfmenuitem>

<!--- The Banks menu item has a pop-up menu. --->
<cfmenuitem name="Banks" display="Bank">
</cfmenuitem>

<!--- The Reports menu item has a pop-up menu. --->
<cfmenuitem name="Reports" display="Reports">
<cfmenuitem name="Customer" display="Customer">
<cfmenuitem name="CustomerInvoice" href="../Reports/CustomerInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CustomerCreditNote" href="../Reports/CustomerCreditNote.cfm" display="Credit Note"/>
</cfmenuitem>

<cfmenuitem divider="true"/>
<cfmenuitem name="VendorID" display="Vendor">
<cfmenuitem name="VendorInvoice" href="../Reports/SupplierInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="PurchaseDebitNote2" href="../Reports/DebitNoteList.cfm" display="Debt Note"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="VendorFiscalBalance" href="../Reports/SupplierFiscalBal.cfm" display="Balance"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesSearchSup" href="../Reports/SalesSearchSupplier.cfm" display="Purchases"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="BranchReports" display="Stock">
<cfmenuitem name="BranchReportcur" href="../Reports/AllBranches.cfm" display="Current" />
<cfmenuitem divider="true"/>
<cfmenuitem name="BranchReportpre" href="../Reports/inventoryStatusSearch.cfm" display="Previous" />
<cfmenuitem divider="true"/>
<cfmenuitem name="BranchReorder" href="../Reports/AllBranchesReorder.cfm" display="Re-Order List" />
</cfmenuitem>
</cfmenuitem>
</cfmenu>
</div>