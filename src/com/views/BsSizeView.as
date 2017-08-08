package com.views
{
	import com.Control.SelectDispatcher;
	import com.Data.CanvasData;
	import com.Event.SelectEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BsSizeView extends Sprite
	{
		private var thisbg:HBDX_bg;
		private var currMc:MovieClip;
		public function BsSizeView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addedTostage);
		}
		
		protected function addedTostage(event:Event):void
		{
			// TODO Auto-generated method stub
			thisbg=new HBDX_bg();
			this.addChild(thisbg);
			for (var i:int = 1; i < 7; i++) 
			{
				thisbg["size"+i].addEventListener(MouseEvent.CLICK,onClick);
			}
			
			thisbg.size4.gotoAndStop(2);
			currMc=thisbg.size4;
			thisbg.bg.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(currMc){
				currMc.gotoAndStop(1);
			}
			var tg:MovieClip=event.currentTarget as MovieClip;
			switch(tg.name)
			{
				case "size1":
				{
					CanvasData.brushSize=5;
					break;
				}
				case "size2":
				{
					CanvasData.brushSize=6;
					break;
				}
				case "size3":
				{
					CanvasData.brushSize=8;
					break;
				}
				case "size4":
				{
					CanvasData.brushSize=10;
					break;
				}
				case "size5":
				{
					CanvasData.brushSize=12;
					break;
				}
				case "size6":
				{
					CanvasData.brushSize=15;
					break;
				}
					
				default:
				{
					break;
				}
					
			}
			currMc=tg;
			currMc.gotoAndStop(2);
			if(tg.name.substring(0,4)=="size"){
				trace("当前选择笔刷大小<",CanvasData.brushSize,">");
			}
			SelectDispatcher.getInstance().dispatchEvent(new SelectEvent(SelectEvent.SIZE_SELECT));
			
		}
	}
}