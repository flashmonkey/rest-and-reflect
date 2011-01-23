package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.mvcs.service.rest.ServiceContext;
	import org.flashmonkey.operations.service.IOperation;

	public class UpdateCommand extends RestModelAwareCommand
	{
		[Inject] public var serviceContext:ServiceContext;
		
		public override function get operation():IOperation
		{
			return service.update(restModel, serviceContext);
		}
		
		public function UpdateCommand()
		{
			super();
		}
	}
}