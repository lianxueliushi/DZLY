package com.views
{
	import com.Control.SelectDispatcher;
	import com.king.data.CanvasData;
	import com.Event.SelectEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BsStyleView extends Sprite
	{
		private var thisbg:HBYS_bg;
		private var currMc:MovieClip;
		public function BsStyleView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addtoStage);
		}
		
		protected function addtoStage(event:Event):void
		{
			// TODO Auto-generated method stub
			thisbg=new HBYS_bg();
			this.addChild(thisbg);
			thisbg.b0.gotoAndStop(2);
			currMc=thisbg.b0;
			thisbg.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(currMc){
				currMc.gotoAndStop(1);
			}
			var tg:MovieClip=event.target as MovieClip;
			tg.gotoAndStop(2);
			currMc=tg;
			var n:int=0;
			var ischange:Boolean=false;
			switch(tg.name)
			{
				case "b0":
				case "b1":
				case "b2":
				case "b3":
				case "b4":
				case "b5":
				{
					n=parseInt(tg.name.substring(1));
					CanvasData.TypeClass=n;//设置样式
					trace("当前选择样式<",n,">");
					ischange=true;
					break;
				}
			}
			SelectDispatcher.getInstance().dispatchEvent(new SelectEvent(SelectEvent.TYPE_SELECT,"change"));
		}
	}
}