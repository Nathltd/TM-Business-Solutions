<!DOCTYPE html>
<html >
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet"> 
<title><cfoutput>#request.title#</cfoutput></title>


<cfset id = RandRange(1,5, "SHA1PRNG")> 
<cfquery name="bg">
select imageid, image from frontpage
where imageid = '#id#'
</cfquery>



<style>
      body {
  font-family: 'Open Sans', sans-serif;
  height: 100vh;
  background: url("../image/<cfoutput>#bg.image#</cfoutput>") 50% fixed;
  background-size: cover;
}

@keyframes spinner {
  0% {
    transform: rotateZ(0deg);
  }
  100% {
    transform: rotateZ(359deg);
  }
}
* {
  box-sizing: border-box;
}

.wrapper {
	float: right;
  display: flex;
  align-items: center;
  flex-direction: column;
  justify-content: center;
  height: 100vh;
  width: 50%;
  margin: 0;
  padding: 0px;
  background: rgba(4, 40, 68, 0.3);
}
.wrapper2 {
	float: left;
	color: white;
	text-shadow: 3px 3px 1px rgba(0, 0, 0, 0.8);
	text-align: left;
	font-size: 24px;
  display: flex;
  align-items: center;
  flex-direction: column;
  justify-content: center;
	  height: 100vh;
  width: 50%;
  margin: 0;
  padding: 0px;
  background: rgba(4, 40, 68, 0.3);
}

.login {
  border-radius: 2px 2px 5px 5px;
  padding: 10px 20px 20px 20px;
  width: 90%;
  max-width: 320px;
  background: #ffffff;
  position: relative;
  padding-bottom: 80px;
  box-shadow: 0px 1px 5px rgba(0, 0, 0, 0.3);
}
.login.loading #login {
  max-height: 100%;
  padding-top: 50px;
}
.login.loading #login .spinner {
  opacity: 1;
  top: 40%;
}
.login.ok #login {
  background-color: #8bc34a;
}
.login.ok #login .spinner {
  border-radius: 0;
  border-top-color: transparent;
  border-right-color: transparent;
  height: 20px;
  animation: none;
  transform: rotateZ(-45deg);
}
.login input {
  display: block;
  padding: 15px 10px;
  margin-bottom: 10px;
  width: 100%;
  border: 1px solid #ddd;
  transition: border-width 0.2s ease;
  border-radius: 2px;
  color: #ccc;
}
.login input + i.fa {
  color: #fff;
  font-size: 1em;
  position: absolute;
  margin-top: -47px;
  opacity: 0;
  left: 0;
  transition: all 0.1s ease-in;
}
.login input:focus {
  outline: none;
  color: #444;
  border-color: #de5e21;
  border-left-width: 35px;
}
.login input:focus + i.fa {
  opacity: 1;
  left: 30px;
  transition: all 0.25s ease-out;
}
.login a {
  font-size: 0.8em;
  color: #de5e21;
  text-decoration: none;
}
.login .title {
  color: #444;
  font-size: 1.2em;
  font-weight: bold;
  margin: 10px 0 30px 0;
  border-bottom: 1px solid #eee;
  padding-bottom: 20px;
}
.login #login {
  width: 100%;
  height: 100%;
  padding: 10px 10px;
  background: #de5e21;
  color: #fff;
  display: block;
  border: none;
  margin-top: 20px;
  position: absolute;
  left: 0;
  bottom: 0;
  max-height: 60px;
  border: 0px solid rgba(0, 0, 0, 0.1);
  border-radius: 0 0 0px 0px;
  transform: rotateZ(0deg);
  transition: all 0.1s ease-out;
  border-bottom-width: 7px;
}
.login #login .spinner {
  display: block;
  width: 40px;
  height: 40px;
  position: absolute;
  border: 4px solid #ffffff;
  border-top-color: rgba(255, 255, 255, 0.3);
  border-radius: 100%;
  left: 50%;
  top: 0;
  opacity: 0;
  margin-left: -20px;
  margin-top: -20px;
  animation: spinner 0.6s infinite linear;
  transition: top 0.3s 0.3s ease, opacity 0.3s 0.3s ease, border-radius 0.3s ease;
  box-shadow: 0px 1px 0px rgba(0, 0, 0, 0.2);
}
.login:not(.loading) #login:hover {
  box-shadow: 0px 1px 3px #de5e21;
}
.login:not(.loading) button:focus {
  border-bottom-width: 4px;
}

footer {
  display: block;
  padding-top: 150px;
  text-align: center;
  color: #ddd;
  font-weight: normal;
  text-shadow: 0px -1px 0px rgba(0, 0, 0, 0.2);
  font-size: 0.8em;
	bottom: 0px;
}
footer a, footer a:link {
  color: #fff;
  text-decoration: none;
}

    </style>
<body>
<div class="wrapper2">
<ul>
	<li>Point Of Sales (POS)</li>
	<li>Multi-Location POS</li>
	<li>Dynamic Offline/Online Sync</li>
	<li>Stock Management</li>
	<li>Customers' Ledger</li>
	<li>Cash Flow/Bank Transactions</li>
	<li>Expenditures</li>
	<li>Secured Access Level</li>
	<li>Access from Any Device</li>
	<li>And More...</li>
	</ul>

</div>


<div class="wrapper">
  <cfform method="post" id="form" class="login">
    <p class="title">
		<img src="../shared/TMicon.ico"><br>
Log in</p>
    <input type="text" name="username" required="yes" message="Enter User ID" autocomplete="off" autosuggest="off" tabindex="1" placeholder="Username"/>
    <i class="fa fa-user"></i>
    <input type="password" name="password"  required="yes" message="Enter Password" autocomplete="off" tabindex="2" placeholder="pAssWorD" />
    <i class="fa fa-key"></i>
    <a href="#">Forgot your password?</a>
    <input type="submit" id="login" name="login" value="Login" class="state spinner">
    
  </cfform>
  </p>
</div>

<div align="center" id="footer"><a href="http://www.nathconcept.com"><cfoutput>#request.footer#</cfoutput></a></div>
</body>

</html>