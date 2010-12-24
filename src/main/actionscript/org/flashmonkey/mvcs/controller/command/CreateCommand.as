package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.operation.IOperation;
	
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