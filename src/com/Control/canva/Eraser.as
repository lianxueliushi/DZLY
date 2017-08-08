package com.Control.canva 
{
	/**
	 * 橡皮
	 * @author Jio
	 */
	 import flash.display.BlendMode;
	public class Eraser extends Line
	{
		
		public function Eraser(c:uint=0xffffff) 
		{
			super(c);
			this.blendMode=BlendMode.ERASE;
		}
		override public function begin(xx:Number, yy:Number):void 
		{
			this.graphics.lineStyle(this.sizes, 0xffffff,0);
			this.graphics.moveTo(xx, yy);
		}
		
	}

}