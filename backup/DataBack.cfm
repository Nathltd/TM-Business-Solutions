
  <cfoutput>#expandpath('#request.dsn#-#dateformat(now(),"dd-mm-yyyy")#.bak')#<br>
#request.dsn#-#dateformat(now(),"dd-mm-yyyy")#.bak<br>
#expandpath("/")##request.dsn#-#dateformat(now(),"dd-mm-yyyy")#.bak


<a href="ftp.#expandpath("/")##request.dsn#-#dateformat(now(),"dd-mm-yyyy")#.bak">
Download!</a>
</cfoutput>