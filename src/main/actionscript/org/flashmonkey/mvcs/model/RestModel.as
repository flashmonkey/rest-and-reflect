package org.flashmonkey.mvcs.model
{
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
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
		
		private static function TYPE(clazz:Class):Type
		{
			if (!_types.hasKey(clazz))
			{
				_types.add(clazz, Type.forClass(clazz));
			}
			
			return _types.itemFor(clazz) as Type;
		}
		
		public static function forName(name:String):IRestModel
		{
			return Noun.newInstance(name);
		}
		
		protected function get cacheProperties():Boolean
		{
			return false;
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
		public function toJson(verb:Verb, includes:Array, excludes:Array):String
		{
			var properties:Array = serialisedProperties(verb, includes, excludes);
			
			var props:Array = []
			
			for each (var propertyWriter:IRestPropertyWriter in properties)
			{
				if (propertyWriter.canWrite(includes, excludes)) 
				{
					var s:String = propertyWriter.writeJson(includes, excludes);

					props.push(s);
				}
			}
			
			return '{' + props.join(',') + '}';
		}
		
		public function fromJson(value:Object):void
		{
			for (var i:String in value)
			{
				applyProperty(i, value[i]);
			}
		}
		
		protected function applyProperty(key:String, value:*):void 
		{
			this[key] = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toXml(verb:Verb, includes:Array, excludes:Array):XML
		{
			var xml:XML = <{noun.singular}/>
			
			var properties:Array = serialisedProperties(verb, includes, excludes);

			for each (var propertyWriter:IRestPropertyWriter in properties)
			{
				if (propertyWriter.canWrite(includes, excludes)) xml.appendChild(propertyWriter.writeXml(includes, excludes));
			}

			return xml;
		}
		public function fromXml(value:XML):void
		{
			
		}
		
		public function toUrlVariables(urlVariables:URLVariables, verb:Verb, includes:Array, excludes:Array):void
		{
			for each (var propertyWriter:IRestPropertyWriter in serialisedProperties(verb, includes, excludes))
			{
				if (propertyWriter.canWrite(includes, excludes)) propertyWriter.writeUrlVariables(urlVariables, includes, excludes);
			}
		}
		public function fromURLVariables(value:String):void
		{
		
		}
		
		protected function serialisedProperties(verb:Verb, includes:Array, excludes:Array):Array
		{
			if (cacheProperties)
			{
				// Store the Type for the current instance into the _types
				// property - done lazily when toJson() is first called.
				if (!_serialisedProperties.hasKey(clazz))
				{
					_serialisedProperties.add(clazz, new Map());
				}
				
				var propertiesMap:IMap = _serialisedProperties.itemFor(clazz) as IMap;
					
				// Get the list of properties that should be serialised
				// for the given Verb (again, done lazily).
				if (!propertiesMap.hasKey(verb))
				{
					propertiesMap.add(verb, createWritersArray(TYPE(clazz), verb, includes, excludes));
				}
				
				return propertiesMap.itemFor(verb) as Array;
			}
			else
			{
				return createWritersArray(TYPE(clazz), verb, includes, excludes);
			}
		}
		
		private function createWritersArray(type:Type, verb:Verb, includes:Array, excludes:Array):Array
		{
			// Iterate over the accessors stored in the Type.
			// If we're not ignoring them then they're added to the 
			// list of properties to serialise.
			var props:Array = [];
			
			for each (var accessor:Accessor in type.accessors)
			{
				if (!ignoreField(accessor, verb, includes, excludes))
				{
					props.push(RestPropertyWriter.writerFor(accessor, this, verb));
				}
			}
			
			return props;
		}
		
		private function ignoreField(accessor:Accessor, verb:Verb, includes:Array, excludes:Array):Boolean
		{
			if (includes && includes.indexOf(accessor.name) > -1)
			{
				return false;
			}
			
			if (excludes && excludes.indexOf(accessor.name) > -1)
			{
				return true;
			}
			
			if (accessor.hasMetaData("Upload"))
			{
				return true;
			}
			
			if (accessor.hasMetaData("Ignore"))
			{
				var m:MetaData = MetaData(accessor.getMetaData("Ignore")[0]);
				
				if (m.hasArgumentWithKey("only"))
				{
					if (m.getArgument("only").value.split(",").indexOf(verb.toString()) > -1)
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