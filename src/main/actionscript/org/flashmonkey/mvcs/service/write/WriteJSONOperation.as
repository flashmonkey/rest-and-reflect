package org.flashmonkey.mvcs.service.write
{
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.ServiceContext;
	
	public class WriteJSONOperation extends AbstractJSONWriteOperation
	{
		public function WriteJSONOperation(service:IRestService, source:*, verb:Verb, serviceContext:ServiceContext, writeName:Boolean = true)
		{
			super(service, source, verb, serviceContext, writeName);
		}
	}
}