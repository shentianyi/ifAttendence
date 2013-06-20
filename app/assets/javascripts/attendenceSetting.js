$(document).ready(function() {
	$('#accordion').accordion({
		collapsible : true,
		active : 0,
		 heightStyle: "content"
	});
	 // init draggable element
    // due to every created draggable  element have the same attributes,
    // make it a function
    initDraggable("#accordion li");

    // init accept element
    // using customer attr
    $("h3[staff-drag-group='draggable']").droppable({
         accept : ":not(.ui-sortable-helper)",
         drop : function(event, ui) {
              // if same group?
              if($(this).attr("staff-group-id") != ui.draggable.parents(".group-container").prev().attr("staff-group-id")) {
                   // create new element
                   var li = $("<li/>");
                   // make it draggable
                   initDraggable(li);
                   // append the elements
                   $(this).next().find("ul").append(li.html(ui.draggable.html()));
                  
                   ui.draggable.parents(".group-container").prev().find("p > label[num]").text((ui.draggable.parent().find("li").size()-1));
                   
					$.post("./add_members", {
						group : $(this).attr("staff-group-id"),
						mem : ui.draggable.attr("memnr")
					}, function(data) {
						if (data.flag)
							;
						else
							window.location.reload();
					}, 'json');
					
                    $(this).find("p > label[num]").text($(this).next().find("ul li").size())
                    // remove old element
                    ui.draggable.remove();
              }
         }
    });
  
       //为每一个删除按钮绑定事件
   $(".setting-delete-btn").bind('click',function(event){
   	 		event.stopPropagation();
   	 		var obj = $(this).parent();
			$.post("./delete_squad", {
				group : $(this).parent().attr("staff-group-id")
			}, function(data) {
				if (data.flag){
		           $(obj).next().fadeOut();
		           $(obj).fadeOut();
				} else
					MessageBox(data.msg);
			}, 'json');
   }) 

});


function initDraggable(ele) {
        $(ele).draggable({
             appendTo : "body",
             helper : "clone"
        });
};

function settingBtnEdit(){
       	var edit=document.getElementById('setting-edit-btn');
       	var obj=$(edit);
       	$(".setting-delete-btn").toggleClass('hide ');          	
       	$("#setting-add-btn").toggleClass('hide');
       	$("#setting-edit-btn").toggleClass('setting-done-btn');
       	if(edit.innerHTML==obj.attr("labedit"))
    	   	edit.innerHTML=obj.attr("labdone");
       	else
	       	edit.innerHTML=obj.attr("labedit");
};
function addpop(){
	$('.addpop').toggleClass('hide');
}
function closepop(){
	$('.addpop').toggleClass('hide');
}

function add_group(o) {
	$.post("./create_squad", {
		name : $(o).prev().val()
	}, function(data) {
		if (data.flag)
			window.location.reload();
		else
			MessageBox(data.msg);
	}, 'json');
}
    
