<!doctype html>
<html>
<head>
<title><cfoutput> #request.title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../googleJquery-min.js"></script>
<link href="../googleJquery-ui.css" rel="stylesheet" type="text/css">
<script src="../googleJquery-min.js"></script>
<script src="../style.js"></script>
</head>

<body>


<div align="center">

<cfinclude template="../shared/AllMenu.cfm">
<div class="mainBody"><br />
<br /><br />

<cfif #GetUserRoles()# is "Administrator">
<cfinclude template="IndexReport.cfm">
<cfelseif #GetUserRoles()# is "Alpha">
<cfinclude template="IndexReport.cfm">
<cfelseif #GetUserRoles()# is "Manager">
<cfinclude template="IndexReport.cfm">
<cfelseif #GetUserRoles()# is "Accountant">
<cfinclude template="IndexReport.cfm">
<cfelse>

  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="466" height="350" id="FlashID" title="TM Banner">
    <param name="movie" value="../shared/TMwebAd.swf" />
    <param name="quality" value="high" />
    <param name="wmode" value="opaque" />
    <param name="swfversion" value="6.0.65.0" />
    <!-- This param tag prompts users with Flash Player 6.0 r65 and higher to download the latest version of Flash Player. Delete it if you don’t want users to see the prompt. -->
    <param name="expressinstall" value="../Scripts/expressInstall.swf" />
    <!-- Next object tag is for non-IE browsers. So hide it from IE using IECC. -->
    <!--[if !IE]>-->
    <object type="application/x-shockwave-flash" data="../shared/TMwebAd.swf" width="466" height="350">
      <!--<![endif]-->
      <param name="quality" value="high" />
      <param name="wmode" value="opaque" />
      <param name="swfversion" value="6.0.65.0" />
      <param name="expressinstall" value="../Scripts/expressInstall.swf" />
      <!-- The browser displays the following alternative content for users with Flash Player 6.0 and older. -->
      <div>
        <h4>Content on this page requires a newer version of Adobe Flash Player.</h4>
        
      </div>
      <!--[if !IE]>-->
    </object>
    <!--<![endif]-->
  </object>
</div>
</div>
<script type="text/javascript">
<!--
swfobject.registerObject("FlashID");
//-->
</script>
</cfif>
<br />
<br />
<p>
<div align="center" id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</p>
</body>
</html>