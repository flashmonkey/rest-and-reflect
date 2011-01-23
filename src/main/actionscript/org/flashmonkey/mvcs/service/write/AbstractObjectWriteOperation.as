package org.flashmonkey.mvcs.service.write
{
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
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
		
		public function AbstractObjectWriteOperation(service:IRestService, source:*, verb:Verb)
		{
			super();
			
			_source = source;
			_verb = verb;
			_service = service;
		}
		
		protected function ignoreField(accessor:Accessor, includes:Array, excludes:Array):Boolean
		{
			if (includes.indexOf(accessor.name) > -1)
			{
				return false;
			}
			
			if (excludes.indexOf(accessor.name) > -1)
			{
				return true;
			}
			
			if (accessor.hasMetaData("Upload"))
			{
				return true;
			}
			
			if (accessor.hasMetaData("Ignore"))//
			{
				if (includes && includes.indexOf(accessor.name) > -1)
				{
					return false;
				}
				
				var m:MetaData = MetaData(accessor.getMetaData("Ignore")[0]);
				
				if (m.hasArgumentWithKey("only"))
				{
					//trace("does the verb match? " + m.getArgument("only").value + " " + _verb.toString() + " " + + m.getArgument("only").value.split(",").indexOf(_verb.toString()));
					if (m.getArgument("only").value.split(",").indexOf(_verb.toString()) > -1)
					{
						return true;
					}
				}
				else
				{
					return true;
				}
				
			}
			
			return false;
		}
	}
}