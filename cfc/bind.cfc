<cfcomponent>

	<!--- Get array of WareHouses --->
<cffunction name="Warehouse" access="remote" returnType="query" hint="Get WareHouse for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT BranchID FROM Branches
WHERE BranchType = 'Warehouse' OR BranchType = 'Warehouse/Shop'
ORDER BY BranchID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of All Branches --->
<cffunction name="AllBranches" access="remote" returnType="query" hint="Get WareHouse for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT BranchID FROM Branches
ORDER BY BranchID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Check for Duplicate Branch --->
<cffunction name="getBranchId" access="remote" returntype="string" hint="Get Branch Ids for Ajax SELECT">
<cfargument name="branchId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT branchID FROM Branches
WHERE branchID = '#ARGUMENTS.branchID#'
</cfquery>
<cfset checkValue =ValueList(data.branchID)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

	<!--- Get array of Branches --->
<cffunction name="getBranches" access="remote" returnType="query" hint="Get Branches for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" >
SELECT BranchID FROM Branches
WHERE BranchType <> 'Warehouse'
ORDER BY BranchID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Opening Balance Branches --->
<cffunction name="OBranches" access="remote" returnType="query" hint="Get Branches for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" >
SELECT BranchID FROM vwOBalanceBranchs
ORDER BY BranchID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>



	<!--- Get array of Branches types --->
<cffunction name="getBranchTypes" access="remote" returnType="query" hint="Get Branches for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT BranchType
FROM BranchType
ORDER BY BranchType
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Destination Branches --->
<cffunction name="getDestination" access="remote" returnType="query" hint="Get Branches for Ajax SELECT">
<cfargument name="SourceID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT BranchID FROM Branches
WHERE BranchID <> '#ARGUMENTS.SourceID#'
ORDER BY BranchID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get All Suppliers --->
<cffunction name="AllSuppliers" access="remote" returnType="query" hint="Get Suppliers for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT VendorID FROM Vendors
ORDER BY VendorID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get Suppliers --->
<cffunction name="Suppliers" access="remote" returnType="query" hint="Get Suppliers for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT VendorID FROM Vendors
Where VendorType = 'Supplier'
ORDER BY VendorID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get Expense Suppliers --->
<cffunction name="Vendor" access="remote" returnType="query" hint="Get Suppliers for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT VendorID FROM Vendors
Where VendorType = 'Expense'
ORDER BY VendorID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get All Products --->
<cffunction name="AllProducts" access="remote" returnType="query" hint="Get Products for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT ProductID FROM vwInventory
ORDER BY ProductID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get All Assembled Products --->
<cffunction name="AssembledProduct" access="remote" returnType="query" hint="Get Assembled Products for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT ProductID FROM Inventory
WHERE Type = 'Assemble'
ORDER BY ProductID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get All Products List For Assemble--->
<cffunction name="AssemblyProduct" access="remote" returnType="query" hint="Get Assembled Products for Ajax SELECT">
<cfargument name="BranchID" type="string">
<cfargument name="ProductID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT ProductID FROM vwProductInBranches
WHERE BranchID = '#ARGUMENTS.BranchID#' AND ProductID <> '#ARGUMENTS.ProductID#'
ORDER BY ProductID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get Products by Branch --->
<cffunction name="getProducts" access="remote" returnType="query" hint="Get Products by Branches for Ajax SELECT">
<cfargument name="Branch" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT ProductID, BranchID FROM vwProductInBranches
WHERE BranchID = '#ARGUMENTS.Branch#'
ORDER BY ProductID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get Products Id --->
<cffunction name="productsId" access="remote" returnType="query" hint="Get Products Id for Ajax SELECT">
<cfargument name="product" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT ProductID FROM Inventory
WHERE ProductId = '#ARGUMENTS.product#'
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


<!--- Get Products Description --->
<cffunction name="getDescription" access="remote" returntype="string" hint="Get Products Description for Ajax SELECT">
<cfargument name="itemName" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT distinct Description, ProductID FROM Inventory
WHERE ProductID = '#ARGUMENTS.itemName#'
</cfquery>
<cfset descrip =ValueList(data.Description)>

<!--- And return it --->
<cfreturn descrip>
</cffunction>

