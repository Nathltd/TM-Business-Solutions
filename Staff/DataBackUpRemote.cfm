<!doctype html>
<html>
<head>
<title><cfoutput>Back-Up Wizard :: #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css"rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>
<div align="center">
<cfinclude template="../shared/allMenu.cfm">

<div id="Content">
<h4>Data Back-Up Wizard</h4>
<div id="RightColumn">

<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>

<cfset uploadFile = "#expandpath("/")##request.bkup#db\TM001.mdb">
<cfset uploadfolder = "#expandpath("/")##request.bkup#backup\">
<br />

<!---<cfdump var="#uploadFile#">
<cfabort>--->
    
<!---    <cfif isdefined("url.flash")>
  
    
    <h3> Back Up Downloaded Successfully! </h3>
    <cfabort>
    </cfif>--->
    
    <cfif not isdefined("form.upLoad_now")> 
    <p> Insert your USB Flash Drive and Enter the Company Code. </p>
  <cfform action="#cgi.SCRIPT_NAME#" method="post" preservedata="no" enctype="multipart/form-data" name="upload_form" id="upload_form"> 
    <table width="207" border="0" align="center" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF"> 
      <tr bgcolor="#BACAE4"> 
        <td colspan="2" align="center"><font color="#FF3300" size="-1"></font></td> 
      </tr>
       <tr> 
              <td width="69" align="right"> Data Code: </td>
        <td width="100" align="left"> <cfinput type="password" name="ItemCode" range="8" id="ItemCode" class="bold_10pt_black" autosuggest="off" required="yes" message="Enter Data Code"></td> 
      </tr> 
       <tr> 
        <td align="right"><!---<input type="file" name="Image1" id="Image1" size="10" />---></td>
         <td align="left"><div align="right">
           <cfinput name="upload_now" type="submit" class="bold_10pt_Button" validate="submitonce" value="Back Up" />
         </div></td> 
      </tr> 
    </table> 
  </cfform>  
<cfelse>
	<cfif #form.ItemCode# is "20110606">
  <cffile action="copy" source="#uploadFile#" destination="#uploadfolder##request.Company#-#dateformat(now(),"dd-mm-yyyy")#.bak" >
  
  

  <font color="#FF3300" size="-1">Your TMonline Data has been Back Up from this computer.</font><br />
  <cfoutput>
  <a href="ftp:../Backup/#request.Company#-#dateformat(now(),"dd-mm-yyyy")#.bak">Click here to download Back-Up File</a> 
  <a href="../index/index.cfm">Home</a>
  </cfoutput>
  
  <br> 
  <br>  
  <cfelse>
Wrong Company Code<br /><br />
<a href="DataBackUp.cfm">Try again</a> or Consult your System Administrator
</cfif>
</cfif>
</cfif>

</div>
</div>
</div>
</body>
</html>