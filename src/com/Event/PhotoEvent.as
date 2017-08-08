package com.Event
{
	import flash.events.Event;
	
	public class PhotoEvent extends Event
	{
		private var _data:*;
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