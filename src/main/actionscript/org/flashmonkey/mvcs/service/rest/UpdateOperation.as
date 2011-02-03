package org.flashmonkey.mvcs.service.rest
{
	import flash.net.URLRequestHeader;
	
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	
	public class UpdateOperation extends RestModelAwareOperation
	{
		public override function get url():String
		{
			return context + "/" + model.noun.plural + "/" + model._id + service.format.toString();
		}
		
		public override function get verb():Verb
		{
			if (!service.airAvailable)
			{
				request.requestHeaders = [new URLRequestHeader("X_HTTP_METHOD_OVERRIDE", "PUT")];
				
				return Verb.POST;
			}
			
			return Verb.PUT;
		}
		
		public function UpdateOperation(service:IRestService, model:IRestModel, writeContext:WriteContext)
		{
			super(service, model, writeContext);
		}
	}
}