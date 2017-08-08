package com.king.control
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AddTouchDrag extends AddDownUpMoveClick
	{
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _rotation:Number = 0;
		private var _scale:Number = 1;
		private var _alpha:Number = 1;
		private var _rot:Number = 0;
		private var _secondPoint:Object = null;
		private var _time:Number=0.3;
		private var _moveTime:Number=0.3;
		private var _moveTimeEnd:Number=1;
		private var _xishu:Number=40;//缓动结束后的增幅系数
		private var _localPoint:Point=new Point();
		public var outScreen:Function=null;
		public static var outScreenUp:String="up";
		public static var outScreenDown:String="down";
		public static var outScreenLeft:String="left";
		public static var outScreenRight:String="right";
		private var minWidthHeight:Number=150;
		private var maxWidthHeight:Number=1500;
		public function AddTouchDrag(display:InteractiveObject)
		{
			super(display);
			
		}
		override protected function downEvent(stageX:Number,stageY:Number,touchPointID:int):void
		{  
			//trace("开始拖动");
			//  Global.txt.appendText("  stageX:"+stageX+"  stageY:"+stageY+"  touchPointID:"+touchPointID+"\n");
			_time=_moveTime;
			super.downEvent(stageX,stageY,touchPointID);
			_x = _display.x;
			_y = _display.y;
			_rotation = _rot;
			_scale = _display.scaleX;
			_alpha = _display.alpha;
			_rot = _display.rotation;
			
			settingTouchArray();
			this._display.parent.setChildIndex(this._display,this._display.parent.numChildren-1);
		}
		
		
		private function settingTouchArray():void
		{
			//_secondPoint
			var obj0:Object;
			var obj1:Object;
			var obj2:Object;
			var len:int = _touchPointArray.length;
			if(len==0){
				return;
			}
			obj0=_touchPointArray[0];
			obj0.localPoint=_display.globalToLocal(obj0.stagePoint);
			_localPoint=obj0.localPoint;
			//_localPoint=obj0.stagePoint;
			if (len<2)
			{
				_secondPoint = null;
			}
			else
			{  
				obj0.dis=0;
				obj1=obj0;
				for (var i:int=1; i<len; i++)
				{    obj2=_touchPointArray[i];
					
					obj2.dis=Point.distance(obj0.stagePoint,obj2.stagePoint);
					if(obj1.dis<obj2.dis){
						obj1=obj2;
					}
					
				}
				var point:Point=obj1.stagePoint.subtract(obj0.stagePoint);
				obj1.rotation=Math.atan2(point.y,point.x);
				_secondPoint=obj1;
				_secondPoint.localPoint=obj0.localPoint;
			}
		}
		
		override protected function touchDownobjStart(obj:Object):void{
			super.touchDownobjStart(obj);
		}
		
		override protected function moveEvent(stageX:Number,stageY:Number,touchPointID:int):void
		{
			super.moveEvent(stageX,stageY,touchPointID);
			var index:int=getIndexObjArray(touchPointID);
			if(index==-1){
				return;
			}
			var xx:Number=0;
			var yy:Number=0;
			var obj:Object=_touchPointArray[index];
			var obj0:Object=_touchPointArray[0];
			
			var oldStagePoint:Point=obj.stagePoint;
			
			var nowStagePoint:Point=new Point(stageX,stageY);
			
			obj.stagePoint=nowStagePoint;
			//_localPoint=obj0.stagePoint;
			if(_secondPoint){
				var dis:Number=Point.distance(obj0.stagePoint,_secondPoint.stagePoint);
				_scale*=dis/_secondPoint.dis;
				_display.scaleX=_scale;
				_display.scaleY=_scale;
				if(_display.width<minWidthHeight){
					_display.width=minWidthHeight;
					_display.scaleY=_display.scaleX;
				}else if(_display.width>maxWidthHeight){
					_display.width=maxWidthHeight;
					_display.scaleY=_display.scaleX;
				}
				if(_display.height<minWidthHeight){
					_display.height=minWidthHeight;
					_display.scaleX=_display.scaleY;
				}else if(_display.height>maxWidthHeight){
					_display.height=maxWidthHeight;
					_display.scaleX=_display.scaleY;
				}
				
				_secondPoint.dis=dis;
				var point:Point=_secondPoint.stagePoint.subtract(obj0.stagePoint);
				var disrota:Number=Math.atan2(point.y,point.x);
				_rotation+=(disrota-_secondPoint.rotation)*180/Math.PI;
				_display.rotation=_rotation;
				_secondPoint.rotation=disrota;
				var nowPoint:Point=this._display.localToGlobal(_localPoint);
				xx=obj0.stagePoint.x-nowPoint.x;
				yy=obj0.stagePoint.y-nowPoint.y;
				_display.x+=xx;
				_display.y+=yy;
				_x+=xx;
				_y+=yy;
				//_localPoint=_display.globalToLocal(obj0.stagePoint);
				TweenLite.to(this,_time,{x:_x,y:_y});
				
			}else{
				//this._display.localToGlobal(obj0.localPoint);
				
				xx=nowStagePoint.x-oldStagePoint.x;
				yy=nowStagePoint.y-oldStagePoint.y;
				_x+=xx;
				_y+=yy;
				obj0.movePoint=new Point(xx,yy);
				//trace(_x,_y)
				//trace(_time);
				//TweenLite.to(this,_time,{x:_x,y:_y});
				TweenLite.to(this,_time,{x:_x,y:_y});
			}
		}
		
		override protected function endEvent(stageX:Number,stageY:Number,touchPointID:int):void
		{
			super.endEvent(stageX,stageY,touchPointID);
			
			
			settingTouchArray();
			
			
		}
		override protected function touchEndObj(obj:Object,index:int):void{
			//trace(obj,index)
			super.touchEndObj(obj,index);
			
		}
		override protected function touchEndObjOver(obj:Object,index:int):void{
			super.touchEndObjOver(obj,index);
			_time=_moveTimeEnd;
			if(obj.movePoint){
				_x+=obj.movePoint.x*_xishu;
				_y+=obj.movePoint.y*_xishu;
			}
			var rect:Rectangle = new Rectangle(0,0,this._stage.stageWidth,_stage.stageHeight);
			var stPoint:Point = _display.localToGlobal(new Point(0,0));
			if (! rect.containsPoint(stPoint))
			{
				if (stPoint.y < 0)
				{
					_y=0;
				}
				
				else if (stPoint.y>_stage.stageHeight-_display.height)
				{
					_y=_stage.stageHeight-_display.height;
				}
				if (stPoint.x<0)
				{
					_x=0;
				}
				else if (stPoint.x>_stage.stageWidth-_display.width)
				{
					_x=_stage.stageWidth-_display.width;
				}
				trace("调整位置",_x,_y);
			}
			
//			TweenLite.to(this,_time,{x:_x,y:_y,onComplete:tweenComEnd});
			
		}
		public function set rotation(vl:Number):void
		{  
			//var localPoint:Point=_touchPointArray[0].localPoint;
			var oldPoint:Point=this._display.localToGlobal(_localPoint);
			_rot = vl;
			_display.rotation = vl;
			var nowPoint:Point=this._display.localToGlobal(_localPoint);
			
			setLocalPoint(oldPoint,nowPoint);
		}
		public function get rotation():Number
		{
			
			return _rot;
			
		}
		public function set scale(vl:Number):void
		{  		///var localPoint:Point=_touchPointArray[0].localPoint;
			var oldPoint:Point=this._display.localToGlobal(_localPoint);
			_display.scaleX = vl;
			_display.scaleY = vl;
			var nowPoint:Point=this._display.localToGlobal(_localPoint);
			
			setLocalPoint(oldPoint,nowPoint);
			
		}
		public function get scale():Number
		{
			return _display.scaleX;
		}
		public function get x():Number{
			
			return this._display.x;
		}
		public function set x(vl:Number):void{
			
			this._display.x=vl;
		}
		
		
		public function get y():Number{
			
			return this._display.y;
		}
		public function set y(vl:Number):void{
			
			this._display.y=vl;
		}
		private function setLocalPoint(_stageOldPoint:Point,_stageNowPoint:Point):void{
			var xxx:Number=_stageOldPoint.x-_stageNowPoint.x;
			var yyy:Number=_stageOldPoint.y-_stageNowPoint.y;
			this._display.x+=xxx;
			this._display.y+=yyy;
			_x+=xxx;
			_y+=yyy;
			TweenLite.to(this,_time,{x:_x,y:_y});
		}
		public function tweenComEnd(...aa):void{
			if(!_display.stage){
				return;
			}
			var rect:Rectangle = new Rectangle(0,0,this._stage.stageWidth,_stage.stageHeight);
			var stPoint:Point = _display.localToGlobal(new Point(0,0));
			if (! rect.containsPoint(stPoint))
			{
				
					if (stPoint.y < 100)
					{
						setPosition();
//						outScreen(AddTouchDrag.outScreenUp);
					}
					else if (stPoint.x<100)
					{
						setPosition();
//						outScreen(AddTouchDrag.outScreenLeft);
						
					}
					else if (stPoint.y>_stage.stageHeight-242)
					{
						setPosition();
//						outScreen(AddTouchDrag.outScreenDown);
					}
					else if (stPoint.x>_stage.stageWidth-100)
					{
						setPosition();
//						outScreen(AddTouchDrag.outScreenRight);
					}
					
			}

		}
		
		private function setPosition():void
		{
			// TODO Auto Generated method stub
			_display.x=Data.stageWidth*0.5;
			_display.y=Data.stageHeight+300;
			_display.scaleX=_display.scaleY=0.01;
			_display.alpha=1;
			var endx:Number=100+(Data.stageWidth-200)*Math.random();
			var endy:Number=100+(Data.stageHeight-142-200)*Math.random();
			var scalX:Number=0.2+Math.random()*0.3;
			TweenLite.to(_display,0.6,{x:endx,y:endy,scaleX:scalX,scaleY:scalX,ease:Circ.easeInOut,delay:5});
		}
		
	}
	
}