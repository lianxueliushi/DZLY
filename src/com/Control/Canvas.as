package com.Control
{
	import com.Control.canva.GraphBase;
	import com.Control.bitmapData.PNGEncoder;
	import com.Data.CanvasData;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class Canvas extends Sprite
	{
		public static const PHOTO_CLICK:String="PHOTO_CLICK";
		private var shapeList:Array;
		private var ismouseDown:Boolean;
		private var canvasWid:Number;
		private var canvasHeg:Number;
		private var canvasBg:Sprite;//未转为bitmap的存放容器
		private var canvasBgMask:Shape;//遮罩
		private var bg:Sprite;//总的存放容器
		private var bmpBg:Bitmap;//背景图片
		private var bmpdBg:BitmapData;
		private var bitmapBg:Sprite;//已转为bitmap的存放容器
		private var undoNum:int=3;//撤销步数
		private var photoBmp:Bitmap;//照片位图数据
		private var photoBg:PhotoBg;//照片框
		
		private var whiteBg:Sprite;
		/**
		 ************canvasBgMask
		 * bg********canvasBg
		 * **********bitmapBg
		 * 
		 * bmpBg****************
		 * 
		 */		
		public function Canvas($wid:Number,$heg:Number)
		{
			super();
			canvasWid=$wid;
			canvasHeg=$heg;
			init();
		}

		public function get isDraw():Boolean
		{
			if(shapeList && shapeList.length>0){
				return true;
			}
			else{
				return false;
			}
		}

		/**
		 *设置画布背景图片 
		 * @param $bitmap
		 * 
		 */		
		public function set imgBitmap($bitmap:BitmapData):void{
			bmpdBg=$bitmap;
			bmpBg.bitmapData=bmpdBg;
		}
		/**
		 *撤销 
		 * 
		 */		
		public function undo():void{
			var leg:int=shapeList.length;
			if(leg>0){
				var arr:Array=shapeList.splice(leg-1);//删除最后一个
				var tg:GraphBase=arr[0];
				canvasBg.removeChild(tg);
			}
		}
		/**
		 *保存图片 外调方法 
		 * @param $url
		 * 
		 */		
		public function save($url:String):void{
			trace("保存路径："+$url);
			Alert.getInstance().show("您是第"+(Data.personNum+1)+"位留言者！留言正在保存,请稍后！",stage);
			this.mouseChildren=false;
			this.mouseEnabled=false;
			Data.personNum++;
			Data.localData.data["pnum"]=Data.personNum;
			var date:Date=new Date();
			var des:String=date.fullYear+"年"+dateformat(date.month+1)+"月";
			if(Data.localData.data["pnum"+des]==null){
				Data.localData.data["pnum"+des]=1;
			}
			else{
				Data.localData.data["pnum"+des]++;
			}
			Data.localData.flush();
			View_liuyanban.thisbg.des.text=Data.personNum+"人次";
//			saveFile($url);
			TweenLite.delayedCall(0.2,saveFile,[$url]);
		}
		/**
		 *清除当前  不清除照片
		 * 
		 */		
		public function clear():void{
			var i:int=0;
			var n:int=canvasBg.numChildren;
			var m:int=shapeList.length;
			while(i<m){
				shapeList.shift();
				canvasBg.removeChildAt(0);
				i++;
			}
			var ii:int=0;
			var j:int=bitmapBg.numChildren;
			while(ii<j){
				bitmapBg.removeChildAt(0);
				ii++;
			}
		}
		public function clearPhoto():void{
			if(photoBg){
				this.removeChild(photoBg);
				photoBg=null;
			}
		}
		public function addPhoto($bmpd:Bitmap):void{
			photoBmp=$bmpd;
			if(photoBg){
				this.removeChild(photoBg);
				try{
					photoBg.removeChild(photoBmp);
				}
				catch(e:Error){
					
				}
			}
			photoBg=new PhotoBg();
//			photoBmp.scaleX=photoBmp.scaleY=235/photoBmp.width;
			photoBmp.width=400;
			photoBmp.height=400;
			photoBmp.rotationY=180;
			photoBg.addChild(photoBmp);
			photoBmp.x=400;
			this.addChild(photoBg);
			photoBg.x=200;
			photoBg.y=100;
//			photoBg.alpha=0;
			photoBg.addEventListener(MouseEvent.CLICK,restPohto);
			TweenLite.from(photoBg,0.6,{alpha:0,y:-100,rotation:-360});
		}
		/**
		 *重拍 
		 * @param event
		 * 
		 */		
		protected function restPohto(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.removeChild(photoBg);
			photoBg.removeEventListener(MouseEvent.CLICK,restPohto);
			photoBg=null;
			this.dispatchEvent(new Event(Canvas.PHOTO_CLICK));
		}
		/**
		 *初始化 
		 * 
		 */		
		private function init():void
		{
			initBg();
			shapeList=new Array();
			// 初始化
			this.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			this.addEventListener(MouseEvent.MOUSE_UP, stopDraw);
			this.addEventListener(MouseEvent.MOUSE_MOVE, drawing);
//			this.addEventListener(Event.ENTER_FRAME,drawing);
			this.addEventListener(MouseEvent.ROLL_OUT, stopDraw);
		}
	
		/**
		 *初始化背景 
		 * 
		 */		
		private function initBg():void
		{
			// TODO Auto Generated method stub
			bmpdBg=new BitmapData(canvasWid,canvasHeg,true,0);
			bmpBg=new Bitmap();
			bmpBg.bitmapData=bmpdBg;
			this.addChild(bmpBg);
			bg=new Sprite();
			bg.graphics.beginFill(0,0);
			bg.graphics.drawRect(0,0,canvasWid,canvasHeg);
			bg.graphics.endFill();
			this.addChild(bg);
			bitmapBg=new Sprite();
			bg.addChild(bitmapBg);
			canvasBg=new Sprite();
			bg.addChild(canvasBg);
			canvasBgMask=new Shape();
			canvasBgMask.graphics.beginFill(0,1);
			canvasBgMask.graphics.drawRect(0,0,canvasWid,canvasHeg);
			bg.addChild(canvasBgMask);
			canvasBg.mask=canvasBgMask;
			
			photoBmp=new Bitmap();
			whiteBg=getRect();
			addChild(whiteBg);
			whiteBg.visible=false;
		}
		/**
		 *转为位图 
		 * @param $mc
		 * @return 位图对象
		 * 
		 */		
		private function toBitmap($mc:DisplayObjectContainer):Bitmap{
			var bmp:Bitmap=new Bitmap();
			var bmpd:BitmapData=new BitmapData(canvasWid,canvasHeg,true,0);
			bmpd.draw($mc);
			bmp.bitmapData=bmpd;
			return bmp;
		}
		/**
		 *保存图片 
		 * @param $url
		 * 
		 */		
		private function saveFile($url:String):void
		{
			// TODO Auto Generated method stub
			this.mouseChildren=false;
			this.mouseEnabled=false;
			TweenLite.delayedCall(0.6,clearWhitebg);
			var bmpd:BitmapData=new BitmapData(canvasWid,canvasHeg,true,0);
			bmpd.draw(this);
			this.clear();
			this.clearPhoto();
			TweenLite.delayedCall(0.1,savePhoto,[bmpd,$url]);
		}
		
		private function savePhoto(bmpd:BitmapData,$url:String):void
		{
			// TODO Auto Generated method stub
			var byte:ByteArray=PNGEncoder.encode(bmpd);
			var file:File=new File($url);
			if(!file.exists){
			file.createDirectory();
			}
			var data:Date=new Date();
			var riqi:String=data.fullYear+""+dateformat(data.month+1)+""+dateformat(data.date)+"_"+dateformat(data.hours)+""+dateformat(data.minutes)+""+dateformat(data.seconds);
			var f:File=file.resolvePath($url+"/"+data.fullYear+"年"+dateformat(data.month+1)+"月/"+riqi+".png");
			var stream:FileStream=new FileStream();
			stream.open(f,FileMode.WRITE);
			stream.writeBytes(byte);
			stream.close();
			Alert.getInstance().show("留言保存完成！点击查看按钮可以查看已经保存的留言！",this);
		}
		private function dateformat($data:int):String{
			if($data<10){
				return "0"+$data;
			}
			else return $data+"";
		}
		private function clearWhitebg():void
		{
			// TODO Auto Generated method stub
			whiteBg.visible=false;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}
		/**
		 *画画中…… 
		 * @param event
		 * 
		 */		
		protected function drawing(event:Event):void
		{
			// 鼠标移动画画
			if(!ismouseDown){
				return;
			}
			var brush:GraphBase=shapeList[shapeList.length-1];
			brush.draw(mouseX,mouseY);
		}
		/**
		 *停止画画 
		 * @param event
		 * 
		 */		
		protected function stopDraw(event:MouseEvent):void
		{
			// 停止画画
			//trace("停止画画")
			if(!ismouseDown){
				return;
			}
			ismouseDown=false;
		}
		/**
		 *开始画画 
		 * @param event
		 * 
		 */		
		protected function startDraw(event:MouseEvent):void
		{
			// 开始画画
			ismouseDown=true;
			var brushType:Class=CanvasData.brushType;
			var brush:GraphBase=new brushType(CanvasData.brushColor);
			brush.size=CanvasData.brushSize;
			brush.begin(mouseX,mouseY);
			canvasBg.addChild(brush);
			shapeList.push(brush);
			var leg:int=shapeList.length;
			if(leg>undoNum){
				var tg:GraphBase=shapeList.shift();
				bitmapBg.addChild(tg);
				var bmp:Bitmap=toBitmap(bitmapBg);
				while(bitmapBg.numChildren>0){
					bitmapBg.removeChildAt(0);
				}
				bitmapBg.addChild(bmp);
			}
		}
		private function getRect():Sprite{
			var bg:Sprite=new Sprite();
			bg.graphics.beginFill(0xffffff,1);
			bg.graphics.drawRect(0,0,canvasWid,canvasHeg);
			bg.graphics.endFill();
			return bg;
		}
		
	}
}