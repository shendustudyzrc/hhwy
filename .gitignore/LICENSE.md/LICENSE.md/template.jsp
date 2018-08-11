<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<link rel="shortcut icon" href="${config.base() }framework-webframe/style/images/fweblogo/fweblog-16.png" type="image/x-icon"/>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/easyui/validate_extend.js"></script>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/easyui/expand/fweb_form_control.js"></script>
	<script src="${config.path()}assets/js/jquery.form.min.js"></script>
<div class="hold-transition skin-green-light pace-done">
	<div class="col-md-10">
			<form id="ff" class="form-horizontal container-fluid">
			<div class="row">
			  	 <div class="form-group col-md-6" style="display:flex;">
			  	 <input  id="id" name="id"  class="textbox-radius">
				 <input id="templateKey"   name="templateKey" class="textbox-radius">
			  	</div> 
			  	 <div class="form-group col-md-6" style="display:flex;">
				    <input id="templateName"  name="templateName" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-6" style="display:flex;" >
				    <input id="tableName" name="tableName" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-12" style="display:flex;">
				  <input id="appendField"   name="appendField" class="textbox-radius"> 
			  	</div>
			  	<div class="form-group col-md-12" style="display:flex;">
				    <input id="appendName" name="appendName" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-12" style="display:flex;">
				    <input id="appendFieldSql"   name="appendFieldSql" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-12"  style="display:flex;">
				    <input id="combVel" name="combVel" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-12" style="display:flex;">
				    <input id="combVelSql"  name="combVelSql" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-6" style="display:flex;">
				    <input id="moreInsert" type="radio" name="moreInsert"  onclick="checkboxOnclick()" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-6" style="display:flex;" id="qualifiedDiv">
				    <input id="qualified"  name="qualified" class="textbox-radius">
			  	</div>
			  	<div class="form-group col-md-12" style="display:flex;" id="qualifiedDiv">
			  	   
                </div>
			    <div class="form-group col-md-6" style="display:flex;"> 
			  	    <input  id="templateTypeId"  name="templateTypeId" class="textbox-radius" value="${param.itemId}" readonly>
			  	    
			  	</div> 
			  	<div class="form-group col-md-6" style="display:flex;">
			    	<div class="col-sm-offset-2 col-sm-10">
			      		<a onclick="submitForm()" class="btn btn-primary">保存</a>
			      		<a onclick="clearForm()" class="btn btn-default">清空</a>
			      		<a onclick="cancelEdit()" class="btn btn-default">取消</a>
			    	</div>
			  	</div>
			  </div>
			</form>
	</div>  
