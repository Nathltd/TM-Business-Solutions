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
<img src="../TMlogoSmall.jpg" />
<div id="Content">
<h4>Invalid Entry </h4>
<div id="RightColumn">
    
<cfform method="post">

<label>Invalid Entry. Try again</label><br />
<table cellpadding="5">
    <tr>
    <td align="right">User ID:</td>
    <td align="left"><cfinput type="text" name="username" required="yes" class="bold_10pt_black" message="Enter User ID" autosuggest="no"></td>
    </tr>
    <tr>
    <td align="right">Password:</td>
    <td align="left"><cfinput type="password" name="password"  required="yes" class="bold_10pt_black" message="Enter Password"  autosuggest="no" placeholder="Case Sensitive">
		</td>
        </tr>
        <tr>
        <td align="right">&nbsp;</td>
        <td align="right"><div align="right"><cfinput type="submit" name="login" value="Login" class="bold_10pt_Button"></div></td>
        </tr>
        </table>
    </cfform>
    </div>
    <div align="center" id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
    </div>
    </div>
    </body>
    </html>