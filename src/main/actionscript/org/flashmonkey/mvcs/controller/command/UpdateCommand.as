package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.service.rest.WriteContext;
	import org.flashmonkey.operations.service.IOperation;

	public class UpdateCommand extends RestModelAwareCommand
	{
		[Inject] public var writeContext:WriteContext;
		
		public override function get operation():IOperation
		{
			return service.update(restModel, writeContext);
		}
		
		public function UpdateCommand()
		{
			super();
		}
	}
}