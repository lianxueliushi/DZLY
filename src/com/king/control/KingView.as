package com.king.control
{
	import flash.display.Sprite;

	public class KingView extends ViewObject
	{
		private var _bgColor:int;
		private var _bg:Sprite;
		private var _addAble:Boolean;//是否可以添加界面，如果可添加界面，则添加后暂停程序，如果不可添加界面，则，添加后删除当前界面
		public function KingView($add:Boolean=true,$name:String="KingView")
		{
			super($name);
			_addAble=$add;
			_bg=new Sprite();
			this.addChild(_bg);
		}
		public function setbgColor(value:int,a:Number):void
		{
			_bg.graphics.clear();
			_bgColor = value;
			_bg.graphics.beginFill(value,a);
			_bg.graphics.drawRect(0,0,Data.stageWidth,Data.stageHeight);
			_bg.graphics.endFill();
		}
		
		override public function onDispose():Boolean
		{
			// TODO Auto Generated method stub
			_bg.graphics.clear();
			return super.onDispose();
		}
		
		
		public function get addAble():Boolean
		{
			return _addAble;
		}

		public function get bg():Sprite
		{
			return _bg;
		}


	}
}