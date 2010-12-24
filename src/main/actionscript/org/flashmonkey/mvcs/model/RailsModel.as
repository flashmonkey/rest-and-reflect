package org.flashmonkey.mvcs.model
{
	[Bindable][RemoteClass] public class RailsModel extends RestModel implements IRailsModel
	{
		public function RailsModel()
		{
			super();
		}
		
		private var _createdAt:String;
		
		[Ignore]
		public function get created_at():String
		{
			return _createdAt;
		}
		public function set created_at(value:String):void
		{
			_createdAt = value;
		}
		
		private var _updatedAt:String;
		
		[Ignore]
		public function get updated_at():String
		{
			return _updatedAt;
		}
		public function set updated_at(value:String):void
		{
			_updatedAt = value;
		}
	}
}