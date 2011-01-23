package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.model.Noun;
	import org.flashmonkey.operations.service.IOperation;

	public class IndexCommand extends RestCommand
	{
		[Inject] public var clazz:Class;
		
		public override function get operation():IOperation
		{
			return service.index(clazz);
		}
		
		public function IndexCommand()
		{
			super();
		}
		
		protected override function onComplete(o:IOperation):void 
		{
			trace("Index Complete " + o.result);
			service.read(o.result, clazz).addCompleteListener(onReadComplete).addErrorListener(onError).execute();
		}
		
		protected override function onReadComplete(o:IOperation):void 
		{
			trace("The result is: " + o + " " + o.result);
			
			model.set(Noun.forClass(clazz).plural, o.result);
		}
	}
}