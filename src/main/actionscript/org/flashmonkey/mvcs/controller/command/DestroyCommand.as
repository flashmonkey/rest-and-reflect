package org.flashmonkey.mvcs.controller.command
{
	import org.flashmonkey.operations.service.IOperation;
	
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
		
		/**
		 * The destroy operation receives only the 200 (OK) response when successful.
		 * So we have to override the default behaviour (reading the response body) because
		 * there is no response body, so we'd either get a runtime error or some equally 
		 * unwelcome funkiness.
		 */
		protected override function onComplete(o:IOperation):void 
		{
			reIndex();
		}
	}
}