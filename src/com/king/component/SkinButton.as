package com.king.component
{
	import com.king.control.ViewObject;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SkinButton extends ViewObject
	{
		private var _txt:TextField;
		private var _wid:int;
		private var _heg:int;
		private var _lable:String;
		private var _upSkin:Bitmap;
		private var _downSkin:Bitmap;
		private var _isMouseDown:Boolean=false;
		private var _downTf:TextFormat;
		private var _upTf:TextFormat;
		private var _ms:Shape;
		private var _bg:Shape;
		public function SkinButton($lable:String="",$wid:int=100,$heg:int=30,$name:String="SkinButton")
		{
			super($name);
			_wid=$wid;
			_heg=$heg;
			_lable=$lable;
			onCreate();
		}
		
		override public function onCreate():Boolean
		{
			// TODO Auto Generated method stub
			_bg=new Shape();
			_bg.graphics.beginFill(0xbbbbbb,0.6);
			_bg.graphics.drawRect(0,0,_wid,_heg);
			_bg.graphics.endFill();
			this.addChild(_bg);
			
			_txt=new TextField();
			_txt.height=_heg;
			_txt.embedFonts=true;
			_txt.text=_lable;
			var tf:TextFormat=new TextFormat();
			tf.size=16;
			tf.font=new Font_WRYH().fontName;
			_txt.setTextFormat(tf);
			this.addChild(_txt);
			
			
			_ms=new Shape();
			autoSize();
			_txt.mouseEnabled=false;
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			return super.onCreate();
		}
		private function autoSize():void{
			_ms.graphics.clear();
			_ms.graphics.beginFill(0xffffff,1);
			_ms.graphics.drawRect(0,0,_wid,_heg);
			_ms.graphics.endFill();
			this.mask=_ms;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			_txt.x=_wid-_txt.width>>1;
			_txt.y=_heg-5-_txt.height>>1;
			if(_txt.width>_wid && !_ismoving){
				_ismoving=true;
				this.addEventListener(Event.ENTER_FRAME,moveTxt);
			}
		}
		private var _moveSpeed:Number=1;
		private var _ismoving:Boolean=false;
		protected function moveTxt(event:Event):void
		{
			// TODO Auto-generated method stub
			_txt.x-=_moveSpeed;
			if(_txt.x<-_txt.width){
				_txt.x=_wid;
			}
		}
		protected function mouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(_isMouseDown){
				_isMouseDown=false;
				if(_upSkin){
					_upSkin.visible=true;
				}
				if(_downSkin) _downSkin.visible=false;
				if(_upTf){
					_txt.setTextFormat(_upTf);
				}
				this.scaleX=this.scaleY=1;
				this.x=0;
				this.y=0;
			}
		}
		
		protected function mouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			_isMouseDown=true;
			if(_downSkin){
				_upSkin.visible=false;
				_downSkin.visible=true;
			}
			if(_downTf){
				_txt.setTextFormat(_downTf);
			}
			if(_downSkin==null && _downTf==null){
				this.scaleX=this.scaleY=0.96;
				this.x+=_wid*0.02;
				this.y+=_heg*0.02;
			}
		}
		
		public function get lable():String
		{
			return _lable;
		}
		
		public function set lable(value:String):void
		{
			_lable = value;
			_txt.text=_lable;
		}
		
		public function set upSkin(value:Bitmap):void
		{
			_upSkin = value;
			_wid=_upSkin.width;
			_heg=_upSkin.height;
			this.addChild(_upSkin);
			this.setChildIndex(_upSkin,1);
			_bg.graphics.clear();
			autoSize();
		}
		
		public function set downSkin(value:Bitmap):void
		{
			_downSkin = value;
			this.addChild(_downSkin);
			this.setChildIndex(_downSkin,1);
			_downSkin.visible=false;
		}
		
		public function set downTf(value:TextFormat):void
		{
			_downTf = value;
		}
		
		public function set upTf(value:TextFormat):void
		{
			_upTf = value;
			_txt.setTextFormat(_upTf);
			autoSize();
		}
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}
		
	}
}