package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import mx.collections.IList;
	
	import org.as3commons.reflect.Accessor;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.util.StringUtils;
	
	public class ListRestPropertyWriter extends RestPropertyWriter
	{
		public function ListRestPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb)
		{
			super(accessor, object, verb);
		}
		
		public override function writeJson(includes:Array, excludes:Array):String
		{	
			var json:String = '{"' + accessor.name + '_attributes":[';
			
			for each (var model:IRestModel in (accessor.getValue(object) as IList))
			{
				json += model.toJson(verb, includes, excludes);
			}
			
			json += ']}';
			
			return json;
		}
		
		public override function writeXml(includes:Array, excludes:Array):XML
		{
			var list:IList = accessor.getValue(object) as IList
			
			if (list && list.length > 0)
			{
				var xml:XML = <{accessor.name + "_attributes"}/>
				
				for each (var model:IRestModel in list)
				{
					xml.appendChild(model.toXml(verb, includes, excludes));
				}
				
				return xml;
			}
			
			return null;
		}
		
		public override function writeUrlVariables(urlVariables:URLVariables, includes:Array, excludes:Array):void
		{
			for each (var model:IRestModel in (accessor.getValue(object) as IList))
			{
				model.toUrlVariables(urlVariables, verb, includes, excludes);
			}
		}
	}
}