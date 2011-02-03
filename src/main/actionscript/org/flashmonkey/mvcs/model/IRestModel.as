package org.flashmonkey.mvcs.model
{
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;

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
		function toJson(verb:Verb, includes:Array, excludes:Array):String;
		function fromJson(value:Object):void;
		
		/**
		 * 'getter' returns the XML representation of this object.
		 * 'setter' populates the object with the contents of an XML object.
		 */
		function toXml(verb:Verb, includes:Array, excludes:Array):XML;
		function fromXml(value:XML):void;
		
		/**
		 * 'getter' returns the URLVariables (&foo=bar) representation of the properties of this object.
		 * 'setter' populates the properties of this object with the contents of a url string.
		 */
		function toUrlVariables(urlVariables:URLVariables, verb:Verb, includes:Array, excludes:Array):void;
		function fromURLVariables(value:String):void;
	}
}