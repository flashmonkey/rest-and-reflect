package org.flashmonkey.mvcs.model
{
	import org.osflash.signals.Signal;

	public interface ISignalBus
	{
		function get(name:String):Signal;
		
		function set(name:String, signal:Signal):void;
	}
}