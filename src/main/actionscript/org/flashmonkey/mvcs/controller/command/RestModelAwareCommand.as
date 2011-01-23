package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.controller.signal.Index;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.operations.service.IOperation;

	public class RestModelAwareCommand extends RestCommand
	{
		[Inject] public var restModel:IRestModel;
		
		[Inject] public var index:Index;
		
		private var $payload:*;
		
		protected function payload():*
		{
			return $payload;
		}
		
		public function RestModelAwareCommand()
		{
			super();
		}
		
		protected override function onReadComplete(o:IOperation):void 
		{	
			reIndex();
		}
		
		protected function reIndex():void 
		{
			index.dispatch(restModel.clazz);
		}
	}
}