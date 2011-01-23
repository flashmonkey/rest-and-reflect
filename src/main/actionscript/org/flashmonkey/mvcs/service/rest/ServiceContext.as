package org.flashmonkey.mvcs.service.rest
{
	public class ServiceContext
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
		
		public function ServiceContext(includes:Array = null, excludes:Array = null)
		{
			trace("creating context :" + includes + ":" + excludes);
			
			_includes = includes || [];
			_excludes = excludes || [];
			
			trace("creating context :" + _includes + ":" + _excludes);
		}
	}
}