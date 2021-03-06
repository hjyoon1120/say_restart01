<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../include/header.jsp"%>
<style>
.fileDrop {
  width: 80%;
  height: 100px;
  border: 1px dotted gray;
  background-color: lightslategrey;
  margin: auto;
  
}
</style>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Main content -->
	<section class="content">
		<!-- Premium row -->

		<div class="row">
			<div class="col-md-10">
				<!-- general form elements -->
				<div class="box box-primary">
					<!-- /.box-header -->
					<form id='registerForm' role="form" method="post">
						<div class='box-header with-border'>
							<div class='user-block'>
								<select name="plaza_title">
									<option value="TOPIC">TOPIC</option>
									<option value="SAYING">SAYING</option>
							  	</select>
								<input type="text" name='title' class="form-control" placeholder = "Input title">
							</div>
							<!-- /.user-block -->
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="form-group">
								<textarea class="form-control" name="body" rows="5"
									placeholder="What's on your mind?"></textarea>
							</div>
							
							<div class="form-group">
								<label for="exampleInputEmail1">File Drop Here</label>
								<div class="fileDrop"></div>
							</div>
						</div>
						<!-- /.box-body -->

						<div class="box-footer">
							<div>
								<hr>
							</div>

							<ul class="mailbox-attachments clearfix uploadedList"></ul>
							<button type="submit" class="btn btn-primary">Submit</button>
						</div>
						<!-- /.box-footer -->
					</form>

				</div>
				<!-- /.box -->
			</div>
			<!-- /.col -->
		</div>
		<!-- /.row -->

	</section>
	<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<script id="template" type="text/x-handlebars-template">
<li>
	<span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
	<div class="mailbox-attachment-info">
		<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
		<a href="{{img_src}}"
			class="btn btn-default btn-xn pull-right delbtn"><i class="fa fa-fw fa-remove"></i></a>
	</div>
</li>
</script>

<script>
	var template = Handlebars.compile($("#template").html());
	
	$(".fileDrop").on("dragenter dragover", function(event){
		event.preventDefault();
	});
	
	$(".fileDrop").on("drop", function(event){
		event.preventDefault();
		
		var files = event.originalEvent.dataTransfer.files;
		
		var file = files[0];
		
		var formData = new FormData();
		
		formData.append("file", file);
		
		$.ajax({
			url:'/uploadAjax',
			data: formData,
			dataType: 'text',
			processData : false,
			contentType : false,
			type: 'POST',
			success: function(data){
				var fileInfo = getFileInfo(data);
				var html = template(fileInfo);
				
				$(".uploadedList").append(html);
			}
		});
		
	});

	$("#registerForm").submit(function(event) {
		
		event.preventDefault();
		
		var that = $(this);
		
		var str = "";
		
		$(".uploadedList .delbtn").each(function(index) {
			
			str += "<input type='hidden' name='files[" + index
					+ "]' value='" + $(this).attr("href") + "'> ";
		});
		
		that.append(str);
		that.get(0).submit();
		
	});
	
	$(".uploadedList").on("click", ".delbtn", function(event){
		event.preventDefault();
		
		var that = $(this);
		
		$.ajax({
			url:"/deleteFile",
			type:"POST",
			data:{fileName:$(this).attr("href")},
			dataType:"text",
			success:function(result){
				if(result == 'deleted'){
					that.closest("li").remove();
				}
			}
		});
	});
</script>

<%@ include file="../include/footer.jsp"%>