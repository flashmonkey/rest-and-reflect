package org.flashmonkey.mvcs.controller.signal
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.osflash.signals.Signal;
	
	public class Create extends Signal
	{
		public function Create()
		{
			super(IRestModel);
		}
	}
}