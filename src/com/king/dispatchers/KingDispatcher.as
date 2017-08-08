package com.king.dispatchers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class KingDispatcher extends EventDispatcher
	{
		private static var _instance:KingDispatcher=new KingDispatcher;
		public function KingDispatcher(target:IEventDispatcher=null)
		{
			if(_instance){
				throw new Error("只能用getInstance()来获取实例");
			}
		}
		public static function getInstance():KingDispatcher{
			return _instance;
		}
	}
}