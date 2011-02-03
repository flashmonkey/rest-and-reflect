package org.flashmonkey.mvcs.service.rest
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.operations.service.IOperation;
	
	public class RestModelAwareOperation extends RestOperation
	{
		private var _model:IRestModel;
		
		protected function get model():IRestModel
		{
			return _model;
		}
		
		private var _writeContext:WriteContext;
		
		protected function get writeContext():WriteContext
		{
			return _writeContext;
		}
		
		public override function get url():String
		{
			return context + "/" + _model.noun.plural + service.format.toString();
		}
		
		public function RestModelAwareOperation(service:IRestService, model:IRestModel, writeContext:WriteContext)
		{
			super(service);
			
			_model = model;
			_writeContext = writeContext;
		}
		
		public override function execute():void
		{
			service.write(_model, verb, _writeContext).addCompleteListener(onWriteComplete).execute();
		}
		
		private function onWriteComplete(o:IOperation):void 
		{
			request.data = o.result;
			
			super.execute();
		}
	}
}