<div align="center">
<cfmenu name="menu" type="horizontal" childstyle="text-align:left" >
<cfmenuitem name="Home"
href="../index/index.cfm" display="Home"/>
<!--- The Inventory menu item has a pop-up menu. --->
<cfmenuitem name="Inventory" display="Inventory">
<cfmenuitem name="ListProduct" href="../Products/Productslist.cfm" display="Inventory List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListCategory" href="../products/CategoryList.cfm" display="Category List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListOpeningBalance" href="../OpeningBalance/OpeningBalanceList.cfm" display="O/B List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="viewAdjustments" href="../Adjustments/AdjView.cfm" display="Inventory Adj. List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ProductActivities" href="../Reports/ProductActivity.cfm" display="Product Activities"/>
</cfmenuitem>

<!--- The Customers menu item has a pop-up menu. --->
<cfmenuitem name="Customers" display="Customers">
<cfmenuitem name="ListCustomer" href="../Customers/Customerslist.cfm" display="Customers' List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ListDepositCustomer" href="../Payment/PaymentList.cfm" display="Payment List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Refund" display="Refund">
<cfmenuitem name="SearchRefund" href="../reports/refundActivity.cfm" display="Search..."/>
</cfmenuitem>
</cfmenuitem>
<!--- The Vendor menu item has a pop-up menu. --->
<cfmenuitem name="Vendor" display="Vendor">
<cfmenuitem name="ListVendor" href="../Vendors/Vendorslist.cfm" display="Vendors' List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ExpenseActivity" href="../Reports/expensesActivity.cfm" display="Expenditures"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="ExpenseAccountList" href="../Expenses/expenseAcctList.cfm" display="Expense Account List"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="VendorPayList" href="../Payment/PaymentVendorsList.cfm" display="Payment List"/>
</cfmenuitem>
<!--- The Company menu item has a pop-up menu. --->
<cfmenuitem name="Company" display="Company">
<cfmenuitem name="ClosingDate" href="../Company/ClosingDate.cfm" display="Closing Date"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Password" href="../Users/EditPassword.cfm" display="Change Password"/>
</cfmenuitem>

<!--- The Banks menu item has a pop-up menu. --->
<cfmenuitem name="Banks" display="Bank">
<cfmenuitem name="AccountStatus" href="../Reports/AccountFiscalBal.cfm" display="Status"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="AccountSearch" href="../Reports/AccountFiscalBalSearch.cfm" display="Cash Flow..."/>
<cfmenuitem divider="true"/>
<cfmenuitem name="CashTransferList" href="../Bank/fundTransferList.cfm" display="Transfer Search"/>
</cfmenuitem>

<!--- The Reports menu item has a pop-up menu. --->
<cfmenuitem name="Reports" display="Reports">
<cfmenuitem name="Financials" display="Financials">
<cfmenuitem name="Marketers" href="../Reports/MarketersReport.cfm" display="Sales Chart"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="Expenditure" href="../Reports/Expenditure.cfm" display="Monthly Expend."/>
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
<cfmenuitem name="balID" display="Balance">
<cfmenuitem name="VendorFiscalBalance" href="../Reports/SupplierFiscalBal.cfm" display="Vendors"/>
<cfmenuitem divider="true"/>
<cfmenuitem name="VendorFiscalBalVen" href="../Reports/SupplierFiscalBalVen.cfm" display="Vendors"/>
</cfmenuitem>
<cfmenuitem divider="true"/>
<cfmenuitem name="PurchaseValue" href="../Reports/purchaseAnalysis.cfm" display="Invoice Valuation" />
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
<cfmenuitem name="SalesSearch" href="../Reports/SalesSearch.cfm" display="Search..."/>
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
</cfmenuitem>
</cfmenu>
</div>