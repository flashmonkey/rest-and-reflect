package org.flashmonkey.mvcs.service.write
{
	import mx.collections.IList;
	
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.operation.AbstractOperation;
	
	public class WriteXMLOperation extends AbstractObjectWriteOperation
	{
		public function WriteXMLOperation(source:*, verb:Verb)
		{
			super(source, verb);
		}
		
		public override function execute():void
		{
			var type:Type;
			
			if (source is IList)
			{
				var xml:XML = new XML();
				var list:IList = IList(source);
				type = Type.forInstance(list.getItemAt(0));
				
				for each (var model:IRestModel in list)
				{
					xml.appendChild(writeModel(model, type));	
				}
				
				dispatchComplete(xml);
			}
			else
			{
				type = Type.forInstance(source);
				dispatchComplete(writeModel(IRestModel(source), type));
			}
		}
		
		protected function writeModel(model:IRestModel, type:Type, includes:Array = null):XML 
		{
			var xml:XML = <{model.noun.singular}/>

			for each (var extendedClass:String in type.extendsClasses)
			{
				if (extendedClass != "Object")
				{
					writeFields(model, Type.forName(extendedClass).accessors, xml, includes);
				}
			}
			
			writeFields(model, type.accessors, xml);
			trace(xml);
			return xml;
		}
		
		protected function writeFields(model:IRestModel, accessors:Array, xml:XML, includes:Array = null):void 
		{
			for each (var accessor:Accessor in accessors)
			{
				if (accessor.isReadable())
				{
					var value:* = accessor.getValue(model);
					
					if (value != null && !ignoreField(accessor, includes))
					{
						if (accessor.type.name == "IList")
						{
							if (IList(value).length > 0)
							{
								writeArrayField(accessor.name, value as IList, xml);
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
		
		protected function writeField(name:String, value:String, xml:XML):void 
		{
			xml.appendChild(<{name}>{value}</{name}>);
		}
		
		protected function writeArrayField(name:String, value:IList, xml:XML):void
		{
			trace("Writing " + name + " " + value);
			
			var listXML:XML = <{name}/>;
			
			for each (var model:IRestModel in value)
			{
				listXML.appendChild(writeModel(model, Type.forInstance(model), ["id"]));
			}
			
			xml.appendChild(listXML);
		}
	}
}