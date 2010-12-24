package org.flashmonkey.mvcs.service.write
{
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.operation.AbstractOperation;
	
	public class AbstractObjectWriteOperation extends AbstractOperation
	{
		private var _source:*;
		
		protected function get source():*
		{
			return _source;
		}
		
		private var _verb:Verb;
		
		public function AbstractObjectWriteOperation(source:*, verb:Verb)
		{
			super();
			
			_source = source;
			_verb = verb;
		}
		
		protected function ignoreField(accessor:Accessor, includes:Array = null):Boolean
		{
			if (accessor.hasMetaData("Upload"))
			{
				return true;
			}
			
			if (accessor.hasMetaData("Ignore"))
			{
				if (includes && includes.indexOf(accessor.name) > -1)
				{
					return false;
				}
				
				var m:MetaData = MetaData(accessor.getMetaData("Ignore")[0]);
				
				if (m.hasArgumentWithKey("only"))
				{
					trace("does the verb match? " + m.getArgument("only").value + " " + _verb.toString() + " " + + m.getArgument("only").value.split(",").indexOf(_verb.toString()));
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