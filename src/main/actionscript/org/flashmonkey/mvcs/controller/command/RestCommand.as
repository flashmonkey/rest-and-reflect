package org.flashmonkey.mvcs.controller.command
{
	import mx.controls.Alert;
	import mx.states.OverrideBase;
	
	import org.flashmonkey.mvcs.model.IModel;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.operations.service.IOperation;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class RestCommand extends SignalCommand
	{
		[Inject] public var model:IModel;
		
		[Inject] public var service:IRestService;
		
		public function get operation():IOperation
		{
			return null;
		}
		
		public function RestCommand()
		{
			super();
		}
		
		protected function onComplete(o:IOperation):void 
		{
			if (o.result)
			{
				service.read(o.result).addCompleteListener(onReadComplete).addErrorListener(onError).execute();
			}
		}
		
		protected function onReadComplete(o:IOperation):void 
		{
			trace("The result is: " + o.result);
		}
		
		public override function execute():void
		{
			operation.addCompleteListener(onComplete).addErrorListener(onError).execute();
		}
		
		protected function onError(o:IOperation):void 
		{
			Alert.show("There was an Error", "OOPS!");
		}
	}
}