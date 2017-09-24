<div align="center">
<cfmenu name="menu" type="horizontal"  childstyle="text-align:left" >
<cfmenuitem name="Home" href="../index/index.cfm" display="Home"/>

<!--- The Inventory menu item has a pop-up menu. --->
<cfmenuitem name="Inventory" display="Inventory">
<cfmenuitem name="Product" display="Product">
<cfmenuitem name="ListProduct" href="../Products/Productslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Category" display="Category">
<cfmenuitem name="ListCategory" href="../products/CategoryList.cfm" display="List"/>
</cfmenuitem>
</cfmenuitem>

<!--- The Customers menu item has a pop-up menu. --->
<cfmenuitem name="Customers" display="Customers">
<cfmenuitem name="NewSales" href="../sales/invoiceGen.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="NewSale" href="../sales/invoice.cfm" display="Dealer"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Order" display="Sales Order">
<cfmenuitem name="NewOrderGen" href="../sales/OrderGen.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="NewOrder" href="../sales/Order.cfm" display="Dealer"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="salesModify" display="Modify" href="../sales/updateInvoice.cfm" />
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCustomer" display="List">
<cfmenuitem name="ListCustomerGen" href="../Customers/GenCustomerslist.cfm" display="General"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCustomerDealers" href="../Customers/Customerslist.cfm" display="Dealers"/>
</cfmenuitem>
</cfmenuitem>
<!--- The Vendor menu item has a pop-up menu. --->
<cfmenuitem name="Vendor" display="Vendor"/>
<!--- The Company menu item has a pop-up menu. --->
<cfmenuitem name="Company" display="Company">
<cfmenuitem name="Users"  href="../Users/EditPassword.cfm" display="Change Password">
</cfmenuitem>
</cfmenuitem>

<!--- The Banks menu item has a pop-up menu. --->
<cfmenuitem name="Banks" display="Bank" />

<!--- The Reports menu item has a pop-up menu. --->
<cfmenuitem name="Reports" display="Reports">
<cfmenuitem name="CustomerInvoice" href="../Reports/CustomerInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="AllSales" display="Sales">
<cfmenuitem name="SalesSearch" href="../Reports/SalesSearch.cfm" display="Search..."/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesValue" href="../Reports/salesAnalysis.cfm" display="Invoice Valuation" />
</cfmenuitem>
</cfmenuitem>
</cfmenu>
</div>