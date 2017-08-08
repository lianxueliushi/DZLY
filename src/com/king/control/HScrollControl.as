package com.king.control
{
	import com.greensock.TweenLite;
	import com.king.EventDispacher.XYDispatcher;
	import com.king.event.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class HScrollControl extends MovieClip
	{
		public var _rongqi:Sprite;
		protected var _mask:DisplayObject = null;
		private var _x:Number = 0;
		private var _touchPointObj:Object = null;
		protected var _cellArray:Array;
		private var _isDown:Boolean;
		private var _downX:Number=0;
		private var _downY:Number=0;
		public function get cellArray():Array
		{
			return _cellArray;
		}
		public function HScrollControl($wid:int,$heg:int)
		{
			_mask=creationMask(0,0,$wid,$heg);
			init();
		}
		public function update():void
		{
			_rongqi.y=0;
		}
		public function addCell(display:DisplayObject,_x:Number=-1,_y:Number=-1):void
		{
			_cellArray.push(display);
			if(_x!=-1){
				display.x=_x;
			}
			if(_y!=-1){
				display.y=_y;
			}else{
				
				display.x = _rongqi.width;
			}
			_rongqi.addChild(display);
			moveEndSetRongqi();
		}
		public function removeCell(display:DisplayObject):void
		{
			var len:Number = 0;
			for (var i:int=0; i<_cellArray.length; i++)
			{
				if (display==_cellArray[i])
				{
					len = display.width;
					_rongqi.removeChild(display);
					_cellArray.splice(i,1);
					i--;
				}
				else
				{
					_cellArray[i].x -=  len;
					trace(_cellArray[i].x);
				}
			}
			
			
		}
		public function removeAll():void{
			var len:Number = 0;
			for (var i:int=0; i<_cellArray.length; i++)
			{
				var display:DisplayObjectContainer=_cellArray[i];
				
				len = display.height;
				_rongqi.removeChild(display);
				_cellArray.splice(i,1);
				i--;
			}
		}
		public function removeIndexCell(index:int):void
		{
			var len:Number = 0;
			if (index>=_cellArray.length)
			{
				return;
			}
			var display:DisplayObject = _cellArray[index];
			len = display.width;
			_rongqi.removeChild(display);
			_cellArray.splice(index,1);
			for (var i:int=index; i<_cellArray.length; i++)
			{
				_cellArray[i].x -=  len;
				
			}
			
		}
		
		protected function init():void{
			_cellArray=[];
			_rongqi=new Sprite();
			this.addChild(_rongqi);
			_rongqi.x=_mask.x;
			this.addChild(_mask);
			_rongqi.mask = _mask;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		protected function addToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			this.addEventListener(MouseEvent.MOUSE_DOWN,touchDown);
			this.addEventListener(MouseEvent.MOUSE_UP,touchEnd);
			this.addEventListener(MouseEvent.MOUSE_MOVE,touchMove);
			this.addEventListener(MouseEvent.ROLL_OUT,touchEnd);
			
		}
		private function creationMask(xi:Number,yi:Number,widthi:Number,heighti:Number):DisplayObject
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0);
			sp.graphics.drawRoundRect(xi,yi,widthi,heighti,5,5);
			sp.graphics.endFill();
			return sp;
		}
		private function touchDown(e:MouseEvent):void
		{
			_isDown=true;
			if (_touchPointObj!=null)
			{
				_touchPointObj=null;
			}
			_touchPointObj=new Object();
			_x = _rongqi.y;
			_touchPointObj.stagey = e.stageY;
			_touchPointObj.stagex=e.stageX;
			_touchPointObj.move = 0;
			
			_downX=e.stageX;
			_downY=e.stageY;
		}
		
		private function touchMove(e:MouseEvent):void
		{
			if(!_isDown){
				return ;
			}
			_touchPointObj.move = e.stageX - _touchPointObj.stagex;
			_x += _touchPointObj.move;
			_touchPointObj.stagey = e.stageY;
			_touchPointObj.stagex=e.stageX;
			TweenLite.to(_rongqi,0.6,{x:_x});
			
		}
		private function touchEnd(e:MouseEvent):void
		{
			if(_isDown){
				if(Math.abs(_downY-e.stageY)<=3 && Math.abs(_downX-e.stageX)<=3){
					for(var i:int=0;i<_cellArray.length;i++){
						if((_cellArray[i] as DisplayObjectContainer).contains(e.target as DisplayObject)){
							XYDispatcher.getInstance().dispatchEvent(new ListEvent(ListEvent.TOUCH_CLICK,_cellArray[i]));
							break ;
						}
					}
					
				}
				
				_x +=  _touchPointObj.move * 8;//_touchPointObj.move 是移动速度
				var n:int=_touchPointObj.move * 8;
				moveEndSetRongqi();
				_isDown=false;
				_touchPointObj = null;
			}
			
		}
		
		protected function moveEndSetRongqi():void
		{  
			if (_rongqi.width <= _mask.width)
			{
				if (_x<_mask.x)
				{
					_x = _mask.x;
					XYDispatcher.getInstance().dispatchEvent(new ListEvent(ListEvent.DragEndToBottom));//拖动到最底端触发事件
				}
				else if (_x>=_mask.x)
				{
					_x = _mask.x;
					
				}
				
			}
			else
			{
				
				if (_x>_mask.x)
				{
					_x = _mask.x;
				}
				else if (_x<_mask.x+_mask.width-_rongqi.width)
				{
					_x = _mask.x + _mask.width - _rongqi.width;
					XYDispatcher.getInstance().dispatchEvent(new ListEvent(ListEvent.DragEndToBottom));//拖动到最底端触发事件
				}
			}
			var num:Number=_x-_rongqi.x;
			TweenLite.to(_rongqi,0.6,{x:_x,onComplete:tweenCom,onCompleteParams:[num]});
		}
		protected function tweenCom(abs:Number):void
		{
			
			
		}
		
		
		
	}
	
}