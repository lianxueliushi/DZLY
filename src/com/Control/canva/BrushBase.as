package com.Control.canva 
{
	import com.king.data.PicwallData;
	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	//import flash.geom.Matrix;
	
	/**
	 * 笔刷效果的基类
	 * 所有笔刷效果都继承此类，重新设置了笔刷的点，以及笔刷点之间的间距
	 */
	public class BrushBase extends GraphBase
	{
		protected var startX:Number;
		protected var startY:Number;
		protected var oldScale:Number;
		protected var ctf:ColorTransform;
		protected var dot:Class;
		protected var randomRotation:Boolean;//是否随机分布
		protected var gap:Number;	
		
		/**
		 * 
		 * @param c color
		 * @param gap 间距
		 * @param dot 形状
		 * @param randomRotation 
		 * 
		 */		
		public function BrushBase(c:uint, gap:Number, dot:Class, randomRotation:Boolean=false) 
		{
			super(c);	
			ctf = new ColorTransform();
			ctf.color = c;
			this.dot = dot;
			this.gap = gap;
			this.randomRotation = randomRotation;			
			//this.sizes=10;
		}
		
		override public function begin(xx:Number, yy:Number):void 
		{
			startX = xx;
			startY = yy;
			oldScale = 1.3;
		}
		
		override public function draw(xx:Number, yy:Number):void 
		{
			var dx:Number = xx - startX;
			var dy:Number = yy - startY;
			var dd:Number =Point.distance(new Point(xx,yy),new Point(startX,startY));
			var n:int = Math.ceil(dd / gap);
			/**2014-12-20修改**/
			var scale:Number =1.3-dd*0.03;
			if (scale <= 0.2)
			{
				scale = 0.2;
			}
			scale = (oldScale + scale) / 2;
			var scaleBili:Number = (oldScale - scale) / n;
			for (var i:int = 0; i < n; i++) {
				var d:* = new dot();
				var sc:Number=oldScale-i*scaleBili;
				d.x = dx / n * (i+1)+ startX;
				d.y = dy / n * (i+1) + startY;
				d.transform.colorTransform = ctf;
				if (randomRotation) {
					d.rotation+=Math.asin(Math.abs(dy)/dd);
				}		
				d.alpha=0.9;
				addChild(d);
				d.scaleX = d.scaleY = sc*sizes/10;
				d.x = (dx / n) * (i + 1) + startX;
				d.y = (dy / n) * (i + 1) + startY;
			}
			changeToBitmap(PicwallData.wid,PicwallData.heg);
			/**2014-12-20修改**/
			//更新起始点，使当前坐标成为下一个起始点
			oldScale = scale;
			startX = mouseX;
			startY = mouseY;
		}
		
	}
	
}