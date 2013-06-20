
$(document).ready(function() {	
	//让折叠那货可以一开始就闭合着，也可以点击关闭 
	//alert($(this).index()/2);
	$('#accordion').accordion(
		 {collapsible: true,
		 active: false}
	); 

    $('.allLogout').bind('click',function(){
    	unitnr = $(this).parents('ul[unitnr]').attr('unitnr');
		$(this).parent().prevAll().each(function(index,e){
				$.post("./operation", {
					staffID : $(e).attr('staffnr'),
					entityID : unitnr,
					logType : "Logout"
				}, function(data) {
					if (data.flag){
						var temp = $('h3[unitnr="'+data.unit+'"]').find('label[staffnum]')
						$('li[staffnr='+data.staffnr+']').remove();
						temp.text(parseInt(temp.text())-1);
					}
				}, 'json');
		})
    })

	//点一个折叠的workingUnit，它的标题显示在左边去 
	$('#accordion>h3').bind('click',function(){
		document.getElementById('worku-title-show').innerHTML=$(this).children('p').text();
	})
	
	//下拉选择working unit
	// $('#ul li').bind("click", function() {
		// $('#accordion').accordion({active:$(this).index()});
		// var liContent = $.trim($(this).text());
		// document.getElementById('worku-title-show').innerHTML=liContent;
	// })
	
})
//生产线扫描完后敲回车
// function log_attendance(event) {
	// var e = event ? event : (window.event ? window.event : null);
	// document.getElementById("loginError").innerHTML = "";
	// if (e.keyCode == 13) {
		// var entity = document.getElementById("entityID");
		// //判断有没有输入值
		// if (entity.value) {
			// document.getElementById("staffID").focus();		
//            
// 			
// 			
		// } else {
			// document.getElementById("loginError").innerHTML = "Please input working unit";
			// var t = setTimeout("document.getElementById('loginError').innerHTML=''", 4000);
			// var loginError = document.getElementById('loginError');
		// }
	// }
// };
//生产线logout
// function logout() {
// $(".staffGroup").slideUp("slow");
// var entity = document.getElementById("entityID");
// entity.disabled = undefined;
// entity.value = "";
// $(".attendence-logout").addClass('hide');
// document.getElementById("entityID").focus();
// }

//点击log后光标focus在input
function logbtn_press() {
	var log = document.getElementById('log');
	log.innerHTML = (log.innerHTML == '登陆') ? '登出' : '登陆' ;
	document.getElementById("staffID").focus();
}

function state_control(e) {
	text = $.trim($(e).text());
	$.post("./control_workunit_state", {
		entityID : document.getElementById('worku-title-show').innerHTML,
		state : text,
		desc : ""
	}, function(data) {
		if (data.flag){
			if (data.changed){
				var temp = $('h3[unitnr="'+data.unit+'"]').find('label[unitstate]');
				temp.text(text);
			 	$('.state-change-info').removeClass('hide');
			 	var t = setTimeout("$('.state-change-info').addClass('hide');", 2000);
			}
		} else
			MessageBox(data.msg);
	}, 'json');
}

function squad_members(e) {
	$.post("./get_members", {
		group : $(e).attr("squadnr")
	}, function(data) {
		if (data.flag)
			$('#staff > div.modal-body').html(data.txt);
		else
			$('#staff > div.modal-body').html(data.msg);
	}, 'json');
}

function batch_login() {
	MessageBoxClear();
	$('.staff-choosen').each(function(index,e){
		$.post("./operation", {
			staffID : $(e).children('label[memnr]').text(),
			entityID : document.getElementById('worku-title-show').innerHTML,
			logType : document.getElementById('log').innerHTML
		}, function(data) {
			if (data.flag){
				var temp = $('h3[unitnr="'+data.unit+'"]').find('label[staffnum]')
				if (data.type == 'Login') {
					$('ul[unitnr="'+data.unit+'"]').prepend( $('<li staffnr='+data.staffnr+' >'+data.staffnr+' : '+data.staffname+'</li>') );
					temp.text(parseInt(temp.text())+1);
				} else {
					$('li[staffnr='+data.staffnr+']').remove();
					temp.text(parseInt(temp.text())-1);
				}
			} else
				MessageBoxAdd($(e).children('label[memnr]').text()+" : "+data.msg+"<br />");
		}, 'json');
	});
}

//员工号扫描完敲回车
function register_attendance(event) {
	var e = event ? event : (window.event ? window.event : null);
	var staff = document.getElementById('staffID');
	var result = document.getElementById('result');
	
	if (e.keyCode == 13) {
			//判断输入框中是否有值
			if (staff.value) {
				$.post("./operation", {
					staffID : staff.value,
					entityID : document.getElementById('worku-title-show').innerHTML,
					logType : document.getElementById('log').innerHTML
				}, function(data) {
					if (data.flag){
						var temp = $('h3[unitnr="'+data.unit+'"]').find('label[staffnum]')
						if (data.type == 'Login') {
							$('ul[unitnr="'+data.unit+'"]').prepend( $('<li staffnr='+data.staffnr+' >'+data.staffnr+' : '+data.staffname+'</li>') );
							temp.text(parseInt(temp.text())+1);
							$('#result').attr('class', 'text-success');
						} else {
							$('li[staffnr='+data.staffnr+']').remove();
							temp.text(parseInt(temp.text())-1);
							$('#result').attr('class', 'text-warning');
						}
					}
					result.innerHTML = data.msg;
				}, 'json');
				staff.value = "";
			} else {
				result.innerHTML = "Please input staff number.";
			}
	 
		var t = setTimeout("document.getElementById('result').innerHTML=''", 2000);
	}
}
