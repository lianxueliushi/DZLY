package com.king.component
{
	import com.king.control.ViewObject;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	public class Alert extends com.king.control.ViewObject
	{
		private  var containerBg:DisplayObjectContainer;
		
		private  var timetick:Timer;
		
		private  var bg:Sprite;
		public function Alert()
		{
//			containerBg=new DisplayObjectContainer();
			super();
		}
		public static function getInstance():Alert{
			var ins:Alert=new Alert();
			return ins;
		}
		protected  function timetickHandler(event:TimerEvent):void
		{
			containerBg.removeChild(bg);
			timetick.stop();
			timetick.removeEventListener(TimerEvent.TIMER,timetickHandler);
		}
		public  function show($str:String,$container:DisplayObjectContainer,$close:Boolean=true):void{
			var txt:TextField=new TextField();
			txt.textColor=0xffffff;
			
			var tf:TextFormat=new TextFormat();
			tf.size=16;
			tf.font="微软雅黑","黑体","宋体";
			txt.defaultTextFormat=tf;
			txt.selectable=false;
			txt.text=$str;
			txt.autoSize=TextFieldAutoSize.LEFT;
			
			bg=new Sprite();
			bg.graphics.beginFill(0x65421b,1);
			bg.graphics.drawRoundRect(0,0,txt.width+20,txt.height+10,5,5);
			bg.graphics.endFill();
			containerBg=$container;
			txt.x=10;
			txt.y=5;
			bg.addChild(txt);
			containerBg.addChild(bg);
			bg.x=1920-bg.width>>1;
			bg.y=1080-bg.height>>1;
			
			bg.addEventListener(MouseEvent.CLICK,closeThis);
			if($close){
				timetick=new Timer(10*100,1);
				timetick.addEventListener(TimerEvent.TIMER,timetickHandler);
				timetick.start();
			}
			
		}
		
		protected  function closeThis(event:MouseEvent=null):void
		{
			if(containerBg && bg){
				containerBg.removeChild(bg);
				if(timetick){
					
				timetick.stop();
				timetick.removeEventListener(TimerEvent.TIMER,timetickHandler);
				}
			}
			
		}
	}
}