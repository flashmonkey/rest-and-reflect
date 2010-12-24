package org.flashmonkey.mvcs.service.rest
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.operation.IOperation;
	
	public class RestModelAwareOperation extends RestOperation
	{
		private var _model:IRestModel;
		
		protected function get model():IRestModel
		{
			return _model;
		}
		
		public override function get url():String
		{
			return context + "/" + _model.noun.plural + service.format.toString();
		}
		
		public function RestModelAwareOperation(service:IRestService, model:IRestModel)
		{
			super(service);
			
			_model = model;
		}
		
		public override function execute():void
		{
			service.write(_model, verb).addCompleteListener(onWriteComplete).execute();
		}
		
		private function onWriteComplete(o:IOperation):void 
		{
			request.data = o.result;
			
			super.execute();
		}
	}
}