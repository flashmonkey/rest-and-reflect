package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;

	public class RestPropertyWriter implements IRestPropertyWriter
	{
		private var _writeSuffix:String = "";
		
		public function set writeSuffix(suffix:String):void
		{
			_writeSuffix = suffix;
		}
		
		private var _accessor:Accessor;
		
		protected function get accessor():Accessor
		{
			return _accessor;
		}
		
		private var _object:IRestModel;
		
		protected function get object():IRestModel
		{
			return _object;
		}
		
		private var _verb:Verb;
		
		protected function get verb():Verb
		{
			return _verb;
		}
		
		public function RestPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb)
		{
			_accessor = accessor;
			_object = object;
			_verb = verb;
		}
		
		public function writeJson(includes:Array, excludes:Array):String
		{
			return null;
		}
		
		public function writeXml(includes:Array, excludes:Array):XML
		{
			return null;
		}
		
		public function canWrite(includes:Array, excludes:Array):Boolean
		{
			return accessor.getValue(object) != null && !ignoreField(includes, excludes);
		}
		
		public static function writerFor(accessor:Accessor, object:IRestModel, verb:Verb):IRestPropertyWriter
		{
			if (accessor.hasMetaData("Rest"))
			{
				var m:MetaData = accessor.getMetaData("Rest")[0];
				
				var writer:IRestPropertyWriter
				
				if (m.hasArgumentWithKey("writer"))
				{
					var writerName:String = m.getArgument("writer").value;
	
					writer = ClassUtils.newInstance(ClassUtils.forName(writerName),[accessor, object, verb]);
	
					return writer;
				}
				else
				{
					if (m.hasArgumentWithKey("writeSuffix"))
					{
						writer = defaultWriterFor(accessor, object, verb);
						writer.writeSuffix = m.getArgument("writeSuffix").value;
						
						return writer;
					}
				}
			}
			
			return defaultWriterFor(accessor, object, verb);
		}
		
		private static function defaultWriterFor(accessor:Accessor, object:IRestModel, verb:Verb):IRestPropertyWriter
		{
			switch (accessor.type.name)
			{
				case "String":
				case "Number":
				case "int":
				case "Boolean":
					return new PrimitiveRestPropertyWriter(accessor, object, verb);
					
				case "IList":
					return new ListRestPropertyWriter(accessor, object, verb);
					
				case "Object":
				case "ObjectProxy":
					return new ObjectRestPropertyWriter(accessor, object, verb);
					
				default:
					return new RestModelPropertyWriter(accessor, object, verb);
			}
		}
		
		protected function ignoreField(includes:Array, excludes:Array):Boolean
		{
			if (includes && includes.indexOf(accessor.name) > -1)
			{
				return false;
			}

			if (excludes && excludes.indexOf(accessor.name) > -1)
			{
				return true;
			}
			
			return false;
		}
		
		public function writeUrlVariables(urlVariables:URLVariables, includes:Array, excludes:Array):void
		{
			
		}
		
		public function toString():String
		{
			return "RestPropertyWriter[" + object.noun.singular + ", " + accessor.name + "]";
		}
	}
}