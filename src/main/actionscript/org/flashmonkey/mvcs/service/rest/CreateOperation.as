package org.flashmonkey.mvcs.service.rest
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	
	public class CreateOperation extends RestModelAwareOperation
	{
		public override function get verb():Verb
		{
			return Verb.POST;
		}
		
		public function CreateOperation(service:IRestService, model:IRestModel, writeContext:WriteContext)
		{
			super(service, model, writeContext);
		}
	}
}