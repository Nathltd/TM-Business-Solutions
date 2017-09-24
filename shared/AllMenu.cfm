<link rel="shortcut icon" href="../shared/TMicon.ico"/>
<link rel="stylesheet" type="text/css" media="all" href="../css/styles.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">
<cfinclude template="../Index/Validator.cfm">
<cfinclude template="../shared/header.cfm">
<div align="center">
<div align="center" id="mainMenu">
<cfif #GetUserRoles()# is "Administrator">
<cfinclude template="Menu.cfm">
<cfelseif #GetUserRoles()# is "Alpha">
<cfinclude template="../shared/Alpha.cfm">
<cfelseif #GetUserRoles()# is "Manager">
<cfinclude template="../shared/Manager.cfm">
<cfelseif #GetUserRoles()# is "Accountant">
<cfinclude template="../shared/Accountant.cfm">
<cfelseif #GetUserRoles()# is "Accountant1">
<cfinclude template="../shared/Accountant1.cfm">
<cfelseif #GetUserRoles()# is "Accountant2">
<cfinclude template="../shared/Accountant2.cfm">
<cfelseif #GetUserRoles()# is "Sales Cashier">
<cfinclude template="../shared/SalesCashier.cfm">
<cfelseif #GetUserRoles()# is "Cashier">
<cfinclude template="../shared/Cashier.cfm">
<cfelseif #GetUserRoles()# is "Sales Rep">
<cfinclude template="../shared/SalesRep.cfm">
<cfelseif #GetUserRoles()# is "Stock Keeper">
<cfinclude template="../shared/stockkeeper.cfm">
<cfelseif #GetUserRoles()# is "Procurement">
<cfinclude template="../shared/Procurement.cfm">
</cfif>
</div>
</div>
<cfquery name="user">
SELECT * FROM Users
WHERE UserID = '#GetAuthUser()#'
</cfquery>
<cfif #user.phone# is "">
<script>
alert('Your Profile Details needs to be updated. Please Update!');
</script>
<cfinclude template="../users/editprofile.cfm">
<cfabort>
</cfif>