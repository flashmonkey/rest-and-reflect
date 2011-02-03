package org.flashmonkey.mvcs.service.rest
{
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.DictionaryUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.Format;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.read.ReadJSONOperation;
	import org.flashmonkey.mvcs.service.read.ReadXMLOperation;
	import org.flashmonkey.mvcs.service.write.WriteJSONOperation;
	import org.flashmonkey.mvcs.service.write.WriteXMLOperation;
	import org.flashmonkey.operations.service.IOperation;
	
	public class RestService implements IRestService
	{
		private var _context:String;
		
		public function get context():String
		{
			return _context;
		}
		public function set context(value:String):void
		{
			_context = value;
		}
		
		private var _airAvailable:Boolean;
		
		public function get airAvailable():Boolean
		{
			return _airAvailable;
		}
		public function set airAvailable(value:Boolean):void
		{
			_airAvailable = value;
		}
		
		private var _urlCache:Dictionary = new Dictionary();
		
		private var _format:Format;
		
		public function get format():Format
		{
			return _format || (_format = Format.XML);
		}
		public function set format(value:Format):void
		{
			_format = value;
		}
		
		public function RestService()
		{
		}
		
		public function index(clazz:Class):IOperation
		{
			if (!DictionaryUtils.containsKey(_urlCache, clazz))
			{
				_urlCache[clazz] = (ClassUtils.newInstance(clazz) as IRestModel).noun.plural;
			}
			
			return new IndexOperation(this, String(_urlCache[clazz]));
		}
		
		public function show(value:IRestModel):IOperation
		{
			return null;
		}
		
		public function create(value:IRestModel, writeContext:WriteContext = null):IOperation
		{
			var type:Type = Type.forInstance(value);
			
			for each (var a:Accessor in type.accessors)
			{
				if (a.hasMetaData("Upload"))
				{
					var m:MetaData = MetaData(a.getMetaData("Upload")[0]);
					
					var dataField:String;
					
					if (m.hasArgumentWithKey("dataField"))
					{
						dataField = m.getArgument("dataField").value;
					}
					else
					{
						// no dataField argument supplied in 'Upload' metatag - defaulting to 'file';
						dataField = "file";
					}
					
					return new UploadOperation(this, value, a, dataField, writeContext || new WriteContext());
				}
				
			}
			
			return new CreateOperation(this, value, writeContext || new WriteContext());
		}
		
		public function update(value:IRestModel, writeContext:WriteContext = null):IOperation
		{
			return new UpdateOperation(this, value, writeContext || new WriteContext());
		}
		
		public function destroy(value:IRestModel):IOperation
		{
			return new DestroyOperation(this, value);
		}
		
		public function read(value:*, clazz:Class = null):IOperation
		{
			/*if (model)
			{
				var type:Type = Type.forClass(model);
				
				trace("type " + type.name + " has parse metadata? " + type.hasMetaData("Parse"));
				
				if (type.hasMetaData("Parse"))
				{
					var m:MetaData = MetaData(type.getMetaData("Parse")[0]);
					
					if (m.hasArgumentWithKey("reader"))
					{
						var mArg:MetaDataArgument = m.getArgument("reader");
						
						trace("Creating a reader with name :: " + mArg.value);
						
						try
						{
							var reader:Class = ClassUtils.forName(mArg.value);
							return ClassUtils.newInstance(reader, [value]);
						}
						catch (e:Error)
						{
							throw new Error("Problem creating reader class - " + e.message);
						}
					}
				}
			}*/
			
			return format == Format.XML ? new ReadXMLOperation(new XML(value)) : new ReadJSONOperation(value as String, clazz);
		}
		
		public function write(value:*, verb:Verb, writeContext:WriteContext = null, writeName:Boolean = true):IOperation
		{
			/*var type:Type = Type.forInstance(value);
			
			trace("type " + type.name + " has parse metadata? " + type.hasMetaData("Parse"));
			
			if (type.hasMetaData("Parse"))
			{
				var m:MetaData = MetaData(type.getMetaData("Parse")[0]);
				
				if (m.hasArgumentWithKey("writer"))
				{
					var mArg:MetaDataArgument = m.getArgument("writer");
					
					trace("Creating a writer with name :: " + mArg.value + " for " + value + ", " + verb);
					
					try
					{
						var writer:Class = ClassUtils.forName(mArg.value);
						return ClassUtils.newInstance(writer, [this, value, verb, serviceContext || new ServiceContext(), writeName]);
					}
					catch (e:Error)
					{
						throw new Error("Problem creating writer class - " + e.message);
					}
				}
			}*/
			trace("Writing format : " + format); 
			writeContext = writeContext || new WriteContext();
			
			return format == Format.XML ? new WriteXMLOperation(this, value, verb, writeContext) : new WriteJSONOperation(this, value, verb, writeContext, writeName);
		}
	}
}