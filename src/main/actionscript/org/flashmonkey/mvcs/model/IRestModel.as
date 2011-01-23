package org.flashmonkey.mvcs.model
{
	import flash.events.IEventDispatcher;

	[Bindable] public interface IRestModel extends IRestful
	{
		function get _id():String;
		function set _id(value:String):void;
		
		function get id():String;
		function set id(value:String):void;
		
		function get clazz():Class;
		
		///////////////////////////
		// SERIALISATION METHODS //
		///////////////////////////
		
		/**
		 * 'getter' returns the JSON string representation of this object.
		 * 'setter' populates the object with the contents of a json string.
		 */
		function get toJson(verb:Verb, includes:Array = null, excludes:Array = null):String;
		function set fromJson(value:String):void;
		
		/**
		 * 'getter' returns the XML representation of this object.
		 * 'setter' populates the object with the contents of an XML object.
		 */
		function get toXml(verb:Verb, includes:Array = null, excludes:Array = null):XML;
		function set fromXml(value:XML):void;
	}
}