package org.flashmonkey.mvcs.service.rest
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.as3commons.reflect.Field;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.write.WriteURLVariablesOperation;
	import org.flashmonkey.operations.service.IOperation;
	
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
			return context + "/" + model.noun.plural + service.format.toString();
		}
		
		public function UploadOperation(service:IRestService, model:IRestModel, uploadField:Field, dataFieldName:String, writeContext:WriteContext)
		{
			super(service, model, writeContext);
			
			_uploadField = uploadField;
			_dataFieldName = dataFieldName;
		}
		
		public override function execute():void
		{
			new WriteURLVariablesOperation(service, model, verb, writeContext).addCompleteListener(onURLVarsWritten).execute();

		}
		
		private function onURLVarsWritten(o:IOperation):void 
		//public override function execute():void
		{
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			
			trace("Adding the following data to the upload\n" + o.result);
			
			request.data = o.result;
			
			var uploadDataFieldName:String = model.noun.singular + '[' + _dataFieldName + ']';
			
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
			file.addEventListener(Event.COMPLETE, onUploadComplete, false, 0, true);
			file.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			
			/*file.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent):void {
				//_model.progress = e.bytesLoaded / e.bytesTotal;
			});*/
			
			file.upload(request, uploadDataFieldName);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			file.cancel();
			dispatchError(e.text);
		}	
		
		private function onUploadComplete(e:Event):void 
		{
			dispatchComplete();
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			file.cancel();
			dispatchError(e.text);
		}
		
		private function get file():FileReference
		{
			return FileReference(_uploadField.getValue(model));
		}
	}
}