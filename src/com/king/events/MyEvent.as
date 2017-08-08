package com.king.events
{
	import flash.events.Event;
	
	public class MyEvent extends Event
	{
		private var _data:*;
		public static const MOUSE_CLICK:String="ImgMouseClick";
		public static var CELL_CLICK:String="VsCellClick";
		public static var DragEndToBottom:String="VsDragendtoBottom";
		public function MyEvent(type:String,$data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data=$data;
			super(type, bubbles, cancelable);
		}
		public function get data():*
		{
			return _data;
		}
	}
}