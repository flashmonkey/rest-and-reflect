package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import mx.collections.IList;
	
	import org.as3commons.reflect.Accessor;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	
	public class ObjectRestPropertyWriter extends RestPropertyWriter
	{
		public function ObjectRestPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb)
		{
			super(accessor, object, verb);
		}
		
		public override function writeJson(includes:Array, excludes:Array):String
		{	
			var props:Array = [];
			
			var value:Object = accessor.getValue(object);
			
			for (var i:String in value)
			{
				var s:String = '"' + i + '":';
				
				var p:* = value[i];
				
				trace("property name = " + i + " and value is " + p);
				
				if (p is IRestModel)
				{
					var m:IRestModel = p as IRestModel;
					//s += m.toJson(verb, includes, excludes);
				}
				else if (p is IList)
				{
					var l:IList = p as IList;
					for each (var model:IRestModel in l)
					{
						s += model.toJson(verb, includes, excludes);
					}
				}
				else
				{
					s += '"' + p.toString() + '"';
				}
				
				props.push(s);
			}
			
			return '{' + props.join(",") + '}';
		}
		
		public override function writeXml(includes:Array, excludes:Array):XML
		{
			var xml:XML = <{accessor.name}/>
			
			for each (var model:IRestModel in (accessor.getValue(object) as IList))
			{
				xml.appendChild(model.toXml(verb, includes, excludes));
			}
			
			return xml;
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