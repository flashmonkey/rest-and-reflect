package org.flashmonkey.mvcs.service.write
{
	import org.as3commons.reflect.Accessor;
	import org.flashmonkey.mvcs.model.IRestModel;

	public class PrimitiveRestPropertyWriter extends AbstractRestPropertyWriter
	{
		public function PrimitiveRestPropertyWriter(accessor:Accessor, object:IRestModel, verb:Verb, includes:Array, excludes:Array)
		{
			super(accessor, object, verb, includes, excludes);
		}
		
		public override function get json():String
		{
			return '{"' + accessor.name + '":"' + accessor.getValue(object).toString() + '"}';
		}
		
		public override function get xml():XML
		{
			return <{accessor.name}>{accessor.getValue(object).toString()}</{accessor.name}>;
		}
	}
}