<!--- Get Products Cost Price --->
<cffunction name="CostPrice" access="remote" returntype="string" hint="Get Products Price for Ajax SELECT">
<cfargument name="itemName" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT distinct ProductID, costPrice FROM Inventory
WHERE ProductID = '#ARGUMENTS.itemName#'
</cfquery>
<cfset costPrice =ValueList(data.costPrice)>

<!--- And return it --->
<cfreturn costPrice>
</cffunction>

<!--- Get Products SalesPrice --->
<cffunction name="getPrice" access="remote" returntype="string" hint="Get Products Price for Ajax SELECT">
<cfargument name="itemName" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT distinct SalePrice, ProductID FROM Inventory
WHERE ProductID = '#ARGUMENTS.itemName#'
</cfquery>
<cfset SalePrice =ValueList(data.SalePrice)>

<!--- And return it --->
<cfreturn SalePrice>
</cffunction>

<!--- Get Products Quantity from Branch--->
<cffunction name="getQuantity" access="remote" returntype="string" hint="Get Products Quantity for Ajax SELECT">
<cfargument name="itemName" type="string">
<cfargument name="BranchID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT distinct Balance, ProductID FROM vwProductInBranch
WHERE ProductID = '#ARGUMENTS.itemName#' AND BranchID = '#ARGUMENTS.BranchID#'
</cfquery>
<cfset Qty =ValueList(data.Balance)>

<!--- And return it --->
<cfreturn Qty>
</cffunction>

<!--- Get Products Quantity from Branch (Transfer)--->
<cffunction name="getQtyTransfer" access="remote" returntype="string" hint="Get Products Quantity for Ajax SELECT">
<cfargument name="itemName" type="string">
<cfargument name="SourceBr" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT distinct Balance, ProductID FROM vwProductInBranch
WHERE ProductID = '#ARGUMENTS.itemName#' AND BranchID = '#ARGUMENTS.SourceBr#'
</cfquery>
<cfset Qty =ValueList(data.Balance)>

<!--- And return it --->
<cfreturn Qty>
</cffunction>


	<!--- Get array of Product Category --->
<cffunction name="getProductCategory" access="remote" returnType="query" hint="Get Product Category for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT CategoryID
FROM InventoryCategory
ORDER BY CategoryID ASC
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


<!--- Get array of Customers --->
<cffunction name="getCustomers" access="remote" returnType="query" hint="Get Customers for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT CustomerID FROM Customers
ORDER BY CustomerID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get Customer's Adddress --->
<cffunction name="getCustomerAdd" access="remote" returnType="query" hint="Get Customer Address">
<!--- Define Argument --->
<cfargument name="customerId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT address FROM Customers
WHERE customerId = '#ARGUMENTS.customerId#'
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


<!--- Check for Duplicate Customer --->
<cffunction name="getCustomerId" access="remote" returntype="string" hint="Get Customers Ids for Ajax SELECT">
<cfargument name="customerId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT customerId FROM Customers
WHERE customerId = '#ARGUMENTS.customerId#'
</cfquery>
<cfset checkCustomer =ValueList(data.customerId)>
<!--- And return it --->
<cfreturn serializeJSON(checkCustomer)>
</cffunction>


	<!--- Get Customers Balance --->
<cffunction name="customerBalance" access="remote" returnType="string" hint="Get Customers for Ajax SELECT">
<cfargument name="CustomerID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" >
SELECT Balance FROM vwCustomerPayBalance
WHERE CustomerID = '#ARGUMENTS.CustomerID#'
</cfquery>
<cfset Bal =ValueList(data.Balance)>
<cfset Balance = #LSNumberFormat(Bal,',99999999999.99')#>
<!--- And return it --->
<cfreturn balance>
</cffunction>

	<!--- Get Vendors Balance --->
<cffunction name="vendorBalance" access="remote" returnType="string" hint="Get Vendors for Ajax SELECT">
<cfargument name="SupplierID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" >
SELECT Balance FROM vwVendorPayBalance
WHERE VendorID = '#ARGUMENTS.SupplierID#'
</cfquery>
<cfset Baln =ValueList(data.Balance)>
<cfset Balance = #LSNumberFormat(Baln,',99999999999.99')#>
<!--- And return it --->
<cfreturn balance>
</cffunction>


	<!--- Get array of Staff --->