<script>
	var basePath = '${config.path()}';
	var copy = '${param.copy}';
	function loadRemote(id_){
		$.ajax({
			url:basePath + "component/excel/template/"+id_,
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#ff').form('load', {
					id : data.id||'',
					templateKey:data.templateKey||'',
					templateName : data.templateName||'',
					tableName : data.tableName||'',
					appendName : data.appendName||'',
					appendField:data.appendField.toString()||'',
					moreInsert:data.moreInsert.toString()||'',
					appendFieldSql:data.appendFieldSql||'',
					combVel:data.combVel||'',
					combVelSql:data.combVelSql||'',
					qualified:data.qualified||'',
					templateTypeId:data.templateTypeId||''
				});
			     //对data.appendField.toString()进行分析，如果存在为真就传值进来，将后台中 的toString转化成前台对应的
				if(data.appendField.toString()){
					if(data.appendField.toString()==1){
						var s=data.appendField.toString();
						var s1=s.replace("1","是"); 
						$('#appendField').fwebformcontrol('setValueTest',data.appendField.toString());
					}
					if(data.appendField.toString()==0){
						$('#appendField').fwebformcontrol('setValueTest',data.appendField.toString()); 
					}
				}; 
				 if(data.moreInsert.toString()){
					$('#moreInsert').fwebformcontrol('setValueTest',data.moreInsert.toString());} 
			},
			error : function(xhr) {
				 $.gritter.add({  
				    text: '获取用户信息失败',  
				    sticky: false,  
				    time: 3000,
				    speed:500,  
				    class_name: 'gritter-error'  
				}); 
			}
		});
	}
	//清除表单内容时，把templateTypeId留下来
	function clearForm(){
		var a=$("#templateTypeId").val();
		$('#ff').form('clear'); 
		 $("#templateTypeId").combobox({
			  required:true,
			  editable:false,
			  valueField:'mno',
			  textField:'mname'
		  });  
		 $("#templateTypeId").combobox('setValue',a); 
	}
	//提交表单内容
	function submitForm(){
		$('#ff').form('submit',{
			onSubmit:function(){
				var isValidatePass = $(this).form('enableValidation').form('validate');
				if(isValidatePass){	
					var data = $("#ff").serializeObject();
					var requestType = "post";
				    if("${param.id}" && copy != 'true'){
						data.id = "${param.id}";
						requestType = "put";
					}  
					$.ajax({
						url:basePath + "component/excel/template",
						type : requestType,
						async : false,
						data : $.toJSON(data),
						contentType : 'application/json;charset=UTF-8',
						success : function(data) {
							$.gritter.add({  
							    text: '保存成功',  
							    sticky: false,  
							    time: 3000,
							    speed:500,  
							    class_name: 'gritter-success'  
							});
						 	 crumbs.goback({isRefresh:true});  
						},
						error : function(xhr) {
							$.gritter.add({  
							    text: '保存失败',  
							    sticky: false,  
							    time: 3000,
							    speed:500,  
							    class_name: 'gritter-error'  
							});
						}
					});
				}
				return false;
			}
		});
	}
	
	$(function(){
		$('#templateKey').fwebformcontrol({
			label: '模板Key值:',
			labelWidth: 200,
		    required: false,    
		    showSeconds: true,
		    prompt: '请输入模板Key值'
		});
		$('#templateName').fwebformcontrol({
			label: '模板名称:',
			labelWidth: 200,
			required: true,
			missingMessage: '模板名称不能为空',
			prompt: '请输入模板名称'
		});
		 $('#tableName').fwebformcontrol({
			label: '模板表名:',
			labelWidth: 200,
		    required: true,
		    missingMessage: '模板表名不能为空',
			prompt: '请输入模板表名'
		});
		
		$('#appendField').fwebformcontrol({
			label: '附加参数:',
			labelWidth: 200,
			 data: [{
			    	label: '有效',
			    	value: '1',
			    	checked: true 
			    },{
			    	label: '失效',
			    	value: '0',
			    	checked: false
			    }],
			    controlType: 'radiobox'
		});
		$('#appendName').fwebformcontrol({
			label: '附加属性:',
			labelWidth: 200,
		    required: false,
		    missingMessage: '附加属性不能为空',
				prompt: '请输入附加属性'
		});
		$('#appendFieldSql').fwebformcontrol({
			label: '附加sql语句:',
			labelWidth: 200,
		    required: false,    
		    showSeconds: true,
		    prompt: '输入附加sql语句',
		});
		$('#combVel').fwebformcontrol({
			label: '多列组合唯一性校验:',
			labelWidth: 200,
		    required: false,
		    missingMessage: '多列组合唯一性不能为空',
			prompt: '列序号之间用，号隔开如1,2'
		});
		$('#combVelSql').fwebformcontrol({
			label: '多列组合校验SQL语句:',
			labelWidth: 200,
		    required: false,    
		    showSeconds: true,
		    prompt: '如果需要到数据库校验则必须书写，留空为不到数据库校验，文本域'
		});
		$('#moreInsert').fwebformcontrol({
			label: '需要多表插入数据:',
			labelWidth: 200,
			 data: [{
			    	label: '有效',
			    	value: '1',
			    	checked: true
			       },{
			    	label: '失效',
			    	value: '0',
			    	checked: false
			       }],
			controlType: 'radiobox'
		});
		$('#qualified').fwebformcontrol({
			label: '处理多表插入的类:',
			labelWidth: 200,
		    required: false,    
		    showSeconds: true,
		    prompt: '请输入请输入相关类'
		}); 
		if("${param.id}"){
			loadRemote("${param.id}");
		}
	})
	
	function cancelEdit(){
		crumbs.goback();
	}
	$(document).ready(function(){
		  $('input:radio').change(function(){
			  if($("#moreInsert").val()==1){
					$("#qualifiedDiv").show();
				}else{
					$("#qualifiedDiv").hide();
				}
		  });
	 });
</script>
</div>
