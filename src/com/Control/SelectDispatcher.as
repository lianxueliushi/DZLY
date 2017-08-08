package com.Control
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SelectDispatcher extends EventDispatcher
	{
		private static var _instance:SelectDispatcher;
		public function SelectDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():SelectDispatcher{
			if(_instance==null){
				_instance=new SelectDispatcher();
				return _instance;
			}
			else{
				return _instance;
			}
		}
	}
}