<cffunction name="getStaff" access="remote" returnType="query" hint="Get Staff from Branches for Ajax SELECT">
<cfargument name="Branch" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT FirstName FROM Users
WHERE BranchID = '#ARGUMENTS.Branch#' AND Designation like '%Sales%'
ORDER BY FirstName
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of StockKeeper --->
<cffunction name="getStockKeeper" access="remote" returnType="query" hint="Get Stock Keeper from Branches for Ajax SELECT">
<cfargument name="Branch" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT FirstName, BranchID FROM Users
WHERE BranchID = '#ARGUMENTS.Branch#' AND Designation = 'Stock Keeper'
ORDER BY FirstName
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


	<!--- Get array of Staff --->
<cffunction name="getStaffFund" access="remote" returnType="query" hint="Get Staff from Branches for Ajax SELECT">
<cfargument name="Branch" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT FirstName, UserID FROM Users
WHERE BranchID = '#ARGUMENTS.Branch#' AND Designation <> 'Alpha'
ORDER BY FirstName
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Staff --->
<cffunction name="getStaffs" access="remote" returnType="query" hint="Get Staff for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT FirstName, UserID FROM Users
WHERE Designation <> 'Alpha'
ORDER BY FirstName
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Users --->
<cffunction name="getUsers" access="remote" returnType="query" hint="Get Users for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT UserID FROM Users
WHERE Designation <> 'Alpha'
ORDER BY UserID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Department --->
<cffunction name="getDepartment" access="remote" returnType="query" hint="Get Staff's Designation for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT departName FROM department
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


	<!--- Get array of Designation --->
<cffunction name="getDesignation" access="remote" returnType="query" hint="Get Staff's Designation for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT DesignationID FROM Designation
WHERE DesignationID <> 'Alpha'
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Staff Position --->
<cffunction name="getStaffPosition" access="remote" returnType="query" hint="Get Staff's Designation for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT positionName FROM staffPosition
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Employment Type --->
<cffunction name="getEmployType" access="remote" returnType="query" hint="Get Staff's Designation for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT typeName FROM employmentType
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Branch Cash Accounts --->
<cffunction name="ChequeAccounts" access="remote" returnType="query" hint="Get Accounts for Ajax SELECT">
<cfargument name="Branch" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE AccountType = 'Cash/Cheque' AND AccountID <> '#ARGUMENTS.Branch#'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


	<!--- Get array of Branch Cash Accounts --->
<cffunction name="getBankAccounts" access="remote" returnType="query" hint="Get Accounts for Ajax SELECT">
<cfargument name="Branch" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE AccountID = '#ARGUMENTS.Branch#'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Payment Type--->
<cffunction name="getPaymentType" access="remote" returnType="query" hint="Get  Payment Type for Ajax SELECT">

<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT paymentType FROM paymentType
ORDER BY paymentType
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Accounts --->
<cffunction name="getBankAccount" access="remote" returnType="query" hint="Get Accounts for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE AccountType = 'Cash/Cheque' OR AccountType = 'Cash'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Accounts --->
<cffunction name="getCashAccount" access="remote" returnType="query" hint="Get Accounts for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE AccountType = 'Cash'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>
	
	<!--- Get array of Accounts --->
<cffunction name="getAllBankAccounts" access="remote" returnType="query" hint="Get Accounts for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Cheque Accounts --->
<cffunction name="getChequeAccount" access="remote" returnType="query" hint="Get Accounts for Ajax SELECT">
<cfargument name="SourceID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE AccountNumber >= '0' AND AccountID <> '#ARGUMENTS.SourceID#' AND AccountType <> 'Rebate'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Cheque Accounts --->
<cffunction name="getChequeAccounts" access="remote" returnType="query" hint="Get Accounts for Ajax SELECT">
<cfargument name="BranchID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE Accountid = '#ARGUMENTS.BranchID#'  OR AccountType = 'Cheque' OR AccountType = 'Cash/Cheque'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


<!--- Get array of Expense Accounts --->
<cffunction name="getExpenseAccounts" access="remote" returnType="query" hint="Get Expense Accounts for Ajax SELECT">

<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM ExpenseAccount
WHERE AccountId <> 'Rebate'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get array of Account Type --->
<cffunction name="getAccountType" access="remote" returnType="query" hint="Get Branches for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountType FROM AccountType
WHERE AccountType <> 'Rebate'
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>


	<!--- Get array of Destination Account --->
