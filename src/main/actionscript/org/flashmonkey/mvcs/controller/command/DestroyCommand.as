package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.service.operation.IOperation;
	
	public class DestroyCommand extends RestModelAwareCommand
	{
		public override function get operation():IOperation
		{
			return service.destroy(restModel);
		}
		
		public function DestroyCommand()
		{
			super();
		}
	}
}