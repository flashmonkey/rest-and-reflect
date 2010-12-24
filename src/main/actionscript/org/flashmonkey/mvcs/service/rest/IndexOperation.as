package org.flashmonkey.mvcs.service.rest
{
	import org.flashmonkey.mvcs.service.IRestService;
	
	public class IndexOperation extends RestOperation
	{
		private var _url:String;
		
		public override function get url():String
		{
			return context + "/" + _url + ".xml";
		}
		
		public function IndexOperation(service:IRestService, url:String)
		{
			super(service);
			
			_url = url;
		}
	}
}