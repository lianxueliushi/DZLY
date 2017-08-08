package com.views
{
	import com.king.data.BgimgData;
	import com.king.data.PicwallData;
	import com.king.component.ImgThumList;
	import com.king.component.SkinButton;
	import com.king.control.FileControl;
	import com.king.control.KingView;
	import com.king.control.Navigator;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import ui.btn_back;
	
	public class PicsWallView extends KingView
	{
		[Embed(source="/assets/bg3.jpg")]
		private var SKIN:Class;
		private var _btnBack:btn_back;
		public function PicsWallView($name:String="ViewObject")
		{
			super($name);
			var skin:Bitmap=new SKIN();
			this.addChild(skin);
			var tempList:Array=FileControl.getImgFileDirs(BgimgData.saveUrl);
			var imgThum:ImgThumList=new ImgThumList(1722,790,6,4);
			imgThum.gapH=30;
			imgThum.gapV=30;
			imgThum.imgList=tempList;
			this.addChild(imgThum);
			imgThum.x=104;
			imgThum.y=156;
			_btnBack=new btn_back();
			this.addChild(_btnBack);
			_btnBack.x=1591;
			_btnBack.y=975;
			_btnBack.addEventListener(MouseEvent.CLICK,onBackClick);
			
		}
		
		protected function onBackClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Navigator.getInstance().removeView();
		}
	}
}