package com.Event
{
	import flash.events.Event;
	
	public class SelectEvent extends Event
	{
		public static const BG_SELECT:String="SELCET_BG";
		public static const TYPE_SELECT:String="SELCET_TYPE";
		public static const COLOR_SELECT:String="SELECT_COLOR";
		public static const SIZE_SELECT:String="SELECT_SIZE";
		private var da:*;
		public function SelectEvent(type:String, _data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			da=_data;
			super(type, bubbles, cancelable);
		}

		public function get data():*
		{
			return da;
		}

	}
}