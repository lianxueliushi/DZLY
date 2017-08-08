package com.views
{
	import com.Control.SelectDispatcher;
	import com.Data.CanvasData;
	import com.Event.SelectEvent;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BsColorView extends Sprite
	{
		private var thisbg:HBCOLOR_bg;
		public function BsColorView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,addedtoStage);
			thisbg=new HBCOLOR_bg();
			this.addChild(thisbg);
			var leg:int=thisbg.numChildren-3;
			for (var i:int = 1; i < leg+1; i++) 
			{
				thisbg["c"+i].addEventListener(MouseEvent.CLICK,onClick);
			}
			
			thisbg.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var tg:MovieClip=event.currentTarget as MovieClip;
			var me:String=tg.name;
			var bmpd:BitmapData;
			switch(me.substring(0,1))
			{
				case "c":
				{
					thisbg.right.x=tg.x;
					bmpd=new BitmapData(tg.width,tg.height,false,0x000000);
					bmpd.draw(tg);
					//trace(mouseX,mouseY);
					CanvasData.brushColor=bmpd.getPixel(tg.mouseX,tg.mouseY);
					trace("当前选择颜色<",CanvasData.brushColor,">");
					break;
				}
					
				default:
				{
					break;
				}
			}
			SelectDispatcher.getInstance().dispatchEvent(new SelectEvent(SelectEvent.COLOR_SELECT));
		}
	}
}