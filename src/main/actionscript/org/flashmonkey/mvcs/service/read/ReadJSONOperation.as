package org.flashmonkey.mvcs.service.read
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.operations.service.AbstractOperation;
	
	public class ReadJSONOperation extends AbstractOperation
	{
		private var _source:Object;
		
		private var _clazz:Class;
		
		public function ReadJSONOperation(source:String, clazz:Class)
		{
			super();
			
			_source = JSON.decode(source);
			_clazz = clazz;
		}
		
		public override function execute():void
		{
			trace("There are " + ObjectUtils.getNumProperties(_source) + " properties on the source object " + (_source is Array) + " " + ClassUtils.getFullyQualifiedName(_clazz, true));
			
			trace("PROPERTIES: " + ObjectUtils.getKeys(_source));
			
			if (_clazz)
			{
				trace(ClassUtils.getFullyQualifiedName(_clazz) + " extends " + Type.forClass(_clazz).extendsClasses);
			}
					
			if (_source is Array)
			{
				var items:Array = [];
				
				var list:Array = _source as Array;
				
				for each (var item:Object in list)
				{
					var entry:IRestModel = ClassUtils.newInstance(_clazz) as IRestModel;
					entry.fromJson(item);
					
					items.push(entry);
				}
				
				dispatchComplete(new ArrayCollection(items));
			}
			else
			{
				var obj:IRestModel = ClassUtils.newInstance(_clazz) as IRestModel;
				obj.fromJson(_source);
				
				dispatchComplete(obj);
			}
		}
	}
}