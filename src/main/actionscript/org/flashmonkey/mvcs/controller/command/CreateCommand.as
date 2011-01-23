package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.operations.service.IOperation;
	
	public class CreateCommand extends RestModelAwareCommand
	{
		public override function get operation():IOperation
		{
			return service.create(restModel);
		}
		
		public function CreateCommand()
		{
			super();
		}
	}
}