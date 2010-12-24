package org.flashmonkey.mvcs.model
{
	public class Format
	{
		public static const XML:Format = new Format(".xml");
		public static const JSON:Format = new Format(".json");
		
		private static var _enumCreated:Boolean = false;
		
		{
			_enumCreated = true;
		}
		
		private var _name:String;
		
		public function Format(name:String)
		{
			if (_enumCreated)
			{
				throw new Error("The enum is already created.");
			}
			
			_name = name;
		}
		
		public function toString():String 	
		{
			return _name;
		}
	}
}