package org.flashmonkey.mvcs.service.rest
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	
	public class UpdateOperation extends RestModelAwareOperation
	{
		public override function get url():String
		{
			return context + "/" + model.noun.plural + "/" + model.id + service.format.toString();
		}
		
		public override function get verb():Verb
		{
			return Verb.PUT;
		}
		
		public function UpdateOperation(service:IRestService, model:IRestModel)
		{
			super(service, model);
		}
	}
}