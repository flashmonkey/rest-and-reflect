package org.flashmonkey.mvcs.service.rest
{
	import org.flashmonkey.mvcs.service.IRestService;
	
	public class IndexOperation extends RestOperation
	{
		private var _url:String;
		
		public override function get url():String
		{
			trace("URL: " + service.format);
			return context + "/" + _url + service.format.toString();
		}
		
		public function IndexOperation(service:IRestService, url:String)
		{
			super(service);
			
			_url = url;
		}
	}
}