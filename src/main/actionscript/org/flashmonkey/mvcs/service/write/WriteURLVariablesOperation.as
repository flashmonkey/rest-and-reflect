package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import mx.collections.IList;
	
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.WriteContext;
	
	public class WriteURLVariablesOperation extends AbstractObjectWriteOperation
	{
		public function WriteURLVariablesOperation(service:IRestService, source:*, verb:Verb, writeContext:WriteContext)
		{
			super(service, source, verb, writeContext);
		}
		
		public override function execute():void
		{
			if (source is IList)
			{
				
			}
			else if (source is IRestModel)
			{
				var urlVariables:URLVariables = new URLVariables();
				
				(source as IRestModel).toUrlVariables(urlVariables, verb, includes, excludes);
				
				dispatchComplete( urlVariables );
			}
		}
	}
}