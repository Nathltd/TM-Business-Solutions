// JavaScript Document for TM Online 2.xx
$(document).ready(function(){

	// $('table').css('width', '90%');

	$('body,td,th,a,table').css({
		'font-family':'"Open Sans", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", "Verdana", "sans-serif"',
		'font-size': '13px',
		'text-decoration':'none'
		});		
	$('.finYear').css({
		'float':'right',
		'text-transform': 'capitalize',
		'font-size':'10px'
		});
	$('.logged').css({
		'float':'right',
		'position': 'absolute',
		'text-transform': 'capitalize',
		'font-size':'10px'
		});
	$('.logged a').css({
		'text-decoration':'none'
		});
	$('.logged #linkd').css({
		'color':'#F00',
		'font-size':'10px'
		});
	$('input,textarea,select').css({
		'font-size':'100%',
		'display':'block',
		'border':'1px solid #999',
		'-webkit-box-shadow':'0px 0px 8px rgba(0, 0, 0, 0.3)',
		'-moz-box-shadow':'0px 0px 8px rgba(0, 0, 0, 0.3)',
		'box-shadow':'0px 0px 8px rgba(0, 0, 0, 0.3)',
		'border-radius': '4px'
		})
		.attr('autocomplete', 'off');
	$('textarea,input,select')
		.hover(function(){
			$(this).css('transform','scale(1.0.5,1.0.5)');
			},function(){
			$(this).css('transform','scale(1,1)');
			});
	$('textarea,input,select')
		.focus(function(){
			$(this).css({
				'border':'2px solid #09C',
				'background': '#FFFFC6'
			});
			})
		.blur(function(){
			$(this).css({
				'border':'1px solid #999',
				'background': '#FFF'
				});
			});
	$('h4').css({
		'color':'#FFF',
		'background-color':'#06C',
		'background-repeat':'repeat-x',
		'display': 'block',
		'text-align':'left',
		'font-family':'"Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", "Verdana", "sans-serif"',
		'font-size':'120%',
		'padding-top':'5px',
		'padding-right':'5px',
		'padding-bottom':'5px',
		'padding-left':'15px',
		'text-shadow':'3px 3px 1px rgba(0, 0, 0, 0.8)',
		'border-top-left-radius':'5px',
		'border-top-right-radius':'5px',
		'border-bottom-right-radius':'5px',
		'border-bottom-left-radius':'15px',
		'margin-left':'10px',
		'margin-right':'10px'
		});
	$('#RightColumn').css({
		'border-top-style':'solid',
		'border-right-style':'solid',
		'border-bottom-style':'solid',
		'border-left-style':'solid',
		'border-top-color':'#333',
		'border-right-color':'#333',
		'border-bottom-color':'#333',
		'border-left-color':'#333',
		'width':'90%',
		'border-top-left-radius':'5px',
		'border-top-right-radius':'5px',
		'border-bottom-right-radius':'5px',
		'border-bottom-left-radius':'5px',
		'position':'relative',
		'padding':'0%',
		'margin-bottom':'10px',
		'padding-top':'5px',
		'padding-bottom':'10px',
		'background':'#FFF'
	});
	$('#footer a').css({
		'position': 'relative',
		'right': '0',
		'bottom': '0',
		'left': '0',
		'padding': '1rem',
		'color': '#000000',
		'font-size': '10px',
		'text-align': 'center'
	});

	$('#outerlayout').css({
		'width':'80%'
	});

	$('#stockCheck').css({
		'width':'25%',
		'height':'30%',
		'background-color':'rgba(0,102,204,1)',
		'color':'#FFF',
		'text-shadow':'3px 3px 1px rgba(0, 0, 0, 0.9)',
		'border-radius':'10px',
		'position':'absolute',
		'top':'0',
		'bottom':'0',
		'left':'0',
		'right':'0',
		'margin':'auto',
		'z-index':'3'
	});
	$('#mainMenu').css({
		'width':'70%',
		'color': '#F00',

	});
	$('#mainMenu2').css({
		'background': '#06C'
	});
	$('#title').css({
		'color':'#0000FF',
		'face':'Segoe UI',
		'font-weight':'bolder',
		'font-size':'26px'
	});
	$('.datePicker').css({
		'width':'70%',
		'color':'#0000FF'
	});
	
	
});