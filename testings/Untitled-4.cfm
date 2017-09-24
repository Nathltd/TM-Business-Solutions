<cfset mydatetime=now()>
<cfoutput>The original time and date is 
#TimeFormat(MyDateTime,'hh:mm:ss tt')#, #DateFormat(MyDateTime,'mmmm dd, yyyy')#
<p><b>Add 30 Seconds:</b> 
#TimeFormat(DateAdd('s', 30, MyDateTime),'hh:mm:ss tt')#
<br><b>Subtract 10 minutes:</b> 
#TimeFormat(DateAdd('n', -10, MyDateTime),'hh:mm:ss tt')#
<br><b>Add 2 hours:</b> 
#TimeFormat(DateAdd('h', 2, MyDateTime),'hh:mm:ss tt')#
<br><b>Add 9 weeks:</b> 
#DateFormat(DateAdd('ww', 9, MyDateTime),'mmmm dd, yyyy')#
<br><b>Add 3 weekdays:</b> 
#DateFormat(DateAdd('w', 3, MyDateTime),'mmmm dd, yyyy')#
<br><b>Subtract 67 days:</b> 
#DateFormat(DateAdd('d', -67, MyDateTime),'mmmm dd, yyyy')#
<br><b>Add 45 days of the year:</b> 
#DateFormat(DateAdd('y', 45, MyDateTime),'mmmm dd, yyyy')#
<br><b>Subtract 7 months:</b> 
#DateFormat(DateAdd('m', -7, MyDateTime),'mmmm dd, yyyy')#
<br><b>Subtract 2 quarters:</b> 
#DateFormat(DateAdd('q', -2, MyDateTime),'mmmm dd, yyyy')#
<br><b>Subtract 5 years:</b> 
#DateFormat(DateAdd('yyyy', -5, MyDateTime),'mmmm dd, yyyy')#
</cfoutput>