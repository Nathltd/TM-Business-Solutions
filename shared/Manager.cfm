<div align="center">
<cfmenu name="menu" type="horizontal" childstyle="text-align:left" >
<cfmenuitem name="Home" href="../index/index.cfm" display="Home"/>
<!--- The Inventory menu item has a pop-up menu. --->
<cfmenuitem name="Inventory"
display="Inventory">
<cfmenuitem name="Product" display="Product">
<cfmenuitem name="newProducts" href="../products/newproduct.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditProduct" href="../Products/updateProduct.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductsConsting" href="../Products/ProductsCosting.cfm" display="Costing"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListProduct" href="../Products/Productslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Category" display="Category">
<cfmenuitem name="editCategory" href="../products/updateCategory.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCategory" href="../products/CategoryList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Transfers" display="Transfers">
<cfmenuitem name="UpdateTransfer" href="../Transfers/UpdateTransfer.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListTransfer" href="../Reports/TransferSearch.cfm" display="List"/>
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
<cfmenuitem name="ProductActivities" href="../Reports/ProductActivity.cfm" display="Activities"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductAnalysis" href="../Reports/ProductAnalysis.cfm" display="Analysis"/>
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
<cfmenuitem name="ListCustomer" display="List">
<cfmenuitem name="ListCustomerGen" href="../Customers/GenCustomerslist.cfm" display="General"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCustomerDealers" href="../Customers/Customerslist.cfm" display="Dealers"/>
</cfmenuitem>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Order" display="Sales Order">
<cfmenuitem name="NewOrderGen" href="../sales/OrderGen.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="NewOrder" href="../sales/Order.cfm" display="Dealer"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesOrderList" href="../reports/OrderList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Sales" display="Invoice">
<cfmenuitem name="CallBack" display="Call Back">
<cfmenuitem name="CallBackSales" href="../Adjustments/modifyQueue.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CallBackList" href="../reports/callbackList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateSales" href="../Sales/UpdateInvoice.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentCustomer" display="Payment">
<cfmenuitem name="PaymentCustomerDealer" display="Dealers">
<cfmenuitem name="UpdateDepositCustomer" href="../Payment/UpdatePayment.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListDepositCustomer" href="../Payment/PaymentList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentGenCustomer" display="General">
<cfmenuitem name="UpdateDepositGenCustomer" href="../Payment/UpdatePaymentGen.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListDepositGenCustomer" href="../Payment/PaymentListGen.cfm" display="List"/>
</cfmenuitem>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="CreditNote" display="Credit Note">
<cfmenuitem name="NewCreditNote" href="../CreditNote/CreditNote.cfm" display="New"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Rebate" display="Rebate">
<cfmenuitem name="NewRebate" href="../Expenses/rebate.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditRebate" href="../Expenses/updateRebate.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Refund" display="Refund">
<cfmenuitem name="NewRefund" href="../Expenses/Refund.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditRefund" href="../Expenses/updateRefund.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Reimburse" display="Reimburse">
<cfmenuitem name="NewReimburse" href="../Expenses/Reimburse.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditReimburse" href="../Expenses/updateReimburse.cfm" display="Modify"/>
</cfmenuitem>
</cfmenuitem>
<!--- The Vendor menu item has a pop-up menu. --->
<cfmenuitem name="Vendor" display="Vendor">
<cfmenuitem name="MaintainVendors" display="Vendor">
<cfmenuitem name="NewVendor" href="../Vendors/newVendor.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateVendor" href="../Vendors/UpdateVendor.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListVendor" href="../Vendors/Vendorslist.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Purchases" display="Purchases">
<cfmenuitem name="UpdatePurchases" href="../Purchases/UpdatePurchase.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PaymentVendor" display="Purchase Payment">
<cfmenuitem name="NewPaymentVendor" href="../Payment/PaymentVendors.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="VendorPayList" href="../Payment/PaymentVendorsList.cfm" display="List"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="DebitNote" display="Debit Note">
<cfmenuitem name="NewDebitNote" href="../CreditNote/DebitNote.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="EditDebitNote" href="../CreditNote/UpdateDebitNote.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="PurchaseDebitNote" href="../Reports/DebitNoteList.cfm" display="List"/>
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
<cfmenuitem name="updateExpense" href="../Expenses/UpdateExpenses.cfm" display="Modify"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="ExpenseActivity" href="../Reports/expensesActivity.cfm" display="Activities"/>
</cfmenuitem>
</cfmenuitem>
<!--- The Company menu item has a pop-up menu. --->
<cfmenuitem name="Company" display="Company">
<cfmenuitem name="DataManagement" display="Data Mgnt">
<cfmenuitem name="BackUp" href="##" display="Back Up"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Restore" href="##" display="Restore"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Users" display="Users">
<cfmenuitem name="Password" href="../Users/EditPassword.cfm" display="Change Password"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListUser" href="../Users/UserList.cfm" display="List Users"/>
</cfmenuitem>
</cfmenuitem>
<!--- The Banks menu item has a pop-up menu. --->
<cfmenuitem name="Banks" display="Bank">
<cfmenuitem name="MaintainBanks" display="Bank">
<cfmenuitem name="NewBank" href="../Bank/newBank.cfm" display="New"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="UpdateBank" href="../Bank/UpdateBank.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="AccountStatus" href="../Reports/AccountFiscalBal.cfm" display="Ledger"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="AccountSearch" href="../Reports/AccountFiscalBalSearch.cfm" display="Cash Flow..."/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Transfer" display="F-Transfer">
<cfmenuitem name="UpdateCashTransfer" href="../Bank/UpdateFundTransfer.cfm" display="Modify"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CashTransferList" href="../Bank/fundTransferList.cfm" display="Search..."/>
</cfmenuitem>
</cfmenuitem>

