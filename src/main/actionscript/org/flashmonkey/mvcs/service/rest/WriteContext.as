package org.flashmonkey.mvcs.service.rest
{
	public class WriteContext
	{
		private var _includes:Array;
		
		public function get includes():Array
		{
			return _includes;
		}
		
		private var _excludes:Array;
		
		public function get excludes():Array
		{
			return _excludes;
		}
		
		public function WriteContext(includes:Array = null, excludes:Array = null)
		{
			trace("creating context :" + includes + ":" + excludes);
			
			_includes = includes || [];
			_excludes = excludes || [];
			
			trace("creating context :" + _includes + ":" + _excludes);
		}
	}
}