package org.flashmonkey.mvcs.service.read
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.as3commons.lang.ClassUtils;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Noun;
	import org.flashmonkey.mvcs.service.operation.AbstractOperation;
	
	public class ReadXMLOperation extends AbstractOperation
	{
		private var _source:XML;
		
		public function ReadXMLOperation(source:XML)
		{
			super();
			
			_source = source;
		}
		
		public override function execute():void
		{
			trace("READING:\n" + _source);
			
			if (_source)
			{
				if (_source.@type == "array")
				{
					var list:IList = new ArrayCollection();
					var noun:Noun;
					
					for each (var child:XML in _source.children())
					{
						if (!noun) noun = Noun.forName(_source.name());

						list.addItem(parseModel(Noun.newInstance(noun), child.children()));
					}
					
					dispatchComplete(list);
				}
				else if (_source.children().length() > 0)
				{
					dispatchComplete(parseModel(Noun.newInstance(_source.name()), _source.children()));
				}
				else
				{
					dispatchComplete();
				}
			}
		}
		
		private function parseModel(model:IRestModel, properties:XMLList):* 
		{
			for each (var property:XML in properties)
			{
				model[property.name()] = property.toString();
			}
			
			return model;
		}
	}
}