package com.Control
{
	import com.Event.PhotoEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.ui.Keyboard;
	
	public class MyCamera extends Sprite
	{
		private var camera:Camera;
		private var video:Video;
		private var camWid:Number;
		private var camHeg:Number;
		private var getcameraSuccess:Boolean=false;
		private var imgBmp:Bitmap;//照片
		private var value_ld:int=50;
		private var value_dbd:int;
		private var value_bhd:int;
		private var value_sx:int=0;
		public function MyCamera($camWid:Number,$camHeg:Number)
		{
			super();
			camWid=$camWid;
			camHeg=$camHeg;
			init();
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRect(0,0,camWid,camHeg);
			this.graphics.endFill();
			this.addEventListener(Event.ADDED_TO_STAGE,added);
//			clearPhoto();
			getcameraSuccess=false;
			if(!Camera.isSupported){
				Alert.getInstance().show("当前设备不支持摄像头！",this,false);
				return;
			}
			try
			{
				camera=Camera.getCamera("0");
			} 
			catch(error:Error) 
			{
				Alert.getInstance().show("摄像头获取失败！",this,false);
				//return;
			}
			if(camera){
				getcameraSuccess=true;
				camera.setMode(720,720,30,false);
				camera.setQuality(0,100);
				camera.setLoopback(true);
				camera.setKeyFrameInterval(48);
				video=new Video(camWid,camHeg);
				video.smoothing=true;
				video.attachCamera(camera);
				setWhiteMode(video);
				this.addChild(video);
//				video.rotationY=180;
//				video.x=camWid-camHeg>>1;
				video.x=0;
				dispatchEvent(new PhotoEvent("getCamera"));
			}
			else{
				Alert.getInstance().show("摄像头获取失败！",this);
			}
			
		}
		public function closeCamera():void{
			if(camera){
				video.attachCamera(null);
				camera=null;
			}
		}
		protected function added(event:Event):void
		{
			// TODO Auto-generated method stub
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			switch(event.keyCode)
			{
				case Keyboard.A:
				{
					setWhiteMode(video);
					break;
				}
				case Keyboard.B:
				{
					setMode(video);
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		/**
		 *拍照 
		 * 
		 */		
		public function takePhoto():void{
			if(!getcameraSuccess){
				return;
			}
			var bmpd:BitmapData=new BitmapData(video.height,video.height,true,1);
			
//			bmpd.draw(video,null,null,null,new Rectangle(50,50,video.height,video.height));
			bmpd.draw(video);
			if(imgBmp==null){
				imgBmp=new Bitmap();
				this.addChild(imgBmp);	
				imgBmp.x=0;
			}
			setMode(imgBmp);
			imgBmp.bitmapData=bmpd;
			//			clearPhoto();
		}
		public function setFilter($ld:int,$bhd:int,$dbd:int,$sx:int):void{
			value_bhd=$bhd;
			value_dbd=$dbd;
			value_ld=$ld;
			value_sx=$sx;
			setWhiteMode(video);
		}
		private function setMode($dis:DisplayObject):void{
			$dis.filters=[];
			var trans:Transform=new Transform($dis);
			var color:ColorTransform=new ColorTransform();
			color.greenOffset=10;
			color.blueOffset=0;
			color.redOffset=30;
			trans.colorTransform=color;
			var mymatrix1:ColorMatrix=new ColorMatrix();
			var myColorMatrix_filter1:ColorMatrixFilter =new ColorMatrixFilter();
			mymatrix1.SetBrightnessMatrix(value_ld);//调整亮度
			myColorMatrix_filter1.matrix=mymatrix1.GetFlatArray();
//			$dis.filters=[myColorMatrix_filter1];
			/*var b:BlurFilter=new BlurFilter(3,3,1);
			$dis.filters=[b];*/
		}
		private function setWhiteMode($dis:DisplayObject):void{
			$dis.filters=[];
			var trans:Transform=new Transform($dis);
			var color:ColorTransform=new ColorTransform();
			color.greenOffset=10;
			color.blueOffset=0;
			color.redOffset=30;
			trans.colorTransform=color;
			var mymatrix1:ColorMatrix=new ColorMatrix();
			var myColorMatrix_filter1:ColorMatrixFilter =new ColorMatrixFilter();
			mymatrix1.SetBrightnessMatrix(value_ld);//调整亮度
			myColorMatrix_filter1.matrix=mymatrix1.GetFlatArray();
			
			var mymatrix2:ColorMatrix=new ColorMatrix();
			var myColorMatrix_filter2:ColorMatrixFilter =new ColorMatrixFilter();
			mymatrix2.SetContrastMatrix(value_dbd);//调整对比度
			myColorMatrix_filter2.matrix=mymatrix2.GetFlatArray();
			
			
			var mymatrix3:ColorMatrix=new ColorMatrix();
			var myColorMatrix_filter3:ColorMatrixFilter =new ColorMatrixFilter();
			mymatrix3.SetSaturationMatrix(value_bhd);//调整饱和度
			myColorMatrix_filter3.matrix=mymatrix3.GetFlatArray();
			
			
			var mymatrix4:ColorMatrix=new ColorMatrix();
			var myColorMatrix_filter4:ColorMatrixFilter =new ColorMatrixFilter();
			mymatrix4.SetHueMatrix(value_sx);//调整饱和度
			myColorMatrix_filter4.matrix=mymatrix4.GetFlatArray();
//			mymatrix.SetContrastMatrix(value_dbd);//调整对比度
//			mymatrix.SetSaturationMatrix(value_bhd);//饱和度
//			mymatrix.SetBrightnessMatrix(value_ld);//调整亮度
//			mymatrix.SetHueMatrix(value_sx);//色相
			
			
			trace(value_ld);
			var b:BlurFilter=new BlurFilter(2,2,1);
			$dis.filters=[myColorMatrix_filter1];
			
		}
		/**
		 *清除照片 
		 * 
		 */		
		public function clearPhoto():void
		{
			// TODO Auto Generated method stub
			if(camera==null){
				getcameraSuccess=false;
				if(!Camera.isSupported){
					Alert.getInstance().show("当前设备不支持摄像头！",this,false);
					return;
				}
				try
				{
					camera=Camera.getCamera("0");
				} 
				catch(error:Error) 
				{
					Alert.getInstance().show("摄像头获取失败！",this,false);
					//return;
				}
				if(camera){
					getcameraSuccess=true;
					camera.setMode(camWid,camHeg,30,false);
					camera.setQuality(0,100);
					camera.setLoopback(true);
					camera.setKeyFrameInterval(48);
					video=new Video(camWid,camHeg);
					video.smoothing=true;
					video.attachCamera(camera);
					setWhiteMode(video);
					this.addChild(video);
					//				video.x=camWid-camHeg>>1;
					video.x=0;
					dispatchEvent(new PhotoEvent("getCamera"));
				}
				else{
					Alert.getInstance().show("摄像头获取失败！",this);
				}
			}
			if(imgBmp){
				imgBmp.parent.removeChild(imgBmp);
				imgBmp=null;
			}
			
		}	
		/**
		 *获取照片数据 
		 * @return bitmapData
		 * 
		 */		
		public function savePhoto():Bitmap{
			if(!getcameraSuccess){
				return null;
			}
			if(!imgBmp){
				return null;
			}
			return imgBmp;
		}
	}
}