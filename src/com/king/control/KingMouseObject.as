package com.king.control
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class KingMouseObject
	{
		public var downFunction:Function;
		public var upFunction:Function;
		public var moveFunction:Function;
		public var clickFunction:Function;
		public var outFunction:Function;
		public var moveLeftFunction:Function;
		public var moveRightFunction:Function;
		private var downPoint:Point;
		private var upPoint:Point;
		
		private var isDown:Boolean=false;
		private var _target:DisplayObject;
		public function KingMouseObject(target:DisplayObject)
		{
			_target=target;
			_target.addEventListener(Event.ADDED_TO_STAGE,addedTostage);
			
		}
		private function addMouseListeners():void{
			_target.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			_target.addEventListener(MouseEvent.MOUSE_UP,onMouse);
			_target.addEventListener(MouseEvent.MOUSE_MOVE,onMouse);
			_target.addEventListener(MouseEvent.MOUSE_OUT,onMouse);
			_target.addEventListener(MouseEvent.RELEASE_OUTSIDE,onMouse);
		}
		
		protected function addedTostage(event:Event):void
		{
			// T对象被添加
			_target.removeEventListener(Event.ADDED_TO_STAGE,addedTostage);
			_target.addEventListener(Event.REMOVED_FROM_STAGE,removed);
			addMouseListeners();
		}
		
		protected function removed(event:Event):void
		{
			// 对象被移除
			_target.removeEventListener(Event.REMOVED_FROM_STAGE,removed);
			_target.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			_target.removeEventListener(MouseEvent.MOUSE_UP,onMouse);
			_target.removeEventListener(MouseEvent.MOUSE_MOVE,onMouse);
			_target.removeEventListener(MouseEvent.MOUSE_OUT,onMouse);
			_target.removeEventListener(MouseEvent.RELEASE_OUTSIDE,onMouse);
		}
		
		protected function onMouse(event:Event):void
		{
			// TODO Auto-generated method stub
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
				{
					isDown=true;
					downPoint=_target.localToGlobal(new Point(_target.mouseX,_target.mouseY));
					if(downFunction){
						downFunction(event);
					}
					break;
				}
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.RELEASE_OUTSIDE:
				{
					if(isDown){
						isDown=false;
						if(outFunction){
							outFunction(event);
						}
					}
					break;
				}
				case MouseEvent.MOUSE_UP:
				{
					if(isDown){
						upPoint=_target.localToGlobal(new Point(_target.mouseX,_target.mouseY));
						if(Point.distance(upPoint,downPoint)<30 && clickFunction){
							clickFunction(event);
						}
						if(moveRightFunction && upPoint.x-downPoint.x>30){
							moveRightFunction(event);
						}
						else if(moveLeftFunction && upPoint.x-downPoint.x<-30){
							moveLeftFunction(event);
						}
						if(upFunction) upFunction(event);
						isDown=false;
					}
					break;
				}
				case MouseEvent.MOUSE_MOVE:
				{
					if(isDown && moveFunction){
						moveFunction(event);
						isDown=false;
					}
					break;
				}
				
					
				default:
				{
					break;
				}
			}
		}
	}
}