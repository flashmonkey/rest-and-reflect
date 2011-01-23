package org.flashmonkey.mvcs.service.write
{
	import org.as3commons.reflect.Accessor;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;

	public class RestPropertyWriter implements IRestPropertyWriter
	{
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
		
		private var _includes:Array;
		
		protected function get includes():Array 
		{
			return _includes;
		}
		
		private var _excludes:Array;
		
		protected function get excludes():Array
		{
			return _excludes;
		}
		
		public function RestPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb, includes:Array = null, excludes:Array = null)
		{
			_accessor = accessor;
			_object = object;
			_verb = verb;
			_includes = includes || [];
			_excludes = excludes || [];
		}
		
		protected var _json:String;
		
		public function get json():String
		{
			return null;
		}
		
		protected var _xml:XML;
		
		public function get xml():XML
		{
			return null;
		}
		
		public function get can():Boolean
		{
			return !ignoreField(accessor, includes, excludes);
		}
		
		public static function writerFor(accessor:Accessor, object:IRestModel, verb:Verb, includes:Array, excludes:Array):IRestPropertyWriter
		{
			switch (accessor.type.name)
			{
				case "String":
				case "Number":
				case "int":
					return new PrimitiveRestPropertyWriter(accessor, object, verb, includes, excludes);
					
				case "IList":
					return new ListRestPropertyWriter(accessor object, verb, includes, excludes);
					
				default:
					return null;
			}
		}
		
		private function ignoreField(accessor:Accessor, includes:Array, excludes:Array):Boolean
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
	}
}