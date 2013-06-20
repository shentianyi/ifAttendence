// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

//=require jquery-1.9.1.min
//=require jquery-ui-1.10.2.custom.min
//=require bootstrap.min


//= require_self

/////////////////////////////////////////////////////////////    MessageBox
function MessageBox(str) {
	$('#MessageBox > p').html(str).parent().show();
}


function MessageBoxClear() {
	$('#MessageBox > p').html("");
}
function MessageBoxAdd(str) {
	$('#MessageBox > p').html(  $('#MessageBox > p').html()+str  ).parent().show();
}

$(function() {
	$('#MessageBox > button').click(function() {
		$(this).parent().hide();
	})
})



/////////////////////////////////////////////////////////////    upload   file
function initial_uploader(idStr) {
	var vali = true;
	var lock = false;
	var fileReg = /(\.|\/)(xls|xlsx)$/i;
	$(idStr).fileupload({
		singleFileUploads : false,
		acceptFileTypes : fileReg,
		dataType : 'json',
		change : function(e, data) {
			vali = true;
			$(idStr + '-preview').html('');
			$.each(data.files, function(index, file) {
				var msg = "上传中 ... ...";
				if (!fileReg.test(file.name)) {
					msg = '格式错误';
					vali = false;
				}
				$(idStr + '-preview').show().append("<span>文件：" + file.name + "</span><br/><span info>处理：" + msg + "</span>");
			});
		},
		add : function(e, data) {
			if (vali)
				if (data.submit != null)
					data.submit();
		},
		beforeSend : function(xhr) {
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
		},
		success : function(data) {
			$(idStr + '-preview > span[info]').html("处理：" + data.msg);
		},
		done : function(e, data) {
			// data.context.text('Upload finished.');
		}
	});
}