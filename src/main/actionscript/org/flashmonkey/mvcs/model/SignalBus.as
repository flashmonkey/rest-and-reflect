package org.flashmonkey.mvcs.model
{
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.lang.HashArray;
	import org.osflash.signals.Signal;
	
	public class SignalBus implements ISignalBus
	{
		private var $signals:IMap = new Map();
		
		public function SignalBus()
		{
		}
		
		public function get(name:String):Signal
		{
			return $signals.itemFor(name);
		}
		
		public function set(name:String, signal:Signal):void
		{
			if (!$signals.hasKey(name))
			{
				$signals.add(name, signal);
			}
		}
	}
}