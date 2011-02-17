package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import org.as3commons.reflect.Accessor;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;

	public class PrimitiveRestPropertyWriter extends RestPropertyWriter
	{
		public function PrimitiveRestPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb)
		{
			super(accessor, object, verb);
		}
		
		public override function writeJson(includes:Array, excludes:Array):String
		{
			return '"' + accessor.name + '":"' + accessor.getValue(object).toString() + '"';
		}
		
		public override function writeXml(includes:Array, excludes:Array):XML
		{
			var value:Object = accessor.getValue(object);
			
			if (value)
			{
				return <{accessor.name}>{value.toString()}</{accessor.name}>;
			}
			
			return null;
		}
		
		public override function writeUrlVariables(urlVariables:URLVariables, includes:Array, excludes:Array):void
		{
			urlVariables[accessor.name] = accessor.getValue(object).toString();
		}
	}
}