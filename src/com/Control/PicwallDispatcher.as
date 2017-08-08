package com.Control
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PicwallDispatcher extends EventDispatcher
	{
		private static var instance:PicwallDispatcher;
		public function PicwallDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():PicwallDispatcher{
			if(instance==null){
				instance=new PicwallDispatcher();
				
			}
			return instance;
		}
	}
}