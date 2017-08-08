package com.king.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ViewObject extends Sprite implements KingObject
	{
		private var _listeners:Array=[];
		private var myname:String;
		public function ViewObject($name:String="ViewObject")
		{
			super();
			myname=$name;
			this.addEventListener(Event.ADDED_TO_STAGE,addedToView);
		}
		
		protected function addedToView(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,addedToView);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromView);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			// TODO Auto Generated method stub
			_listeners.push({type:type,listener:listener});
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		protected function removeFromView(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromView);
			onDispose();
		}
		
		public function onCreate():Boolean
		{
			// TODO Auto Generated method stub
			trace(this.myname+"被创建");
			return true;
		}
		public function onDispose():Boolean
		{
			// TODO Auto Generated method stub
			
			while(_listeners.length>0){
				var listener:Object=_listeners.pop();
				removeEventListener(listener.type,listener.listener);
			}
			var leg:int=this.numChildren;
			for (var i:int = 0; i < leg; i++) 
			{
				try
				{
					var child:*=this.removeChildAt(0);
					if(child is ViewObject){
						child.onDispose();
					}
					child=null;
				} 
				catch(error:Error) 
				{
					trace("移除子对象错误！"+child)
				}
			}
			this.graphics.clear();
			trace(this.myname+"被销毁:");
			return true;
		}
		
		public function onPause():Boolean
		{
			// TODO Auto Generated method stub
			trace(this.myname+"暂停");
			return true;
		}
		
		public function onReStart():Boolean
		{
			// TODO Auto Generated method stub
			trace(this.myname+"重新开始");
			return true;
		}
		
		
	}
}