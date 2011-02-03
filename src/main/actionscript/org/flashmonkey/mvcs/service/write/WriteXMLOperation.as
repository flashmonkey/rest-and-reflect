package org.flashmonkey.mvcs.service.write
{
	import mx.collections.IList;
	
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.WriteContext;
	
	public class WriteXMLOperation extends AbstractObjectWriteOperation
	{
		public function WriteXMLOperation(service:IRestService, source:*, verb:Verb, writeContext:WriteContext)
		{
			super(service, source, verb, writeContext);		
		}
		
		public override function execute():void
		{
			var result:*;
			
			if (source is IList)
			{
				
			}
			else if (source is IRestModel)
			{
				dispatchComplete( (source as IRestModel).toXml(verb, includes, excludes) );
			}
			
			
			
			/*var type:Type;
			
			if (source is IList)
			{
				trace("writing a list of " + IList(source).length + " items");
				var xml:XML = new XML();
				var list:IList = IList(source);
				type = Type.forInstance(list.getItemAt(0));
				
				for each (var model:IRestModel in list)
				{
					xml.appendChild(writeModel(model, type, _includes, _excludes));	
				}
				
				dispatchComplete(xml);
			}
			else
			{
				type = Type.forInstance(source);
				dispatchComplete(writeModel(IRestModel(source), type, _includes, _excludes));
			}*/
		}
		
		/*protected function writeModel(model:IRestModel, type:Type, includes:Array = null, excludes:Array = null):XML 
		{
			trace("writing model " + model + " excluding " + excludes);
			var xml:XML = <{model.noun.singular}/>*/

			/*for each (var extendedClass:String in type.extendsClasses)
			{
				if (extendedClass != "Object")
				{
					var a:Array = [];
					for each (var acc:Accessor in Type.forName(extendedClass).accessors)
					{
						a.push(acc.name);
					}
					trace("extended class " + extendedClass + " has " + Type.forName(extendedClass).accessors.length + " fields " + a);
					writeFields(model, Type.forName(extendedClass).accessors, xml, includes);
				}
			}*/
			/*var a:Array = [];
			for each (var acc:Accessor in type.accessors)
			{
				a.push(acc.name);
			}
			trace("class " + type.name + " has " + Type.forName(extendedClass).accessors.length + " fields " + a);*/
			
			/*writeFields(model, type.accessors, xml, includes, excludes);
			trace(xml);
			return xml;
		}
		
		protected function writeFields(model:IRestModel, accessors:Array, xml:XML, includes:Array = null, excludes:Array = null):void 
		{
			for each (var accessor:Accessor in accessors)
			{
				trace("attempting to write field '" + accessor.name + "'");
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
								if (IList(value).length > 0)
								{
									writeArrayField(accessor.name, value as IList, xml, includes, excludes);
								}
							}
							else
							{
								writeField(accessor.name, value.toString(), xml);
						
							}
						}
					}
				}
			}
		}
		
		protected function writeField(name:String, value:String, xml:XML):void 
		{
			trace("writing " + name + " = " + value);
			xml.appendChild(<{name}>{value}</{name}>);
		}
		
		protected function writeArrayField(name:String, value:IList, xml:XML, includes:Array = null, excludes:Array = null):void
		{
			trace("Writing " + name + " " + value);
			
			var listXML:XML = <{name} type="array"/>;
			
			for each (var model:IRestModel in value)
			{
				listXML.appendChild(writeModel(model, Type.forInstance(model), ["id"].concat(includes), excludes));
			}
			
			xml.appendChild(listXML);
		}*/
	}
}