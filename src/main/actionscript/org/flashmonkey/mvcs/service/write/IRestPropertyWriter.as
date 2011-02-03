package org.flashmonkey.mvcs.service.write
{
	import flash.net.URLVariables;

	public interface IRestPropertyWriter
	{
		function set writeSuffix(suffix:String):void;
		
		function canWrite(includes:Array, excludes:Array):Boolean;
		
		function writeJson(includes:Array, excludes:Array):String;
		
		function writeXml(includes:Array, excludes:Array):XML;
		
		function writeUrlVariables(urlVariables:URLVariables, includes:Array, excludes:Array):void;
	}
}