package com.king.events
{
	import flash.events.Event;
	
	public class PlayEvent extends Event
	{
		private var _data:*;
		public static const GET_VIDEO_TIME:String="GetVideoTime";
		public static const PLAY_OVER:String="PlayOver";
		public function PlayEvent(type:String,$data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
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