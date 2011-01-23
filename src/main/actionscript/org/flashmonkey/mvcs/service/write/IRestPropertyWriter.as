package org.flashmonkey.mvcs.service.write
{
	public interface IRestPropertyWriter
	{
		function get can():Boolean;
		
		function get json():String;
		
		function get xml():XML;
	}
}