<cffunction name="getDestinationAcct" access="remote" returnType="query" hint="Get Account for Ajax SELECT">
<cfargument name="SourceID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID FROM Accounts
WHERE AccountID <> '#ARGUMENTS.SourceID#' AND AccountType <> 'Rebate'
ORDER BY AccountID
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

	<!--- Get Account Balance--->
<cffunction name="getAcctBalance" access="remote" returnType="string" hint="Get Account for Ajax SELECT">
<cfargument name="SourceID" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT AccountID, Balance FROM vwAccntBalance
WHERE AccountID = '#ARGUMENTS.SourceID#'
ORDER BY AccountID
</cfquery>
<cfset Balc =ValueList(data.Balance)>
<cfset Balance = #LSNumberFormat(Balc,',99999999999.99')#>
<!--- And return it --->
<cfreturn balance>
</cffunction>

	<!--- Get Auto Generate Invoice Number --->
<cffunction name="invNumber" access="remote"   hint="Get Account for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
select salesid from sales
where salesid not like '%m%'
order by salesid desc
</cfquery>

<cfset InvNumber =ValueList(data.salesid)>
<cfif #InvNumber# is "">
<cfset #invNumber# = 1>
<cfelse>
<cfset InvNumber = #InvNumber#+1>
</cfif>
<!--- And return it --->
<cfreturn InvNumber>
</cffunction>



	<!--- Get Auto Generate Transfer Number --->
<cffunction name="transNumber" access="remote"   hint="Get Account for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
select transferid from transfers
where transferid not like '%m%'
order by transferid desc
</cfquery>

<cfset InvNumber =ValueList(data.transferid)>
<cfif #InvNumber# is "">
<cfset #invNumber# = 1>
<cfelse>
<cfset InvNumber = #InvNumber#+1>
</cfif>

<!--- And return it --->
<cfreturn InvNumber>
</cffunction>

<!--- Get Auto Generate CreditNote Number --->
<cffunction name="invCredit" access="remote"   hint="Get Account for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
select CreditNoteID from CreditNote
where CreditNoteID not like '%m%'
order by id desc
</cfquery>

<cfset InvNumber =ValueList(data.CreditNoteID)>
<cfif #InvNumber# is "">
<cfset #invNumber# = 1>
<cfelse>
<cfset InvNumber = #InvNumber#+1>
</cfif>
<!--- And return it --->
<cfreturn InvNumber>
</cffunction>

<!--- Get Auto Generate DebitNote Number --->
<cffunction name="debitNote" access="remote"   hint="Get Account for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
select debitNoteID from debitNote
where debitNoteID not like '%m%'
order by id desc
</cfquery>

<cfset InvNumber =ValueList(data.debitNoteID)>
<cfif #InvNumber# is "">
<cfset #invNumber# = 1>
<cfelse>
<cfset InvNumber = #InvNumber#+1>
</cfif>
<!--- And return it --->
<cfreturn InvNumber>
</cffunction>

