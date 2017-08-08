package com.views
{
	import com.Control.Alert;
	import com.Control.MyCanvas;
	import com.Control.bitmapData.JPGEncoder;
	import com.Data.BgimgData;
	import com.Data.CanvasData;
	import com.Data.PicwallData;
	import com.greensock.TweenLite;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.ImageLoader;
	import com.king.control.KingView;
	import com.king.dispatchers.KingDispatcher;
	import com.king.events.NavigatorEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import ui.Btns;
	
	public class CanvaView extends KingView
	{
		private var _canvas:MyCanvas;
		private var controls:Btns;
		private var _currColorBtn:MovieClip;
		private var _currBgBtn:MovieClip;
		private var _currConBtn:MovieClip;
		private var _currSizeBtn:MovieClip;
		private var _canvasBg:Sprite;
		private var _canvasBgLoader:ImageLoader;
		private var _bg:ImageLoader;
		public function CanvaView($add:Boolean=true, $name:String="CanvaView")
		{
			super($add, $name);
			onCreate();
		}
		
		override public function onCreate():Boolean
		{
			// TODO Auto Generated method stub
			_bg=new ImageLoader("assets/bg1.png",{width:Data.stageWidth,height:Data.stageHeight,container:this,scaleMode:ScaleMode.STRETCH});
			_bg.load();
			_canvasBg=new Sprite();
			this.addChild(_canvasBg);
			loadImg("assets/背景1.png");
			_canvas=new MyCanvas(PicwallData.wid,PicwallData.heg);
			_canvasBg.addChild(_canvas);
			_canvasBg.x=178;
			_canvasBg.y=161;
			controls=new Btns();
			this.addChild(controls);
			for (var i:int = 0; i < controls.numChildren; i++) 
			{
				if(controls.getChildAt(i) is MovieClip){
					MovieClip(controls.getChildAt(i)).gotoAndStop(1);
				}
				controls.getChildAt(i).addEventListener(MouseEvent.CLICK,onControlsClick);
			}
			trace(controls.numChildren);
			return super.onCreate();
		}
		
		protected function onControlsClick(event:Event):void
		{
			// TODO Auto-generated method stub
			var tg:DisplayObject=event.currentTarget as DisplayObject;
			if(tg is MovieClip){
				(tg as MovieClip).gotoAndStop(2);
				if(tg.name.substring(0,6)=="btn_bg"){
					if(_currBgBtn) _currBgBtn.gotoAndStop(1);
					_currBgBtn=tg as MovieClip;
					if(tg.name=="btn_bg1"){
						loadImg("assets/背景1.png");
					}else if(tg.name=="btn_bg2"){
						loadImg("assets/背景2.png");
					}else if(tg.name=="btn_bg3"){
						loadImg("assets/背景3.png")
					}
				}
				else if(tg.name=="btn_red"){
					CanvasData.brushColor=0xff0000;
					if(_currColorBtn) _currColorBtn.gotoAndStop(1);
					_currColorBtn=tg as MovieClip;
				}
				else if(tg.name=="btn_blue"){
					CanvasData.brushColor=0x0000ff;
					if(_currColorBtn) _currColorBtn.gotoAndStop(1);
					_currColorBtn=tg as MovieClip;
				}
				else if(tg.name=="btn_black"){
					CanvasData.brushColor=0x000000;
					if(_currColorBtn) _currColorBtn.gotoAndStop(1);
					_currColorBtn=tg as MovieClip;
				}
				else if(tg.name=="btn_big"){
					CanvasData.brushSize=20;
					if(_currSizeBtn) _currSizeBtn.gotoAndStop(1);
					_currSizeBtn=tg as MovieClip;
				}
				else if(tg.name=="btn_mix"){
					CanvasData.brushSize=15;
					if(_currSizeBtn) _currSizeBtn.gotoAndStop(1);
					_currSizeBtn=tg as MovieClip;
				}
				else if(tg.name=="btn_small"){
					CanvasData.brushSize=10;
					if(_currSizeBtn) _currSizeBtn.gotoAndStop(1);
					_currSizeBtn=tg as MovieClip;
				}
			}
			else if(tg is SimpleButton){
				switch(tg.name)
				{
					case "btn_paizhao":
					{
						
						break;
					}
					case "btn_z":
					{
						_canvas.undo();
						break;
					}
					case "btn_clear":
					{
						_canvas.clear();
						break;
					}
					case "btn_save":
					{
						saveThis();
						break;
					}
					case "btn_lishi":
					{
						KingDispatcher.getInstance().dispatchEvent(new NavigatorEvent(NavigatorEvent.ADD_VIEW,"picWallView"));						
						break;
					}
						
					default:
					{
						break;
					}
				}
			}
			
		}
		/**
		 *保存留言 
		 * 
		 */		
		private function saveThis():void
		{
			// TODO Auto Generated method stub
			var date:Date=new Date();
			var des:String=date.fullYear+"年"+dateformat(date.month+1)+"月";
			if(Data.localData.data["pnum"+des]==null){
				Data.localData.data["pnum"+des]=1;
			}
			else{
				Data.localData.data["pnum"+des]++;
			}
			Data.localData.flush();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			Alert.getInstance().show("正在保存，请稍后！",this);
			TweenLite.delayedCall(0.2,saveFile,[BgimgData.saveUrl]);
		}
		private function saveFile($url:String):void{
			var bmpd:BitmapData=new BitmapData(PicwallData.wid,PicwallData.heg);
			bmpd.draw(_canvasBg);
			var jpg:JPGEncoder=new JPGEncoder(80);
			var byte:ByteArray=jpg.encode(bmpd);
			var file:File=new File($url);
			if(!file.exists){
				file.createDirectory();
			}
			var data:Date=new Date();
			var riqi:String=data.fullYear+""+dateformat(data.month+1)+""+dateformat(data.date)+"_"+dateformat(data.hours)+""+dateformat(data.minutes)+""+dateformat(data.seconds);
//			var f:File=file.resolvePath($url+"/"+data.fullYear+"年"+dateformat(data.month+1)+"月/"+dateformat(data.month+1)+"月"+dateformat(data.date)+"日/"+riqi+".jpg");
			var f:File=file.resolvePath($url+"/"+riqi+".jpg");
			var stream:FileStream=new FileStream();
			stream.open(f,FileMode.WRITE);
			stream.writeBytes(byte);
			stream.close();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			_canvas.clear();
			Alert.getInstance().show("保存完成！",this);
			
		}
		private function dateformat($data:int):String{
			if($data<10){
				return "0"+$data;
			}
			else return $data+"";
		}
		private function loadImg(url:String):void
		{
			// TODO Auto Generated method stub
			if(_canvasBgLoader!=null){
				_canvasBgLoader.unload();
				_canvasBgLoader.url=url;
			}
			else{
				_canvasBgLoader=new ImageLoader(url,{width:PicwallData.wid,height:PicwallData.heg,container:_canvasBg,scaleMode:ScaleMode.STRETCH});
			}
			_canvasBgLoader.load();
		}
		
		override public function onPause():Boolean
		{
			// TODO Auto Generated method stub
			return super.onPause();
		}
		
		override public function onReStart():Boolean
		{
			// TODO Auto Generated method stub
			return super.onReStart();
		}
		
		
	}
}