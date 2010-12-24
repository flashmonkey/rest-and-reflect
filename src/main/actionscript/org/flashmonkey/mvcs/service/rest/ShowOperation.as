package org.flashmonkey.mvcs.service.rest
{
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.service.IRestService;
	
	public class ShowOperation extends RestModelAwareOperation
	{
		public override function get url():String
		{
			return context + "/" + model.noun + "/" + model.id + ".xml";
		}
		
		public function ShowOperation(service:IRestService, model:IRestModel)
		{
			super(service, model);
		}
	}
}