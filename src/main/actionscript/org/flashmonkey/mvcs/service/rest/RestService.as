package org.flashmonkey.mvcs.service.rest
{
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.DictionaryUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.Type;
	import org.flashmonkey.mvcs.model.Format;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.operation.IOperation;
	import org.flashmonkey.mvcs.service.read.ReadXMLOperation;
	import org.flashmonkey.mvcs.service.write.WriteXMLOperation;
	
	public class RestService implements IRestService
	{
		private var _context:String = "http://localhost:3000";
		
		public function get context():String
		{
			return _context;
		}
		public function set context(value:String):void
		{
			_context = value;
		}
		
		private var _urlCache:Dictionary = new Dictionary();
		
		private var _format:Format;
		
		public function get format():Format
		{
			return _format;
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
		
		public function create(value:IRestModel):IOperation
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
					
					return new UploadOperation(this, value, a, dataField);
				}
				
			}
			
			return new CreateOperation(this, value);
		}
		
		public function update(value:IRestModel):IOperation
		{
			return new UpdateOperation(this, value);
		}
		
		public function destroy(value:IRestModel):IOperation
		{
			return new DestroyOperation(this, value);
		}
		
		public function read(value:*):IOperation
		{
			return new ReadXMLOperation(value as XML);
		}
		
		public function write(value:IRestModel, verb:Verb):IOperation
		{
			return new WriteXMLOperation(value, verb);
		}
	}
}