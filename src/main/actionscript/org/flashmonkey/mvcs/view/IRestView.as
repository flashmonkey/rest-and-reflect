package org.flashmonkey.mvcs.view
{
	import org.osflash.signals.Signal;

	public interface IRestView
	{
		function get index():Signal;
		
		function get show():Signal;
		
		function get destroy():Signal;
		
		function get update():Signal;
		
		function get create():Signal;
		
		function get clearDialog():Signal;
	}
}