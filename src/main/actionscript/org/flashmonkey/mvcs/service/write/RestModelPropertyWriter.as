package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import org.as3commons.reflect.Accessor;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	
	public class RestModelPropertyWriter extends RestPropertyWriter
	{
		public function RestModelPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb)
		{
			super(accessor, object, verb);
		}
		
		public override function writeJson(includes:Array, excludes:Array):String
		{
			trace("trying to transform " + accessor.name + " " + accessor.getValue(object) + " to a json string");
			return '{"' + accessor.name + '":' + (accessor.getValue(object) as IRestModel).toJson(verb, includes, excludes) + '}';
		}
		
		public override function writeXml(includes:Array, excludes:Array):XML
		{
			return <{accessor.name}>{(accessor.getValue(object) as IRestModel).toXml(verb, includes, excludes)}</{accessor.name}>;
		}
		
		public override function writeUrlVariables(urlVariables:URLVariables, includes:Array, excludes:Array):void
		{
			urlVariables[accessor.name] = (accessor.getValue(object) as IRestModel).toXml(verb, includes, excludes);
		}
	}
}