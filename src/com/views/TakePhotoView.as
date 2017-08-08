package com.views
{
	import com.Event.PhotoEvent;
	import com.greensock.TweenLite;
	import com.king.control.KingView;
	import com.king.control.MyCamera;
	import com.king.control.Navigator;
	import com.king.dispatchers.KingDispatcher;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	import ui.MyTimer;
	import ui.ViewtakePhoto;
	
	public class TakePhotoView extends KingView
	{
		private var camera:MyCamera;
		private var camWid:Number;
		private var camHeg:Number;
		private var skinbg:ViewtakePhoto;
		private var rectbg:Sprite;
		
		public function TakePhotoView($wid:Number,$heg:Number)
		{
			super(false,"TakePhoto");
			camWid=$wid;
			camHeg=$heg;
			onCreate();
		}
		
		override public function onCreate():Boolean
		{
			// TODO Auto Generated method stub
			skinbg=new ViewtakePhoto();
			addChild(skinbg);
			rectbg=getRect();
			var bur:BlurFilter=new BlurFilter(200,200,1);
			rectbg.filters=[bur];
			addChild(rectbg);
			rectbg.visible=false;
			rectbg.x=498;
			rectbg.y=70;
			skinbg.btn_paizhao.addEventListener(MouseEvent.CLICK,onClick);
			skinbg.btn_chongpai.addEventListener(MouseEvent.CLICK,onClick);
			skinbg.btn_save.addEventListener(MouseEvent.CLICK,onClick);
			skinbg.btn_back.addEventListener(MouseEvent.CLICK,onClick);
			resetCamera();
			return super.onCreate();
		}
		
		
		public function resetCamera():void
		{
			if(camera) {
				camera.closeCamera();
				this.removeChild(camera);
			}
			camera=new MyCamera(camWid,camHeg);
			this.addChild(camera);
			camera.x=498;
			camera.y=70;
		}
		
		override public function onDispose():Boolean
		{
			// TODO Auto Generated method stub
			if(camera) {
				camera.closeCamera();
				this.removeChild(camera);
			}
			skinbg.btn_paizhao.removeEventListener(MouseEvent.CLICK,onClick);
			skinbg.btn_chongpai.removeEventListener(MouseEvent.CLICK,onClick);
			skinbg.btn_save.removeEventListener(MouseEvent.CLICK,onClick);
			skinbg.btn_back.removeEventListener(MouseEvent.CLICK,onClick);
			return super.onDispose();
		}
		
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			switch(event.currentTarget)
			{
				case skinbg.btn_paizhao:
				{
					if(camera && camera.getPhoto()!=null) resetPhoto();
					readyCamera();
					break;
				}
				case skinbg.btn_chongpai:
				{
					resetPhoto();
					break;
				}
				case skinbg.btn_save:
				{
					this.dispatchEvent(new PhotoEvent(PhotoEvent.TAKE_PHOTO,savePhoto()));
					camera.closeCamera();
					Navigator.getInstance().removeView();
					break;
				}
				case skinbg.btn_back:
				{
					Navigator.getInstance().removeView();
					break;
				}	
				default:
				{
					break;
				}
			}
		}
		
		private function readyCamera():void
		{
			// TODO Auto Generated method stub
			var daojishi:MovieClip=new MyTimer();
			this.addChild(daojishi);
			daojishi.x=camera.x+camera.width/2;
			daojishi.y=camera.y+camera.height/2;
			daojishi.gotoAndPlay(2);
			this.mouseChildren=false;
			this.mouseEnabled=false;
			trace("addDaojihsi")
			TweenLite.delayedCall(2.8,takePhoto);
		}
		/**
		 *拍照 
		 * 
		 */		
		private function takePhoto():void{
			rectbg.visible=true;
			TweenLite.delayedCall(0.15,clearBg);
			camera.takePhoto();
		}
		
		private function clearBg():void
		{
			// TODO Auto Generated method stub
			this.mouseChildren=true;
			this.mouseEnabled=true;
			rectbg.visible=false;
		}
		private function getRect():Sprite{
			var bg:Sprite=new Sprite();
			bg.graphics.beginFill(0xffffff,0.2);
			bg.graphics.drawRect(0,0,camWid,camHeg);
			bg.graphics.endFill();
			return bg;
		}
		/**
		 *保存照片 
		 * @return 
		 * 
		 */		
		public function savePhoto():Bitmap{
			var temp:Bitmap=new Bitmap(camera.getPhoto().bitmapData);
			return temp;
		}
		/**
		 *重拍 
		 * 
		 */		
		public function resetPhoto():void{
			camera.clearPhoto();
		}
	}
}