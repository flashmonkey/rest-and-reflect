package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;
	
	import mx.collections.IList;
	
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.ServiceContext;
	
	public class WriteURLVariablesOperation extends AbstractObjectWriteOperation
	{
		private var _includes:Array = [];
		
		private var _excludes:Array = ["prototype"];
		
		public function WriteURLVariablesOperation(service:IRestService, source:*, verb:Verb, serviceContext:ServiceContext)
		{
			super(service, source, verb);

			_includes = _includes.concat(serviceContext.includes);
			_excludes = _excludes.concat(serviceContext.excludes);
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
				dispatchComplete(writeModel(IRestModel(source), type, _includes, _excludes));
			}
		}
		
		protected function writeModel(model:IRestModel, type:Type, includes:Array, excludes:Array):URLVariables 
		{
			var vars:URLVariables = new URLVariables();
			
			/*for each (var extendedClass:String in type.extendsClasses)
			{
				if (extendedClass != "Object")
				{
					writeFields(model, Type.forName(extendedClass).accessors, vars);
				}
			}*/
			
			writeFields(model, type.accessors, vars, includes, excludes);

			return vars;
		}
		
		protected function writeFields(model:IRestModel, accessors:Array, vars:URLVariables, includes:Array, excludes:Array):void 
		{
			for each (var accessor:Accessor in accessors)
			{
				trace("attempting to write field '" + accessor.name + "' including " + includes + " excluding " + excludes);
				if (accessor.isReadable())
				{
					if (!ignoreField(accessor, includes, excludes))
					{
						trace("not ignoring " + accessor.name + " writing it");
						var value:* = accessor.getValue(model);
						trace("value of '" + accessor.name + "' is '" + value + "'");
						if (value != null)
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
		}
		
		protected function writeField(name:String, value:String, vars:URLVariables):void 
		{
			vars[name] = value;
		}
	}
}