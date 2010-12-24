package org.flashmonkey.mvcs.controller.command
{
	import org.as3commons.lang.ClassUtils;
	import org.flashmonkey.mvcs.controller.signal.Index;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.service.operation.IOperation;

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
			index.dispatch(ClassUtils.forInstance(restModel));
		}
	}
}