<!--- Check for Duplicate Expense Account Ref --->
<cffunction name="getExpenseAcc" access="remote" returntype="string" hint="Get expense Acct for Ajax SELECT">
<cfargument name="accountId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT accountId FROM expenseAccount
WHERE accountId = '#ARGUMENTS.accountId#'
</cfquery>
<cfset checkValue =ValueList(data.accountId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate Expense Ref --->
<cffunction name="getExpenseId" access="remote" hint="Get expenseId for Ajax SELECT">
<cfargument name="ref" type="numeric">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT ref FROM expenses
WHERE ref = #ARGUMENTS.ref#
</cfquery>
<cfset checkValue =ValueList(data.ref)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate Supplier Payment Id --->
<cffunction name="getSupplyPayId" access="remote" returntype="string" hint="Get Supplier Payment for Ajax SELECT">
<cfargument name="accountId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT paymentId FROM paymentVendors
WHERE paymentId = '#ARGUMENTS.accountId#'
</cfquery>
<cfset checkValue =ValueList(data.paymentId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate Payment Id --->
<cffunction name="getPayId" access="remote" returntype="string" hint="Get Payment for Ajax SELECT">
<cfargument name="ref" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT paymentId FROM payments
WHERE paymentId = '#ARGUMENTS.ref#'
</cfquery>
<cfset checkValue =ValueList(data.paymentId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate VendorPayment Id --->
<cffunction name="getVPayId" access="remote" returntype="string" hint="Get Payment for Ajax SELECT">
<cfargument name="ref" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT paymentId FROM paymentsVendors
WHERE paymentId = '#ARGUMENTS.ref#'
</cfquery>
<cfset checkValue =ValueList(data.paymentId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate VendorRefund Id --->
<cffunction name="getVRefundId" access="remote" returntype="string" hint="Get Payment for Ajax SELECT">
<cfargument name="ref" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT paymentId FROM refundVendors
WHERE paymentId = '#ARGUMENTS.ref#'
</cfquery>
<cfset checkValue =ValueList(data.paymentId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate Fund Transfer Id --->
<cffunction name="getFtransferId" access="remote" hint="Get Payment for Ajax SELECT">
<cfargument name="ref" type="numeric">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT transferId FROM FundTransfers
WHERE transferId = #ARGUMENTS.ref#
</cfquery>
<cfset checkValue =ValueList(data.transferId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

	<!--- Get Invoice Number Call Back --->
<cffunction name="SalesCallBack" access="remote"  returntype="string" hint="Get Account for Ajax SELECT">
<cfargument name="salesId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
select salesid from sales
where salesId = #ARGUMENTS.salesId#
</cfquery>
<cfset checkValue =ValueList(data.salesId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Get Closing Date --->
<cffunction name="closingDate" access="remote" returntype="string" hint="Get Closing Date for Ajax">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
select closingDate from closingDate
</cfquery>
<!--- And return it --->
<cfreturn serializeJSON(dateformat(data.closingDate,"dd-mm-yyyy"))>
</cffunction>

	<!--- Get Customer's OutStanding --->
<cffunction name="OutStanding" access="remote"  returntype="string" hint="Get Customer's OutStanding for Ajax SELECT">
<cfargument name="customerId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
select SUM(-Balance-creditLimit) AS OutStand from vwCustomerPayBalance
where customerId = '#ARGUMENTS.customerId#'
</cfquery>
<cfset checkValue = data.OutStand>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

	<!--- Get Customer's OutStanding --->
<cffunction name="creditLimit" access="remote"  returntype="string" hint="Get Customer's Credit Limit for Ajax SELECT">
<cfargument name="customerId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
select creditLimit from Customers
where customerId = '#ARGUMENTS.customerId#'
</cfquery>
<cfset checkValue = data.creditLimit>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate Purchase Id --->
<cffunction name="getPurchaseId" access="remote" returntype="string" hint="Get Purchase for Ajax SELECT">
<cfargument name="ref" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT receiptId FROM purchase
WHERE receiptId = '#ARGUMENTS.ref#'
</cfquery>
<cfset checkValue =ValueList(data.receiptId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate Sales Id --->
<cffunction name="getSalesId" access="remote" hint="Get Sales for Ajax SELECT">
<cfargument name="ref" type="numeric">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT salesId FROM sales
WHERE salesId = #ARGUMENTS.ref#
</cfquery>
<cfset checkValue =ValueList(data.salesId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Check for Duplicate DebitNote Id --->
<cffunction name="getDebitNoteId" access="remote" hint="Get Sales for Ajax SELECT">
<cfargument name="ref" type="numeric">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT debitNoteId FROM debitNote
WHERE debitNoteId = #ARGUMENTS.ref#
</cfquery>
<cfset checkValue =ValueList(data.debitNoteId)>
<!--- And return it --->
<cfreturn serializeJSON(checkValue)>
</cffunction>

<!--- Get General Customers' Phone --->
<cffunction name="getGenPhone" access="remote" returntype="string" hint="Get General Customers' Phone  for Ajax SELECT">
<cfargument name="genName" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" >
SELECT distinct CustomerId, phone FROM customersGen
WHERE customerId = '#ARGUMENTS.genName#'
</cfquery>
<cfset CustomerId =ValueList(data.phone)>

<!--- And return it --->
<cfreturn CustomerId>
</cffunction>

<!--- Get General Customers' Invoice --->
<cffunction name="getGenInv" access="remote" returntype="string" hint="Get General Customers' Invoice  for Ajax SELECT">
<cfargument name="genName" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT distinct CustomerId, SalesId FROM customersGen
WHERE customerId = '#ARGUMENTS.genName#'
</cfquery>
<cfset SalesId =ValueList(data.SalesId)>

<!--- And return it --->
<cfreturn SalesId>
</cffunction>

<!--- Get Barcode Details --->

<cffunction name="getBarcode" access="remote" returntype="string" hint="Get Barcode Details for Ajax SELECT">
<cfargument name="itemCode" type="string">
<cfargument name="BranchId" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT DISTINCT vwProductInBranch.ProductID, vwProductInBranch.barCode, vwProductInBranch.Description, vwProductInBranch.SalePrice, vwProductInBranch.Balance, Inventory.UoM, Inventory.salesUoM, Inventory.salesUoMConvert1
FROM vwProductInBranch LEFT JOIN Inventory ON vwProductInBranch.ProductID = Inventory.ProductID
WHERE vwProductInBranch.barCode = '#ARGUMENTS.itemCode#' AND vwProductInBranch.BranchID = '#ARGUMENTS.BranchId#';
</cfquery>

<!--- Declare the structure ---> 
<cfset mystruct=structnew()> 
 
<!--- Populate the structure row by row ---> 
<cfloop query="data"> 
    <cfset mystruct[1]=barCode> 
    <cfset mystruct[2]=ProductID> 
    <cfset mystruct[3]=Description> 
    <cfset mystruct[4]=salePrice>
    <cfset mystruct[5]=balance> 
    <cfset mystruct[6]=UoM>
    <cfset mystruct[7]=salesUoM>
    <cfset mystruct[8]=salesUoMConvert1>
</cfloop>

<!--- And return it --->
<cfreturn serializeJSON(mystruct)>
</cffunction>

<!--- Delete Demo --->
<cffunction name="DeleteCustomer" access="remote" hint="Delete Demo">
<cfargument name="customer" type="string">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
delete customerId FROM customers
WHERE customerId = '#ARGUMENTS.customer#'
</cfquery>

</cffunction>

	<!--- Get array of STATES  --->
<cffunction name="AllStates" access="remote" returnType="query" hint="Get WareHouse for Ajax SELECT">
<!--- Define variables --->
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT distinct state FROM lgas
ORDER BY state
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get array of LGA  --->
<cffunction name="AllLGAs" access="remote" returnType="query" hint="Get WareHouse for Ajax SELECT">
<!--- Define variables --->
<cfargument name="state" type="string">
<cfset var data="">
<!--- Get data --->
<cfquery name="data">
SELECT lga FROM lgas
WHERE state = '#ARGUMENTS.state#'
ORDER BY lga
</cfquery>
<!--- And return it --->
<cfreturn data>
</cffunction>

<!--- Get array of LGA CHARGES  --->
<cffunction name="LGAsPrice" access="remote" returnType="string" hint="Get WareHouse for Ajax SELECT">
<!--- Define variables --->
<cfargument name="lga" type="string">
<cfargument name="state" type="string">
<cfset var data="">
<!--- Get data --->
<cfquery name="data" maxrows="1">
SELECT fee FROM lgas
WHERE lga = '#ARGUMENTS.lga#' AND state = '#ARGUMENTS.state#'
</cfquery>

<!--- Declare the structure ---> 
<cfset mystruct=structnew()> 
 
<!--- Populate the structure row by row ---> 
<cfloop query="data"> 
    <cfset mystruct[1]=fee>  
</cfloop>

<!--- And return it --->
<cfreturn serializeJSON(mystruct)>
</cffunction>

<cffunction name="itemSearch" access="remote" returntype="string" output="no">
        <cfargument name="term" required="true" default="" />

        <!--- Define variables --->
        <cfset var returnArray =ArrayNew(1)>

        <!--- Do search --->
        <cfquery name="data">
        SELECT barCode, Description, ProductID, salePrice FROM inventory
        where productId like <cfqueryparam value="%#arguments.term#%" cfsqltype="cf_sql_varchar">
        order by productId
        </cfquery>

        <!--- Build result array --->
        <cfloop query="data">
            <cfset itemStruct = structNew() />
            <cfset itemStruct['desc'] = Description />
            <cfset itemStruct['price'] = salePrice />

            <cfset arrayAppend(returnArray,itemStruct) />    
        </cfloop>

        <!--- And return it --->
        <cfreturn serializeJSON(returnArray) />
    </cffunction>

</cfcomponent>