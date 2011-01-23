package org.flashmonkey.mvcs.model
{
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	public class Model implements IModel
	{
		[Inject] public var signalBus:ISignalBus;
		
		private var $properties:IMap = new Map();
		
		public function Model()
		{
		}
		
		public function set(name:String, value:*):void
		{
			trace("SETTING " + name + " == " + value);
			
			if (!$properties.hasKey(name))
			{
				$properties.add(name, value);
			}
			else
			{
				$properties.replaceFor(name, value);
			}
			trace("dispatching: " + name);
			signalBus.get(name).dispatch(value);
		}
		
		public function get(name:String):*
		{
			return $properties.itemFor(name);
		}
	}
}