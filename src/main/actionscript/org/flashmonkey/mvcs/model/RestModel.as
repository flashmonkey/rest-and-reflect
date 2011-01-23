package org.flashmonkey.mvcs.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.service.write.IRestPropertyWriter;
	import org.flashmonkey.mvcs.service.write.RestPropertyWriter;

	[Bindable][RemoteClass] public class RestModel implements IRestModel
	{
		private static var _map:IMap = new Map();
		
		public static function forId(id:String):IRestModel
		{
			if (_map.hasKey(id))
			{
				return IRestModel(_map.itemFor(id));
			}
			
			throw new Error("There is no RestModel instance with the id '" + id + "'");
		}
		
		private static var _serialisedProperties:Map = new Map();
		
		private static var _types:Map = new Map();
		
		public static function forName(name:String):IRestModel
		{
			return Noun.newInstance(name);
		}
		
		private var _noun:Noun;
		
		public function RestModel()
		{
			super();
		}
		
		private var $id:String;
		
		[Ignore(only="POST,PUT")] public function get _id():String
		{
			return $id;
		}
		public function set _id(value:String):void
		{
			$id = value;
			
			if (!_map.hasKey($id))
			{
				_map.add($id, this);
			}
		}
		
		[Ignore(only="POST,PUT")] public function get id():String
		{
			return $id;
		}
		public function set id(value:String):void
		{
			$id = value;
			
			if (!_map.hasKey($id))
			{
				_map.add($id, this);
			}
		}
		
		private var _clazz:Class;
		
		[Ignore] public function get clazz():Class
		{
			return _clazz || (_clazz = ClassUtils.forInstance(this));
		}
		
		[Ignore] public function get noun():Noun
		{
			return _noun || (_noun = Noun.forInstance(this));
		}
		
		/**
		 * @inheritDoc
		 */
		public function toJson(verb:Verb, includes:Array = null, excludes:Array = null):String
		{
			var s:String = '{';
			
			for each (var propertyWriter:IRestPropertyWriter in serialisedProperties(verb, includes, excludes))
			{
				if (propertyWriter.can) s += propertyWriter.json;
			}
			
			s += '}';
		}
		
		public function fromJson(value:String):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function toXml(verb:Verb, includes:Array = null, excludes:Array = null):XML
		{
			var xml:XML = <{noun.singular}/>
			
			for each (var propertyWriter:IRestPropertyWriter in serialisedProperties(verb, includes, excludes))
			{
				if (propertyWriter.can) s += propertyWriter.xml;
			}
			
			return xml;
		}
		public function fromXml(value:XML):void
		{
			
		}
		
		private function serialisedProperties(verb:Verb, includes:Array, excludes:Array):Array
		{
			// Get the list of properties that should be serialised
			// for the given Verb (again, done lazily).
			if (!_serialisedProperties.hasKey(verb))
			{
				// Store the Type for the current instance into the _types
				// property - done lazily when toJson() is first called.
				if (!_types.hasKey(clazz))
				{
					_types.add(clazz, Type.forInstance(this));
				}
				
				var type:Type = _types.itemFor(clazz) as Type;
				
				// Iterate over the accessors stored in the Type.
				// If we're not ignoring them then they're added to the 
				// list of properties to serialise.
				var props:Array = [];
				
				for each (var accessor:Accessor in type.accessors)
				{
					if (!ignoreField(accessor, includes, excludes))
					{
						props.push(RestPropertyWriter.writerFor(accessor, this, verb, includes, excludes);
					}
				}
				
				_types.add(verb, props);
			}
			
			return _types.itemFor(verb) as Array;
		}
		
		private function ignoreField(accessor:Accessor, includes:Array, excludes:Array):Boolean
		{
			if (accessor.hasMetaData("Upload"))
			{
				return true;
			}
			
			if (accessor.hasMetaData("Ignore"))
			{
				if (includes && includes.indexOf(accessor.name) > -1)
				{
					return false;
				}
				
				var m:MetaData = MetaData(accessor.getMetaData("Ignore")[0]);
				
				if (m.hasArgumentWithKey("only"))
				{
					if (m.getArgument("only").value.split(",").indexOf(_verb.toString()) > -1)
					{
						return true;
					}
				}
				else
				{
					return true;
				}
				
			}
			
			return false;
		}
	}
}