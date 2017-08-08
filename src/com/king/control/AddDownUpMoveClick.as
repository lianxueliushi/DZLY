package com.king.control
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	public class AddDownUpMoveClick
	{
		protected var _display:InteractiveObject;
		protected var _stage:Stage;
		public var touchDown:Function = null;
		public var touchMove:Function = null;
		public var touchEnd:Function = null;
		public var touchClick:Function = null;
		protected var _touchPointArray:Array;
		public function AddDownUpMoveClick(display:InteractiveObject)
		{
			_touchPointArray=new Array();
			_display = display;
			if (display.stage)
			{
				addStage();
			}
			else
			{
				display.addEventListener(Event.ADDED_TO_STAGE,addStage);
			}
		}
		private function addStage(e:Event=null):void
		{
			_stage = _display.stage;
			_display.addEventListener(Event.REMOVED_FROM_STAGE,removeStage);
			addEventListeners();
		}
		private function removeStage(e:Event):void
		{
			removeEventListeners();
		}
		private function addEventListeners():void
		{// trace("添加侦听器")
			//_display.addEventListener(TouchEvent.TOUCH_BEGIN,displayTouchBiegin);
			_display.addEventListener(MouseEvent.MOUSE_DOWN,displayMouseDown);
		}
		private function removeEventListeners():void
		{
			//trace("移除侦听器")
			_display.removeEventListener(Event.REMOVED_FROM_STAGE,removeStage);
			_display.removeEventListener(TouchEvent.TOUCH_BEGIN,displayTouchBiegin);
			_display.removeEventListener(MouseEvent.MOUSE_DOWN,displayMouseDown);
			_stage.removeEventListener(TouchEvent.TOUCH_MOVE,displayTouchMove);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,displayMouseMove);
			_stage.removeEventListener(TouchEvent.TOUCH_END,displayTouchEnd);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,displayMouseUp);
		}
		public function remove():void
		{
			_display.removeEventListener(Event.REMOVED_FROM_STAGE,removeStage);
			removeEventListeners();
		}
		private function displayTouchBiegin(e:TouchEvent):void
		{
			downEvent(e.stageX,e.stageY,e.touchPointID);
		}
		private function displayMouseDown(e:MouseEvent):void
		{ // trace(e.target.name,e.currentTarget.name);
			downEvent(e.stageX,e.stageY,0);
		}
		protected function downEvent(stageX:Number,stageY:Number,touchPointID:int):void
		{  //trace("按下")
			if (touchDown!=null)
			{//trace("按下。")
				touchDown(stageX,stageY,touchPointID);
			}
			/*if(getIndexObjArray(touchPointID)!=-1){
			return;
			}
			*/
			var obj:Object=new Object();
			var stagePoint:Point=new Point(stageX,stageY);
			obj.stagePoint=stagePoint;
			obj.startStagePoint=new Point(stageX,stageY);
			obj.touchPointID = touchPointID;
			if(_touchPointArray.length==0){
				_stage.addEventListener(TouchEvent.TOUCH_MOVE,displayTouchMove);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE,displayMouseMove);
				_stage.addEventListener(TouchEvent.TOUCH_END,displayTouchEnd);
				_stage.addEventListener(MouseEvent.MOUSE_UP,displayMouseUp);
				touchDownobjStart(obj);
			}
			_touchPointArray.push(obj);
			//_touchPointArray[touchPointID] = new Point(stageX,stageY);
		}
		protected function moveEvent(stageX:Number,stageY:Number,touchPointID:int):void
		{//trace("拖动。")
			if (touchMove!=null)
			{
				touchMove(stageX,stageY,touchPointID);
			}
		}
		protected function getIndexObjArray(touchPointID:int):int{
			//	if(){}
			var len:int=_touchPointArray.length;
			for(var i:int=0;i<len;i++){
				if(_touchPointArray[i].touchPointID==touchPointID){
					return i;
				}
			}
			return -1;
		}
		protected function endEvent(stageX:Number,stageY:Number,touchPointID:int):void
		{ 
			if (touchEnd!=null)
			{
				touchEnd(stageX,stageY,touchPointID);
			}
			var index:int=getIndexObjArray(touchPointID);
			if(index==-1){
				return;
			}
			var obj:Object=_touchPointArray[index];
			_touchPointArray.splice(index,1);
			touchEndObj(obj,index);
			if(_touchPointArray.length==0){
				touchEndObjOver(obj,index);
				_stage.removeEventListener(TouchEvent.TOUCH_MOVE,displayTouchMove);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE,displayMouseMove);
				_stage.removeEventListener(TouchEvent.TOUCH_END,displayTouchEnd);
				_stage.removeEventListener(MouseEvent.MOUSE_UP,displayMouseUp);
			}
		}
		protected function touchDownobjStart(obj:Object):void{
			
		}
		protected function touchEndObj(obj:Object,index:int):void{
			
			
		}
		protected function touchEndObjOver(obj:Object,index:int):void{
			if (touchClick!=null)
			{
				if (Math.abs(obj.startStagePoint.x - obj.stagePoint.x)<2 && Math.abs(obj.startStagePoint.y - obj.stagePoint.y)<2)
				{//trace("dianji"+obj.touchPointID);
					touchClick(obj.stagePoint.x,obj.stagePoint.y,obj.touchPointID);
				}
			}
		}
		private function displayTouchMove(e:TouchEvent):void
		{
			moveEvent(e.stageX,e.stageY,e.touchPointID);
		}
		private function displayMouseMove(e:MouseEvent):void
		{
			moveEvent(e.stageX,e.stageY,0);
		}
		private function displayTouchEnd(e:TouchEvent):void
		{
			endEvent(e.stageX,e.stageY,e.touchPointID);
		}
		private function displayMouseUp(e:MouseEvent):void
		{
			endEvent(e.stageX,e.stageY,0);
		}
	}
}