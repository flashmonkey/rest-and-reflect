package org.flashmonkey.mvcs.service.write
{
	import mx.collections.IList;
	
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Noun;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.WriteContext;
	
	public class WriteJSONOperation extends AbstractJSONWriteOperation
	{
		public function WriteJSONOperation(service:IRestService, source:*, verb:Verb, writeContext:WriteContext, writeName:Boolean = true)
		{
			super(service, source, verb, writeContext, writeName);
		}
		
		public override function execute():void
		{
			if (source is IList)
			{
				var list:IList = source as IList;
				
				if (list.length > 0)
				{
					var items:Array = [];	
					
					for each (var model:IRestModel in list)
					{
						items.push(model.toJson(verb, includes, excludes));
					}
					
					var s:String = items.join(",");
					
					trace("LIST STRING +++++++++++++++++++++++++++++++\n" + s);
					
					dispatchComplete( s );
				}
				else
				{
					dispatchComplete();
				}
			}
			else if (source is IRestModel)
			{
				var m:IRestModel = source as IRestModel;
				
				var s:String = '{"' + m.noun.singular + '":' + m.toJson(verb, includes, excludes) + '}';
				
				trace("WRITING JSON FOR " + m.noun.singular + " " + s);
				
				dispatchComplete( s );
			}
		}
	}
}