package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.operations.service.IOperation;

	public class ShowCommand extends RestModelAwareCommand
	{
		public override function get operation():IOperation
		{
			return service.show(restModel);
		}
		
		public function ShowCommand()
		{
			super();
		}
	}
}