<!--- The Reports menu item has a pop-up menu. --->
<cfmenuitem name="Reports" display="Reports">
<cfmenuitem name="Financials" display="Financials">
<cfmenuitem name="finReport" href="../Reports/CashSummary.cfm" display="Cash Summary"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Expenditure" href="../Reports/Expenditure.cfm" display="Expenditures"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="Customer" display="Customer">
<cfmenuitem name="CustomerInvoice" href="../Reports/CustomerInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CustomerWaybill" href="../Reports/CustomerWaybill.cfm" display="Waybill"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Customerpayment" href="../Reports/Customerpayment.cfm" display="Payments"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CustomerCreditNote" href="../Reports/CustomerCreditNote.cfm" display="Credit Note"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="FiscalBalance" href="../Reports/CustomerFiscalBal.cfm" display="Ledger"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="creditorsBalance" href="../Reports/CustomerFiscalBal.cfm?type=creditors" display="Creditors"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="debtorsBalance" href="../Reports/CustomerFiscalBal.cfm?type=debtors" display="Debtors"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="VendorID" display="Vendor">
<cfmenuitem name="VendorInvoice" href="../Reports/SupplierInvoice.cfm" display="Invoice"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="PurchaseDebitNote2" href="../Reports/DebitNoteList.cfm" display="Debt Note"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="balID" display="Balance">
<cfmenuitem name="VendorFiscalBalance" href="../Reports/SupplierFiscalBal.cfm" display="Suppliers"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SupplierFiscalBalVen" href="../Reports/SupplierFiscalBalVen.cfm" display="Expenses"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PurchaseValue" href="../Reports/purchaseAnalysis.cfm" display="Invoice Valuation" />
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
<cfmenuitem divider="true"/>
<cfmenuitem name="AllSales" display="Sales">
<cfmenuitem name="SalesSearch" display="Search...">
<cfmenuitem name="SalesSearchBranch" href="../Reports/SalesSearch.cfm" display="By Branch"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesSearchCust" href="../Reports/SalesSearchCustomer.cfm" display="By Customer"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="CashPayment" href="../Reports/AllSalesCashByDate.cfm" display="Cash Payments" />
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesAnalysis" href="../Reports/salesAnalysis.cfm" display="Analysis" />
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesValuation" display="Valuation">
<cfmenuitem name="SalesValue" href="../Reports/salesAnalysis3.cfm" display="By Date" />
<cfmenuitem divider="true"/>
<cfmenuitem name="SalesValueInv" href="../Reports/salesAnalysis4.cfm" display="By Invoice" />
</cfmenuitem>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="TransfersMain" display="Transfers">
<cfmenuitem name="TransfersReport" href="../Reports/TransferReport.cfm" display="Product"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="TransfersSearch" href="../Reports/TransferSearch.cfm" display="Search.."/>
</cfmenuitem>
</cfmenuitem>
</cfmenu>
</div>