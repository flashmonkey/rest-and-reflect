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
				var model:IRestModel = list.getItemAt(0) as IRestModel;
				
				var s:String = '';//'{"' + model.noun.plural + '":["';
				
				for each (var model:IRestModel in list)
				{
					s += model.toJson(verb, includes, excludes);
				}
				
				s += '';//']}';
				
				dispatchComplete( s );
			}
			else if (source is IRestModel)
			{
				var m:IRestModel = source as IRestModel;
				
				dispatchComplete( '{"' + m.noun.singular + '":' + m.toJson(verb, includes, excludes) + '}' );
			}
		}
	}
}