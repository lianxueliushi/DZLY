package com.Event
{
	import flash.events.Event;
	
	public class PicwallEvent extends Event
	{
		private var _data:*;
		public static const PIC_CLICK:String="picClick";
		public static const PIC_REMOVED:String="picRemoved";
		
		public function PicwallEvent(type:String, $data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
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