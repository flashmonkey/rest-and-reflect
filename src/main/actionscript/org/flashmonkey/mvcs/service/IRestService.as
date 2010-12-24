package org.flashmonkey.mvcs.service
{
	import org.flashmonkey.mvcs.model.Format;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.operation.IOperation;

	public interface IRestService
	{
		function get format():Format;
		function set format(value:Format):void;
		
		function get context():String;
		function set context(value:String):void;
		
		function index(clazz:Class):IOperation;
		
		function show(value:IRestModel):IOperation;
		
		function create(value:IRestModel):IOperation;
		
		function update(value:IRestModel):IOperation;
		
		function destroy(value:IRestModel):IOperation;
		
		function read(value:*):IOperation;
		
		function write(value:IRestModel, verb:Verb):IOperation;
	}
}