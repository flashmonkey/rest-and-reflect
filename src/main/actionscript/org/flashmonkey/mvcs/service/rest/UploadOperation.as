package org.flashmonkey.mvcs.service.rest
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.as3commons.reflect.Field;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.operation.IOperation;
	import org.flashmonkey.mvcs.service.write.WriteURLVariablesOperation;
	
	public class UploadOperation extends RestModelAwareOperation
	{
		private var _uploadField:Field;
		
		private var _dataFieldName:String;
		
		public override function get verb():Verb
		{
			return Verb.POST;
		}
		
		public override function get url():String
		{
			return context + "/" + model.noun.plural + "/upload" + service.format.toString();
		}
		
		public function UploadOperation(service:IRestService, model:IRestModel, uploadField:Field, dataFieldName:String)
		{
			super(service, model);
			
			_uploadField = uploadField;
			_dataFieldName = dataFieldName;
		}
		
		public override function execute():void
		{
			new WriteURLVariablesOperation(model, verb).addCompleteListener(onURLVarsWritten).execute();

		}
		
		private function onURLVarsWritten(o:IOperation):void 
		{
			var file:FileReference = FileReference(_uploadField.getValue(model));
					
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			
			request.data = o.result;
			
			var uploadDataFieldName:String = model.noun.singular + '[' + _dataFieldName + ']';
			
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
				file.cancel();
				dispatchError(e.text);
			}, false, 0, true);
			
			file.addEventListener(Event.COMPLETE, function(e:Event):void {
				dispatchComplete();
			}, false, 0, true);
			
			/*file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, function(e:Event):void {
				trace("Data Upload Complete");
				dispatchComplete();
			});*/
			
			file.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
				file.cancel();
				dispatchError(e.text);
			}, false, 0, true);
			
			file.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent):void {
				//_model.progress = e.bytesLoaded / e.bytesTotal;
			});
			
			file.upload(request, uploadDataFieldName);
		}
	}
}