package org.flashmonkey.mvcs.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Bindable][RemoteClass] public class RestModel extends EventDispatcher implements IRestModel
	{
		private var $noun:Noun;
		
		public function RestModel()
		{
			super();
		}
		
		private var _id:int;
		
		[Ignore(only="POST,PUT")] public function get id():int
		{
			return _id;
		}
		public function set id(value:int):void
		{
			_id = value;
		}
		
		[Ignore] public function get noun():Noun
		{
			return $noun || ($noun = Noun.forInstance(this));
		}
	}
}