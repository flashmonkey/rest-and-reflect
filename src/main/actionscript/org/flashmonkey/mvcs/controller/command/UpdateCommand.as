package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.service.operation.IOperation;

	public class UpdateCommand extends RestModelAwareCommand
	{
		public override function get operation():IOperation
		{
			return service.update(restModel);
		}
		
		public function UpdateCommand()
		{
			super();
		}
	}
}