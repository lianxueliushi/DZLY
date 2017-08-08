package com.Event
{
	import flash.events.Event;
	
	public class PhotoEvent extends Event
	{
		public static const TAKE_PHOTO:String="takePhoto";
		private var _data:*;
		public static var CLOSE:String="closeThis";
		public function PhotoEvent(type:String,$data:*=null,bubbles:Boolean=true, cancelable:Boolean=false)
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