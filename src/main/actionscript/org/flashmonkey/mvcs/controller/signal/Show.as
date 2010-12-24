package org.flashmonkey.mvcs.controller.signal
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.osflash.signals.Signal;
	
	public class Show extends Signal
	{
		public function Show()
		{
			super(IRestModel);
		}
	}
}