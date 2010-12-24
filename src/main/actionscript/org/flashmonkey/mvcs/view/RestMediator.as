package org.flashmonkey.mvcs.view
{
	import org.flashmonkey.mvcs.controller.signal.Create;
	import org.flashmonkey.mvcs.controller.signal.Destroy;
	import org.flashmonkey.mvcs.controller.signal.Index;
	import org.flashmonkey.mvcs.controller.signal.Show;
	import org.flashmonkey.mvcs.controller.signal.Update;
	import org.flashmonkey.mvcs.model.IRestModel;
	import org.flashmonkey.mvcs.model.ISignalBus;
	import org.robotlegs.mvcs.Mediator;
	
	public class RestMediator extends Mediator
	{
		[Inject] public var view:IRestView;
		
		[Inject] public var signalBus:ISignalBus;
		
		[Inject] public var index:Index;
		
		[Inject] public var show:Show;
		
		[Inject] public var create:Create;
		
		[Inject] public var update:Update;
		
		[Inject] public var destroy:Destroy;
		
		public function RestMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			view.index.add(onIndex);
			view.show.add(onShow);
			view.create.add(onCreate);
			view.update.add(onUpdate);
			view.destroy.add(onDestroy);
		}
		
		public override function onRemove():void
		{
			view.index.remove(onIndex);
			view.show.remove(onShow);
			view.create.remove(onCreate);
			view.update.remove(onUpdate);
			view.destroy.remove(onDestroy);
		}
		
		protected function onIndex(value:Class):void 
		{
			index.dispatch(value);
		}
		
		protected function onCreate(value:IRestModel):void 
		{
			create.dispatch(value);
		}
		
		protected function onShow(value:IRestModel):void 
		{
			show.dispatch(value);
		}
		
		protected function onUpdate(value:IRestModel):void 
		{
			update.dispatch(value);
		}
		
		protected function onDestroy(value:IRestModel):void 
		{
			destroy.dispatch(value);
		}
	}
}