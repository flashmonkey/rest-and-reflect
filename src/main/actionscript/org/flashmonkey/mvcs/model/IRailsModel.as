package org.flashmonkey.mvcs.model
{
	[Bindable] public interface IRailsModel extends IRestModel
	{
		function get created_at():String;
		function set created_at(value:String):void;
		
		function get updated_at():String;
		function set updated_at(value:String):void;
	}
}