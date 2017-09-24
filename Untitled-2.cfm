<cfquery name="branch">
SELECT [FirstName]+' '+
      [LastName] as NAME
      ,[Designation]
      ,[UserID]
      ,[BranchID] from
      USERS
      WHERE UserId = '#GetAuthUser()#'
	</cfquery>
<cfoutput>#session.BranchID#</cfoutput>


<!---Branch Identity--->
<cfquery name="branch">
SELECT [FirstName]
      ,[LastName]
      ,[Designation]
      ,[UserID]
      ,[BranchID] from
      USERS
	</cfquery>