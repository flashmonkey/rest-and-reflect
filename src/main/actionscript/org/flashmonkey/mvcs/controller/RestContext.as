package org.flashmonkey.mvcs.controller
{
	import org.flashmonkey.mvcs.controller.command.CreateCommand;
	import org.flashmonkey.mvcs.controller.command.DestroyCommand;
	import org.flashmonkey.mvcs.controller.command.IndexCommand;
	import org.flashmonkey.mvcs.controller.command.ShowCommand;
	import org.flashmonkey.mvcs.controller.command.UpdateCommand;
	import org.flashmonkey.mvcs.controller.signal.Create;
	import org.flashmonkey.mvcs.controller.signal.Destroy;
	import org.flashmonkey.mvcs.controller.signal.Index;
	import org.flashmonkey.mvcs.controller.signal.Show;
	import org.flashmonkey.mvcs.controller.signal.Update;
	import org.flashmonkey.mvcs.model.IModel;
	import org.flashmonkey.mvcs.model.ISignalBus;
	import org.flashmonkey.mvcs.model.Model;
	import org.flashmonkey.mvcs.model.SignalBus;
	import org.flashmonkey.mvcs.service.IRestService;
	import org.flashmonkey.mvcs.service.rest.RestService;
	import org.robotlegs.mvcs.SignalContext;
	
	public class RestContext extends SignalContext
	{
		public function RestContext()
		{
			super(null, true);
		}
		
		public override function startup():void
		{
			injector.mapSingletonOf(IRestService, RestService);
			injector.mapSingletonOf(ISignalBus, SignalBus);
			injector.mapSingletonOf(IModel, Model);
				
			signalCommandMap.mapSignalClass(	Index, 		IndexCommand	);
			signalCommandMap.mapSignalClass(	Show, 		ShowCommand		);
			signalCommandMap.mapSignalClass(	Create, 	CreateCommand	);
			signalCommandMap.mapSignalClass(	Update, 	UpdateCommand	);
			signalCommandMap.mapSignalClass(	Destroy, 	DestroyCommand	);
			
			startupSignalBus(ISignalBus(injector.getInstance(ISignalBus)));
		}
		
		protected function startupSignalBus(signalBus:ISignalBus):void 
		{
			
		}
	}
}