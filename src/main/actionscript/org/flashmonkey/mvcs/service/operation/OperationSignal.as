package org.flashmonkey.mvcs.service.operation
{
	import org.osflash.signals.Signal;
	
	public class OperationSignal extends Signal
	{
		public function OperationSignal()
		{
			super(IOperation);
		}
	}
}