<html>
<head>
	<title></title>
	
	<style type="text/css">
		body 			{ font-family: arial,verdana,helvetica; font-size:12px; }
		a, a:visited 	{ color:blue; }
		
		.activeLink		{ font-weight:bold; text-decoration:none; }
		
		#teams, #players{ float:left; width:160px; display:none; }
		#teamList		{ display:none; }
		#players 		{ border-left:1px solid #CCC; padding-left:12px; }
		ul 				{ margin:0; padding-left:16px; }
		li 				{ margin:0; padding:0; }
	</style>
		
<link rel="stylesheet" type="text/css" href="../googleJquery-ui.css"/>
<script src="googleJquery-min.js" type="text/javascript" charset="utf-8"></script>
  <script src="googleJquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">	
			$(document).ready(function(){
				$('#showteams').click(function() {
					$.getJSON('QtyCheck.cfc?method=getAllCategory&returnformat=JSON&queryformat=column',
					function(data) {
						$.each(data.DATA.CATEGORYID, function(i,categoryId){
							$('#teamList').append('<li><a href="#">' + categoryId + '</a>');
						});
				});
				$('#teams').show();
				$('#teamList').fadeIn(1200);
				$(this).attr('disabled', 'disabled');
			});
	
			$('#teamList li a').live('mouseover', function() {
				$('#players').show();
				$('#teamList li a').removeClass('activeLink');
				$(this)
					.addClass('activeLink')
					.blur();
				$('#playerList')
					.hide()
					.empty()
				$.getJSON('tm001.cfc?method=getcategoryDetails&returnformat=JSON&queryformat=column&category=' + $(this).text(),
					function(data) {
						$('#players p').text(data.DATA.CATEGORYID[0] + ' Products');
						
						$.each(data.DATA.PRODUCTID, function(i,productId){
							var description = data.DATA.DESCRIPTION[i];

							$('#playerList').append('<li title=' + description + '>' + productId + '</li>')
							
						});
				});
				$('#playerList').fadeIn(1000);
				return false;
			});
		});
	</script>
</head>

<body>
<div style="clear:both;">
	<input type="button" id="showteams" value="Show Categories" />
</div>

<div id="teams">
	<p>Categories</p>
	<ul id="teamList">
	
	</ul>
</div>

<div id="players">
	<p></p>
	<ul id="playerList">
	
	</ul>
</div>

</body>
<cfoutput></cfoutput>
</html>
