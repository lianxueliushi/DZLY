package com.views
{
	import com.greensock.TweenLite;
	import com.king.component.Component_picTransForPreview;
	import com.king.control.KingView;
	
	import flash.filesystem.File;

	/**
	 *图片预览 
	 * @author Administrator
	 * 
	 */	
	public class View_PreviewImg extends KingView
	{

		private var myPicturn:Component_picTransForPreview;
		public function View_PreviewImg($imgFile:File,$imgFileList:Array,disposeAll:Boolean=false)
		{
			super(disposeAll);
			var leftBtn:UI_btnLeft=new UI_btnLeft();
			var rightBtn:UI_btnLeft=new UI_btnLeft();
			myPicturn=new Component_picTransForPreview(Data.stageWidth-200,Data.stageHeight-100,leftBtn,rightBtn,$imgFileList,$imgFile);
			onCreate();
		}
		
		override public function onCreate():Boolean
		{
			// TODO Auto Generated method stub
			addChild(myPicturn);
			myPicturn.x=100;
			myPicturn.y=50;
			this.setbgColor(0x000000,0.8);
			TweenLite.from(this.bg,0.3,{alpha:0,delay:0.3});
			return super.onCreate();
		}
		
	
		
	}
}