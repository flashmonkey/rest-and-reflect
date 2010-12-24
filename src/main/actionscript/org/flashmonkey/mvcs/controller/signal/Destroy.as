package org.flashmonkey.mvcs.controller.signal
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.osflash.signals.Signal;
	
	public class Destroy extends Signal
	{
		public function Destroy()
		{
			super(IRestModel);
		}
	}
}