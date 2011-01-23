package org.flashmonkey.mvcs.service.write
{
	import mx.collections.IList;
	
	import org.as3commons.reflect.Accessor;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.util.StringUtils;
	
	public class ListRestPropertyWriter extends AbstractRestPropertyWriter
	{
		public function ListRestPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb, includes:Array, excludes:Array)
		{
			super(accessor, object, verb, includes, excludes);
		}
		
		public override function get json():String
		{
			if (_json) return _json;
			
			_json = '{"' + accessor.name '":[';
			
			for each (var model:IRestModel in (accessor.getValue(object) as IList))
			{
				_json += model.toJson(verb, includes, excludes);
			}
			
			_json += ']}';
			
			return _json;
		}
		
		public override function get xml():XML
		{
			if (_xml) return _xml;
			
			_xml = <{accessor.name}/>
			
			for each (var model:IRestModel in (accessor.getValue(object) as IList))
			{
				_xml.appendChild(model.toXml(verb, includes, excludes));
			}
			
			return _xml;
		}
	}
}