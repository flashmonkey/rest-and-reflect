package org.flashmonkey.mvcs.service.write
{
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.WriteContext;
	import org.flashmonkey.operations.service.AbstractOperation;
	
	public class AbstractObjectWriteOperation extends AbstractOperation
	{
		private var _source:*;
		
		protected function get source():*
		{
			return _source;
		}
		
		private var _verb:Verb;
		
		protected function get verb():Verb
		{
			return _verb;
		}
		
		private var _service:IRestService;
		
		protected function get service():IRestService
		{
			return _service;
		}
		
		private var _includes:Array = [];
		
		protected function get includes():Array
		{
			return _includes;
		}
		protected function set includes(value:Array):void 
		{
			_includes = value;
		}
		
		private var _excludes:Array = ["prototype"];
		
		protected function get excludes():Array
		{
			return _excludes;
		}
		protected function set excludes(value:Array):void 
		{
			_excludes = value;
		}
		
		public function AbstractObjectWriteOperation(service:IRestService, source:*, verb:Verb, writeContext:WriteContext)
		{
			super();
			
			_service = service;
			_source = source;
			_verb = verb;
			
			this.includes = this.includes.concat(writeContext.includes);
			this.excludes = this.excludes.concat(writeContext.excludes);
		}
	}
}