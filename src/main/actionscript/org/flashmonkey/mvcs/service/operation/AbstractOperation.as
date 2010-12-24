package org.flashmonkey.mvcs.service.operation
{
	import org.osflash.signals.Signal;
	
	public class AbstractOperation implements IOperation
	{
		public function AbstractOperation()
		{
		}
		
		private var _displayName:String;
		
		public function get displayName():String
		{
			return _displayName;
		}
		
		private var _completeSignal:Signal
		
		public function get onComplete():Signal
		{
			return _completeSignal || (_completeSignal = new OperationSignal());
		}
		
		private var _errorSignal:Signal;
		
		public function get onError():Signal
		{
			return _errorSignal || (_errorSignal = new OperationSignal());
		}
		
		private var _result:*;
		
		public function get result():*
		{
			return _result;
		}
		
		private var _error:*;
		
		public function get error():*
		{
			return _error;
		}
		
		public function execute():void
		{
		}
		
		public function addCompleteListener(f:Function):IOperation
		{
			onComplete.add(f);
			
			return this;
		}
		
		public function addErrorListener(f:Function):IOperation
		{
			onError.add(f);
			
			return this;
		}
		
		protected function dispatchComplete(value:* = null):void
		{
			if (value !== _result)
			{
				_result = value;
			}
			
			onComplete.dispatch(this);
		}
		
		protected function dispatchError(value:*):void 
		{
			if (value !== _error)
			{
				_error = value;
			}
			
			onError.dispatch(this);
		}
	}
}