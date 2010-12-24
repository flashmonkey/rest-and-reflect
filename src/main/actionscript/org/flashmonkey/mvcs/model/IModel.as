package org.flashmonkey.mvcs.model
{
	public interface IModel
	{
		function set(name:String, value:*):void;
		
		function get(name:String):*;
	}
}