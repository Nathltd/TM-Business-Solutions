
<strong>



<cfmenu name="menu" type="horizontal" fontsize="9" font="Segoe UI" childstyle="text-align:left" >
<cfmenuitem name="Home"
href="../index/index.cfm" display="Home"/>
<!--- The Products menu item has a pop-up menu. --->
<cfmenuitem name="Products"
display="Products">
<cfmenuitem name="Product" display="Product">
<cfmenuitem name="newProducts" href="../products/newproduct.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditProduct" href="../Products/updateProduct.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListProduct" href="../Products/Productslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Category" display="Category">
<cfmenuitem name="newCategory" href="../products/newCategory.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="editCategory" href="../products/updateCategory.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCategory" href="../products/CategoryList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="OpeningBalance" display="Opening Balance">
<cfmenuitem name="NewOpeningBalance" href="../OpeningBalance/newOpeningBalance.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditOpeningBalance" href="../OpeningBalance/updateOpeningBalance.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListOpeningBalance" href="../OpeningBalance/OpeningBalanceList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Transfers" display="Transfers">
<cfmenuitem name="NewTransfer" href="../Transfers/newTransfer.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateTransfer" href="../Transfers/UpdateTransfer.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListTransfer" href="../Reports/TransferSearch.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductAdjustment" display="Adjustment">
<cfmenuitem name="newAdjustment" href="../Adjustments/newAdjustment.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="editAdjustments" href="../Adjustments/UpdateAdjustment.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="viewAdjustments" href="../Adjustments/AdjView.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductActivities" href="../Reports/ProductActivity.cfm" display="Activities"/>
</cfmenuitem>

<!--- The Customers menu item has a pop-up menu. --->
<cfmenuitem name="Customers"
display="Customers">
<cfmenuitem name="MaintainCustomers"
display="Customer">
<cfmenuitem name="NewCustomer" href="../Customers/newCustomer.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditCustomer" href="../Customers/updateCustomer.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCustomer" href="../Customers/Customerslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Sales" display="Invoice">
<cfmenuitem name="NewSales" href="../sales/invoice.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateSales" href="../Sales/UpdateInvoice.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentCustomer" display="Payment">
<cfmenuitem name="NewPaymentCustomer" href="../Payment/Payment.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateDepositCustomer" href="../Payment/UpdatePayment.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListDepositCustomer" href="../Payment/PaymentList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="CreditNote" display="Credit Note">
<cfmenuitem name="NewCreditNote" href="../CreditNote/CreditNote.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditCreditNote" href="../CreditNote/UpdateCreditNote.cfm" display="Modify"/>
</cfmenuitem>
</cfmenuitem>
<!--- The Supplier menu item has a pop-up menu. --->
<cfmenuitem name="Supplier" display="Supplier">
<cfmenuitem name="MaintainVendors" display="Vendor">
<cfmenuitem name="NewVendor" href="../Vendors/newVendor.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateVendor" href="../Vendors/UpdateVendor.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListSupplier" href="../Vendors/Vendorslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Purchases" display="Purchases">
<cfmenuitem name="NewPurchases" href="../Purchases/Purchase.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdatePurchases" href="../Purchases/UpdatePurchase.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentVendor" display="Payment">
<cfmenuitem name="NewPaymentVendor" href="../Payment/PaymentVendors.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateDepositVendor" href="../Payment/UpdatePaymentVendors.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Expense" display="Expenses">
<cfmenuitem name="ExpenseType" display="Account">
<cfmenuitem name="newExpenseAccount" href="../Expenses/newExpenseAcct.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateExpenseAccount" href="../Expenses/updateExpenseAcct.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Expenses" display="Expenses">
<cfmenuitem name="newExpense" href="../Expenses/expenses.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="updateExpense" href="../Expenses/UpdateExpenses.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ExpenseActivity" href="../Reports/expensesActivity.cfm" display="Activities"/>
</cfmenuitem>
</cfmenuitem>
<!--- The Company menu item has a pop-up menu. --->
<cfmenuitem name="Company" display="Company">
<cfmenuitem name="Profile" display="Profile">
<cfmenuitem name="EditCompany" href="../Company/Company.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Mgmt" display="Mgmt">
<cfmenuitem name="FinancialYear" href="../Company/FinancialYear.cfm" display="Financial Year"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ClosingDate" href="../Company/ClosingDate.cfm" display="Closing Date"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="branches" display="Branches">
<cfmenuitem name="Newbranch" href="../Branches/newBranch.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Editbranch" href="../Branches/UpdateBranch.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Staff" display="Staff">
<cfmenuitem name="NewStaff" href="../Staff/newStaff.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditStaff" href="../Staff/UpdateStaff.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="DataManagement" display="Data Mgnt">
<cfmenuitem name="BackUp" href="../Staff/DataBackUp.cfm" display="Back Up"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Restore" href="../Staff/DataRestore.cfm" display="Restore"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Users" display="Users">
<cfmenuitem name="Password" href="../Users/EditPassword.cfm" display="Change Password"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="NewUser" href="../Users/newUser.cfm" display="New User"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditUser" href="../Users/UpdateUser.cfm" display="Edit User"/>
</cfmenuitem>
</cfmenuitem>

