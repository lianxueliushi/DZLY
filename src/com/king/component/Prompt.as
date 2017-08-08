package com.king.component
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.king.control.ViewObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Prompt extends com.king.control.ViewObject
	{
		/**
		 *提示信息 
		 */
		private var _biMessage:TextField;
		/**
		 *背景框 
		 */		
		private var _busyBg:Sprite;
		/**
		 *高度 
		 */		
		private var _heg:int=30;
		public function Prompt()
		{
			super();
			Init();
		}
		
		private function Init():void
		{
			_busyBg=new Sprite();
			this.addChild(_busyBg);
			_busyBg.visible=false;
			
			_biMessage=new TextField();
			_biMessage.selectable=false;
			_biMessage.embedFonts=false;
			_biMessage.textColor=0xFAECE3;
			var fm:TextFormat=new TextFormat();
			fm.size=14;
			fm.align="center";
			_biMessage.defaultTextFormat=fm;
			_biMessage.text="提示信息";
			_biMessage.height=_biMessage.textHeight+6;
			_busyBg.addChild(_biMessage);
			_biMessage.y=_heg-_biMessage.height>>1;
			
		}
		public function clear():void{
			if(_busyBg!=null){
				_busyBg.graphics.clear();
				this.removeChild(_busyBg);
				_busyBg.removeChild(_biMessage);
				_busyBg=null;
				_biMessage=null;
			}
			
		}
		public function showMessage($str:String,$autoDispear:Boolean=false,delay:Number=2):void{
			_biMessage.text=$str;
			_biMessage.width=_biMessage.textWidth+5;
			
			_busyBg.graphics.clear();
			_busyBg.graphics.beginFill(0x333333);
			_busyBg.graphics.drawRoundRect(0,0,_biMessage.textWidth+50,_heg,5);
			_busyBg.graphics.endFill();
			_biMessage.x=25;
			_busyBg.visible=true;
			_busyBg.alpha=1;
			_biMessage.alpha=1;
			TweenLite.from(_busyBg,0.6,{alpha:0,ease:Circ.easeOut});
			
			if($autoDispear){
				TweenLite.delayedCall(delay,hiddenMessage);
			}
			
		}
		public function hiddenMessage():void{
			try
			{
				_busyBg.visible=false;
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		override public function onDispose():Boolean
		{
			// TODO Auto Generated method stub
			clear();
			return super.onDispose();
		}
		
	}
}