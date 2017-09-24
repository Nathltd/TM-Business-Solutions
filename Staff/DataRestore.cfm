<!doctype html>
<html>
<head>
<title><cfoutput>Data Restore :: #request.title#</cfoutput></title>
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
<h4>Data Restore Wizard</h4>
<div id="RightColumn">
<cfif #GetUserRoles()# is  'Cashier'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Accountant'>
<h1> Unauthrised Zone </h1>
<cfelseif #GetUserRoles()# is  'Sales Rep'>
<h1> Unauthrised Zone </h1>
<cfelse>


<cfset uploadFile = "#expandpath("/")##request.db#TM001.mdb">
<cfset uploadfolder = "#expandpath("/")##request.db#">
<cfset fileObj = createObject("java","java.io.File") >
<cfset systemRoots = fileObj.listRoots() >
<cfset lastDrive = #arrayLen(systemRoots)#>

    
    <cfif isdefined ("form.InsertIt")> 
<!---    <cffile action="delete" file="#systemRoots[lastDrive]#TMonline.bak"><br />--->

  <p align="center"><font color="#FF3300" size="-1">Your TMonline Data has been restored to this computer.</font><br> 
  <br />
  <a href="../index/index.cfm">Home</a>
  <br>
   </p> 
<cfabort>

</cfif> 

    <cfif isdefined ("form.image1")> 
         
  <cfelse> 
  <cfif isdefined("form.Cancel")>
    <cffile action="rename" source="#uploadfolder#TMonline.bak" destination="#uploadfolder#TM001.mdb">
    </cfif>
  <cfform action="#cgi.SCRIPT_NAME#" method="post" enctype="multipart/form-data" preservedata="no" name="upload_form" id="upload_form" ><br />
 <div align="center">
 <p>Insert your USB Flash Drive.
Enter the Data Code and browse to the Data File to restore from</p>
    <table width="208" border="0" align="center" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF"> 
      <tr> 
        <td width="68" align="right"> Data Code: </td>
        <td width="120" align="right"><div align="left">
          <cfinput type="password" name="ItemCode" id="ItemCode" size="6" class="bold_10pt_black" autosuggest="off" required="yes" message="Enter Data Code" />
          </div></td>
      </tr> 
       <tr>
         <td align="right"><div align="left">Source:</div></td>
         <td align="right"><div align="left">
           <cfinput type="file" name="Image1" id="Image1" value="noImage" class="bold_10pt_black"/>
         </div></td>
         </tr>
       <tr> 
        <td align="right">&nbsp;</td>
        <td align="right"><div align="right">
          <cfinput name="upload_now" type="submit" value="Restore" class="bold_10pt_Button" />
        </div></td>
         </tr> 
    </table> 
    </div>
  </cfform>  
</cfif>
<cfif isdefined("form.upLoad_now")> 
	<cfif #form.ItemCode# is "20110606">
  <cfif isdefined("form.Image1")>
  <cffile action="copy" source="#uploadfolder#TM001.mdb" destination="#uploadfolder#TMonline.bak" nameconflict="makeunique">
    <cffile action="upload" filefield="Image1" destination="#uploadFile#" nameconflict="overwrite" > 
    
  </cfif> 
  <br> 
  <br> 
  <p align="center">Click the confirm button to Restore</p> 
  <table width="250" border="0" align="center" cellpadding="6" cellspacing="0"> 
    <tr valign="top"> 
      <td></td> 
      <td align="center"><cfoutput> 
          <form action="#cgi.SCRIPT_NAME#" method="post"> 
              <br> 
              <br> 
              <input type="submit" name="InsertIt" value="Confirm"> 
              <input type="submit" name="Cancel" value="Cancel">
              <input name="Image" type="hidden" value="#file.ServerFile#">
              <input name="Item" type="hidden" value="#form.itemCode#">
              </form> 
        </cfoutput> 
</td> 
    </tr> 
  </table> 
  <cfelse>
  <cfoutput>
Wrong Company Code<br /><br />
<a href="#cgi.SCRIPT_NAME#">Try again</a> or Consult your System Administrator
</cfoutput>
</cfif>
</cfif> 
</cfif>

</div>
</div>
</div>
</body>
</html>