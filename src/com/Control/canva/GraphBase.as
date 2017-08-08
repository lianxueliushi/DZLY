package com.Control.canva 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * 定义各种绘制图形的基类
	 * 所有绘制的形状都继承自此类，并重写了begin方法和draw方法
	 * begin在开始画线时调用，draw在鼠标移动画线时不停调用
	 */
	public class GraphBase extends Sprite
	{   
		protected var sizes:Number=10;
		protected var color:uint;
		public function GraphBase(c:uint = 0) 
		{
			color = c;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		public function begin(xx:Number, yy:Number):void {}
		public function draw(xx:Number, yy:Number):void {}		
		public function set size(_vl:Number):void{
			sizes=_vl;
		}
		public function get size():Number{
			return sizes;
		}
		/**
		 *将线条转位图，节省资源 
		 * @param ww 画布宽
		 * @param hh 画布高
		 * 
		 */		
		public function changeToBitmap(ww:Number, hh:Number):void 
		{						
			var bmd:BitmapData = new BitmapData(ww, hh, true, 0);
			bmd.draw(this);
			var bmp:Bitmap = new Bitmap(bmd);				
			while (numChildren > 0) {
				removeChildAt(0);
			}
			addChild(bmp);		
		}
	}
	
}