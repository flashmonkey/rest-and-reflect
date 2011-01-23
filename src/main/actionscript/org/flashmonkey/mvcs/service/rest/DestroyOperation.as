package org.flashmonkey.mvcs.service.rest
{
	import flash.net.URLRequestHeader;
	
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	
	public class DestroyOperation extends RestModelAwareOperation
	{
		public override function get url():String
		{
			return context + "/" + model.noun.plural + "/" + model._id.toString() + service.format.toString();
		}
		
		public override function get verb():Verb
		{
			if (!service.airAvailable)
			{
				request.requestHeaders = [new URLRequestHeader("X_HTTP_METHOD_OVERRIDE", "DELETE")];
				
				return Verb.POST;
			}
			
			return Verb.DELETE;
		}
		
		public function DestroyOperation(service:IRestService, model:IRestModel)
		{
			super(service, model, null);
		}
	}
}