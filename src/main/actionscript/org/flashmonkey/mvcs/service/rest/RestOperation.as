package org.flashmonkey.mvcs.service.rest
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	import org.flashmonkey.mvcs.model.Format;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.operations.service.AbstractOperation;
	
	public class RestOperation extends AbstractOperation
	{		
		private var _service:IRestService;
		
		protected function get service():IRestService
		{
			return _service;
		}
		
		protected function get context():String
		{
			return service.context;
		}
		
		public function get url():String
		{
			return null;
		}
		
		private var _data:Object;
		
		public function get data():Object 
		{
			if (!_data)
			{
				_data = new URLVariables();
			}
			
			return _data;
		}
		
		private var _request:URLRequest;
		
		public function get request():URLRequest
		{
			if (!_request)
			{
				_request = new URLRequest(url);
				_request.method = verb.toString();
				_request.contentType = contentType;
			}
			
			return _request;
		}
		
		public function get contentType():String 
		{
			return service.format == Format.XML ? "application/xml" : "application/json";
		}
		
		public function get verb():Verb
		{
			return Verb.GET;
		}
		
		private var _loader:URLLoader;
		
		public function get loader():URLLoader
		{
			if (!_loader)
			{
				_loader = new URLLoader();
				
				_loader.addEventListener(Event.COMPLETE, onLoaderComplete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			}
			
			return _loader;
		}
		
		public function RestOperation(service:IRestService)
		{
			super();
			
			_service = service;
		}
		
		public override function execute():void
		{
			loader.load(request);
		}
		
		protected function onLoaderComplete(e:Event):void
		{
			dispatchComplete(_loader.data);
		}
		
		protected function onLoaderError(e:IOErrorEvent):void
		{
			dispatchError(e.text);
		}
	}
}