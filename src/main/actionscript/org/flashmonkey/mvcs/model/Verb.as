package org.flashmonkey.mvcs.model
{
	public class Verb
	{
		public static const GET:Verb = new Verb("GET");
		public static const POST:Verb = new Verb("POST");
		public static const PUT:Verb = new Verb("PUT");
		public static const DELETE:Verb = new Verb("DELETE");
		
		private static var _enumCreated:Boolean = false;
		
		{
			_enumCreated = true;
		}
		
		private var _name:String;
		
		public function Verb(name:String)
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