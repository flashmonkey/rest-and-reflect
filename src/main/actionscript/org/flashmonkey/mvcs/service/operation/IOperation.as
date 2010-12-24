package org.flashmonkey.mvcs.service.operation
{
	import org.osflash.signals.Signal;

	public interface IOperation
	{
		function get displayName():String;
		
		function get onComplete():Signal;
		
		function get onError():Signal;
		
		function get result():*;
		
		function get error():*;
		
		function execute():void;
		
		function addCompleteListener(f:Function):IOperation;
		
		function addErrorListener(f:Function):IOperation;
	}
}