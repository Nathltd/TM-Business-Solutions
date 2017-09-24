


<cfset uploadFile = "#expandpath("/")#backup\TM001.mdb">
<cfset uploadfolder = "#expandpath("/")#tm001\db\">
<br />

<cfoutput>
uploadfile = #uploadfile#<br>
uploadfolder = #uploadfolder#<br>
#uploadfolder#TMonline.bak
</cfoutput>

New