<!--- The Banks menu item has a pop-up menu. --->
<cfmenuitem name="Banks"
display="Bank">
<cfmenuitem name="MaintainBanks" display="Bank">
<cfmenuitem name="NewBank" href="../Bank/newBank.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateBank" href="../Bank/UpdateBank.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="AccountStatus" href="../Reports/AccountFiscalBal.cfm" display="Status"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="AccountSearch" href="../Reports/AccountFiscalBalSearch.cfm" display="Cash Flow..."/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Payment" display="Payment">
<cfmenuitem name="NewPayment" href="../Payment/Payment.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateDeposit" href="../Payment/UpdatePayment.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Transfer" display="Transfer">
<cfmenuitem name="NewCashTransfer" href="../Bank/fundTransfer.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateCashTransfer" href="../Bank/UpdateFundTransfer.cfm" display="Modify"/>
</cfmenuitem>
</cfmenuitem>

<!--- The Reports menu item has a pop-up menu. --->
<cfmenuitem name="Reports" display="Reports">
<cfmenuitem name="Financials" display="Financials">
<cfmenuitem name="Profit_Loss" href="../Reports/Profit_Loss.cfm" display="Profit &amp; Loss"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Marketers" href="../Reports/MarketersReport.cfm" display="Sales Chart"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Expenditure" href="../Reports/Expenditure.cfm" display="Expenditures"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Customer" display="Customer">
<cfmenuitem name="CustomerInvoice" href="../Reports/CustomerInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CustomerCreditNote" href="../Reports/CustomerCreditNote.cfm" display="Credit Note"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="FiscalBalance" href="../Reports/CustomerFiscalBal.cfm" display="Balance"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="SupplierID" display="Supplier">
<cfmenuitem name="SupplierInvoice" href="../Reports/SupplierInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SupplierFiscalBalance" href="../Reports/SupplierFiscalBal.cfm" display="Balance"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="BranchReports" href="../Reports/AllBranches.cfm" display="Branches" />
<cfmenuitem divider="true"/>
<cfmenuitem name="AllSales" display="Sales">
<cfmenuitem name="SalesSearch" href="../Reports/SalesSearch.cfm" display="Search..."/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CashPayment" href="../Reports/AllSalesCashByDate.cfm" display="Cash Payments" />
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="TransfersMain" display="Transfers">
<cfmenuitem name="TransfersReport" href="../Reports/TransferReport.cfm" display="Product"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="TransfersSearch" href="../Reports/TransferSearch.cfm" display="Search.."/>
</cfmenuitem>
</cfmenuitem>
</cfmenu>

</strong>