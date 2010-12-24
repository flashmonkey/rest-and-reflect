package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.model.Noun;
	import org.flashmonkey.mvcs.service.operation.IOperation;

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
		
		protected override function onReadComplete(o:IOperation):void 
		{
			trace("The result is: " + o.result);
			
			model.set(Noun.forClass(clazz).plural, o.result);
		}
	}
}