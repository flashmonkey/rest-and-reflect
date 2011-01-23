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
		
		private var _serviceContext:ServiceContext;
		
		protected function get serviceContext():ServiceContext
		{
			return _serviceContext;
		}
		
		public override function get url():String
		{
			return context + "/" + _model.noun.plural + service.format.toString();
		}
		
		public function RestModelAwareOperation(service:IRestService, model:IRestModel, serviceContext:ServiceContext)
		{
			super(service);
			
			_model = model;
			_serviceContext = serviceContext;
		}
		
		public override function execute():void
		{
			service.write(_model, verb, _serviceContext).addCompleteListener(onWriteComplete).execute();
		}
		
		private function onWriteComplete(o:IOperation):void 
		{
			request.data = o.result;
			
			super.execute();
		}
	}
}