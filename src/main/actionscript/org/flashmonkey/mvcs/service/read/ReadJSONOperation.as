package org.flashmonkey.mvcs.service.read
{
	import com.adobe.serialization.json.JSON;
	
	import org.flashmonkey.operations.service.AbstractOperation;
	
	public class ReadJSONOperation extends AbstractJSONReader
	{
		public function ReadJSONOperation(source:String)
		{
			super(source);
		}
		
		protected override function newObject():*
		{
			return new Object();
		}
	}
}