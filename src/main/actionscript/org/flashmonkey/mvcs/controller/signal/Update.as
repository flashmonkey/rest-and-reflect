package org.flashmonkey.mvcs.controller.signal
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.service.rest.WriteContext;
	import org.osflash.signals.Signal;
	
	public class Update extends Signal
	{
		public function Update()
		{
			super(IRestModel, WriteContext);
		}
	}
}