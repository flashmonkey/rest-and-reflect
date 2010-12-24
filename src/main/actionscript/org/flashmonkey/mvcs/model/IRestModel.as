package org.flashmonkey.mvcs.model
{
	import flash.events.IEventDispatcher;

	[Bindable] public interface IRestModel extends IRestful, IEventDispatcher
	{
		function get id():int;
		function set id(value:int):void;
	}
}