package com.king.events
{
	import flash.events.Event;
	
	public class NavigatorEvent extends Event
	{
		private var _data:*;
		public static const ADD_VIEW:String="NavigatorAddView";
		public static const REMOVE_VIEW:String="NavigatorRemoveView";
		public static const BACK_VIEW:String="NavigatorBackView";//返回首页
		public function NavigatorEvent(type:String,$data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
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