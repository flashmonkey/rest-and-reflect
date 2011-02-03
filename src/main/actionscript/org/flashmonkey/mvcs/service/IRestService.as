package org.flashmonkey.mvcs.service
{
	import org.flashmonkey.mvcs.model.Format;
	import org.flashmonkey.mvcs.model.IModel;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.Verb;
	import org.flashmonkey.mvcs.service.rest.WriteContext;
	import org.flashmonkey.operations.service.IOperation;

	public interface IRestService
	{
		function get airAvailable():Boolean;
		function set airAvailable(value:Boolean):void;
		
		function get format():Format;
		function set format(value:Format):void;
		
		function get context():String;
		function set context(value:String):void;
		
		function index(clazz:Class):IOperation;
		
		function show(value:IRestModel):IOperation;
		
		function create(value:IRestModel, writeContext:WriteContext = null):IOperation;
		
		function update(value:IRestModel, writeContext:WriteContext = null):IOperation;
		
		function destroy(value:IRestModel):IOperation;
		
		function read(value:*, model:Class = null):IOperation;
		
		function write(value:*, verb:Verb, writeContext:WriteContext = null, writeName:Boolean = true):IOperation;
	}
}