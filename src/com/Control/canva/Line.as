package com.Control.canva 
{
	/**
	 * 线条
	 * @author Jio
	 */
	public class Line extends GraphBase
	{
		
		public function Line(c:uint = 0) 
		{
			super(c);
		}
		
		override public function begin(xx:Number, yy:Number):void 
		{
			this.graphics.lineStyle(this.sizes, color);
			this.graphics.moveTo(xx, yy);
			trace("Line begin!")
		}
		
		override public function draw(xx:Number, yy:Number):void 
		{
			this.graphics.lineTo(xx, yy);
			trace("Line Drawing!")
		}	
		
	}

}