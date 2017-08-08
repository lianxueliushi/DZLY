package com.Control
{
	import com.Control.canva.GraphBase;
	import com.Data.CanvasData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MyCanvas extends Sprite
	{
		private var _wid:Number;
		private var _heg:Number;
		private var _shapeList:Array;
		private var ismouseDown:Boolean;
		/**
		 *撤销次数 
		 */		
		private var undoNum:int=3;
		public function MyCanvas($wid:Number,$heg:Number,$bgColor:uint=0xffffff)
		{
			super();
			_wid=$wid;
			_heg=$heg;
			_shapeList=new Array();
			this.graphics.beginFill($bgColor,0);
			this.graphics.drawRect(0,0,_wid,_heg);
			this.graphics.endFill();
			init();
		}
		private function init():void
		{
			// TODO Auto Generated method stub
			this.addChild(canvasBg);
			this.addChild(tempBg);
			this.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			this.addEventListener(MouseEvent.MOUSE_UP, stopDraw);
			this.addEventListener(MouseEvent.MOUSE_MOVE, drawing);
			this.addEventListener(MouseEvent.ROLL_OUT, stopDraw);
		}
		protected function drawing(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(!ismouseDown){
				return;
			}
			var brush:GraphBase=_shapeList[_shapeList.length-1];
			brush.draw(mouseX,mouseY);
		}
		protected function stopDraw(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(!ismouseDown){
				return;
			}
			ismouseDown=false;
		}
		private var tempBg:Sprite=new Sprite();
		private var canvasBg:Sprite=new Sprite();
		protected function startDraw(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			ismouseDown=true;
			var brushType:Class=CanvasData.brushType;
			var brush:GraphBase=new brushType(CanvasData.brushColor);
			brush.size=CanvasData.brushSize;
			brush.begin(mouseX,mouseY);
			canvasBg.addChild(brush);
			_shapeList.push(brush);
			var leg:int=_shapeList.length;
			trace("_shapeList.length:"+_shapeList.length);
			if(leg>undoNum){
				var tg:GraphBase=_shapeList.shift();
				tempBg.addChild(tg);
				var bmp:Bitmap=toBitmap(tempBg);
				while(tempBg.numChildren>0){
					tempBg.removeChildAt(0);
				}
				tempBg.addChild(bmp);
				trace("remove:"+tg);
			}
		}
		/**
		 *撤销 
		 * 
		 */		
		public function undo():void{
			var leg:int=_shapeList.length;
			trace("撤销");
			if(leg>0){
				var tg:GraphBase=_shapeList.pop();
				this.removeChild(tg);
			}
		}
		/**
		 *转为位图 
		 * @param $mc
		 * @return 位图对象
		 * 
		 */		
		private function toBitmap($mc:DisplayObjectContainer):Bitmap{
			var bmp:Bitmap=new Bitmap();
			var bmpd:BitmapData=new BitmapData(_wid,_heg,true,0);
			bmpd.draw($mc);
			bmp.bitmapData=bmpd;
			return bmp;
		}
		/**
		 *清除 
		 * 
		 */		
		public function clear():void
		{
			// TODO Auto Generated method stub
			trace("清除");
			while(tempBg.numChildren>0){
				tempBg.removeChildAt(0);
			}
			while(canvasBg.numChildren>0){
				canvasBg.removeChildAt(0);
			}
			_shapeList=[];
			
		}
	}
}