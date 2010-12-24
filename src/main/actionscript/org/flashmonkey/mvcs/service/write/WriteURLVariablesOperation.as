package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import mx.collections.IList;
	
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	
	public class WriteURLVariablesOperation extends AbstractObjectWriteOperation
	{
		public function WriteURLVariablesOperation(source:*, verb:Verb)
		{
			super(source, verb);
		}
		
		public override function execute():void
		{
			var type:Type;
			
			if (source is IList)
			{
				
			}
			else
			{
				type = Type.forInstance(source);
				dispatchComplete(writeModel(IRestModel(source), type));
			}
		}
		
		protected function writeModel(model:IRestModel, type:Type):URLVariables 
		{
			var vars:URLVariables = new URLVariables();
			
			for each (var extendedClass:String in type.extendsClasses)
			{
				if (extendedClass != "Object")
				{
					writeFields(model, Type.forName(extendedClass).accessors, vars);
				}
			}
			
			writeFields(model, type.accessors, vars);
			trace(vars);
			return vars;
		}
		
		protected function writeFields(model:IRestModel, accessors:Array, vars:URLVariables):void 
		{
			for each (var accessor:Accessor in accessors)
			{
				if (accessor.isReadable())
				{
					var value:* = accessor.getValue(model);
					
					if (value != null && !ignoreField(accessor))
					{
						if (accessor.type.name == "IList")
						{
							
						}
						else
						{
							writeField(accessor.name, value.toString(), vars);
						}
					}
				}
			}
		}
		
		protected function writeField(name:String, value:String, vars:URLVariables):void 
		{
			trace("writing " + name + " => " + value);
			vars[name] = value;
		}
	}
}