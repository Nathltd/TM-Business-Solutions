<cfquery name="sale">
select salesdate from sales
</cfquery>

<cfoutput query="sale">
#DateFormat(salesdate,'mmmm dd, yyyy')#&nbsp;&nbsp;<br>
</cfoutput>

<cfquery>
update sales
set salesdate = #DateAdd('y', 75, salesdate)#
</cfquery>

<cfoutput query="sale">
#DateFormat(salesdate,'mmmm dd, yyyy')#<br>
</cfoutput>
