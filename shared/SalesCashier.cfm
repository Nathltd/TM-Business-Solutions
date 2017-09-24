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
<cfmenuitem name="salesModify" display="Modify" href="../sales/updateInvoice.cfm" />
<cfmenuitem divider="true"/>
<cfmenuitem name="Order" display="Sales Order">
<cfmenuitem name="NewOrderGen" href="../sales/OrderGen.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="NewOrder" href="../sales/Order.cfm" display="Dealer"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesOrderList" href="../reports/OrderList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCustomer" display="List">
<cfmenuitem name="ListCustomerGen" href="../Customers/GenCustomerslist.cfm" display="General"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCustomerDealers" href="../Customers/Customerslist.cfm" display="Dealers"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentCustomer" display="Payment">
<cfmenuitem name="PaymentCustomerDealer" display="Dealers">
<cfmenuitem name="NewPaymentCustomer" href="../Payment/Payment.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListDepositCustomer" href="../Payment/PaymentList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentGenCustomer" display="General">
<cfmenuitem name="NewPaymentGenCustomer" href="../Payment/PaymentGen.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListDepositGenCustomer" href="../Payment/PaymentListGen.cfm" display="List"/>
</cfmenuitem>
</cfmenuitem>
</cfmenuitem>
<!--- The Vendor menu item has a pop-up menu. --->
<cfmenuitem name="Vendor" display="Vendor">
<cfmenuitem name="Expense" display="Expenses">
<cfmenuitem name="Expenses" display="Expenses">
<cfmenuitem name="newExpense" href="../Expenses/expenses.cfm" display="New"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ExpensesRefund" display="Refunds">
<cfmenuitem name="newExpensesRefund" href="../Expenses/ExpensesRefund.cfm" display="New"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ExpenseActivity" href="../Reports/expensesActivity.cfm" display="Activities"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="RefundVendor" display="Refunds">
<cfmenuitem name="newRefundVendor" href="../Payment/refundVendors.cfm" display="New"/>
</cfmenuitem>
</cfmenuitem>

<!--- The Company menu item has a pop-up menu. --->
<cfmenuitem name="Company" display="Company" >
<cfmenuitem name="Users"  href="../Users/EditPassword.cfm" display="Change Password" />
</cfmenuitem>

<!--- The Banks menu item has a pop-up menu. --->
<cfmenuitem name="Banks"
display="Bank">
<cfmenuitem name="MaintainBanks" display="Bank">
<cfmenuitem name="AccountSearch" href="../Reports/AccountFiscalBalSearch.cfm" display="Cash Flow..."/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Transfer" display="F-Transfer">
<cfmenuitem name="NewCashTransfer" href="../Bank/fundTransfer.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CashTransferList" href="../Bank/fundTransferList.cfm" display="Search..."/>
</cfmenuitem>
</cfmenuitem>

<!--- The Reports menu item has a pop-up menu. --->
<cfmenuitem name="Reports" display="Reports">
<cfmenuitem name="Customer" display="Customer">
<cfmenuitem name="CustomerInvoice" href="../Reports/CustomerInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Customerpayment" href="../Reports/Customerpayment.cfm" display="Payments"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CustomerCreditNote" href="../Reports/CustomerCreditNote.cfm" display="Credit Note"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="VendorID" display="Vendor">
<cfmenuitem name="balID" display="Balance">
<cfmenuitem name="VendorFiscalBalVen" href="../Reports/SupplierFiscalBalVen.cfm" display="Vendors"/>
</cfmenuitem>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="BranchReports" href="../Reports/AllBranches.cfm" display="Stock" />
<cfmenuitem divider="true"/>
<cfmenuitem name="AllSales" display="Sales">
<cfmenuitem name="SalesSearch" display="Search...">
<cfmenuitem name="SalesSearchBranch" href="../Reports/SalesSearch.cfm" display="By Branch"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesSearchCust" href="../Reports/SalesSearchCustomer.cfm" display="By Customer"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesValue" href="../Reports/salesAnalysis.cfm" display="Invoice Valuation" />
</cfmenuitem>
</cfmenuitem>
</cfmenu>
</div>