package com.king.component
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.core.LoaderItem;
	import com.king.control.ViewObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import ui.VideoIcon;
	
	public class ImgContainer extends ViewObject
	{
		public static const LOAD_COMPLETE:String="load_complete";
		private var _source:File;
		private var _loader:LoaderItem;
		private var _wid:int;
		private var _heg:int;
		private var _bitmap:Bitmap;
		private var _stretch:Boolean=false;
		private var _type:String="img";
		public static const TYPE_IMG:String="img";
		public static const TYPE_VIDEO:String="video";
		public function ImgContainer($wid:int,$heg:int,$file:File=null,$stretch:Boolean=false,$name:String="ImgContainer")
		{
			super($name);
			_wid=$wid;
			_heg=$heg;
			_stretch=$stretch;
			_source=$file;
			if(_source){
				load();
			}
			_bitmap=new Bitmap();
			this.graphics.lineStyle(2,0x000000);
			this.graphics.drawRect(-2,-2,_wid+4,_heg+4);
			this.graphics.endFill();
		}
		
		public function set source($url:File):void{
			_source=$url;
		}
		public function load():void{
			if(_source){
				if(_source.exists){
					toBitmap();
				}else {
					trace("文件不存在！"+_source.url);
				}
			}
			else{
				trace("文件不存在！"+_source.url);
			}
		}
		private function toBitmap():void
		{
			// TODO Auto Generated method stub
			var extension:String=_source.extension.toLowerCase();
			if(_loader!=null){
				_loader.dispose(true);
				_loader=null;
			}
			if(extension=="flv" || extension=="mp4"){
				_type=TYPE_VIDEO;
				_loader=new VideoLoader(_source.url,{width:_wid,height:_heg,onComplete:completeHandler,autoPlay:false,scaleMode:ScaleMode.STRETCH});
				_loader.load();
			}//jpg,jpeg,png,gif,bmp
			else if(extension=="png" || extension=="jpg" || extension=="bmp" ||extension=="jpeg" || extension=="gif"){
				_type=TYPE_IMG;
				if(_stretch) _loader=new ImageLoader(_source.url,{width:_wid,height:_heg,scaleMode:ScaleMode.STRETCH});
				else _loader=new ImageLoader(_source.url);
				(_loader as ImageLoader).autoDispose=true;
				_loader.addEventListener(LoaderEvent.COMPLETE,imgLoaded);
				_loader.load();
			}
		}
		/**
		 *视频类型加载完成  只取一个视频截图
		 * @param e
		 * 
		 */		
		protected function completeHandler(e:LoaderEvent):void{
			var ct:Sprite=(_loader as VideoLoader).content;
			this.addChild(ct);
			var icon:VideoIcon=new VideoIcon();
			ct.addChild(icon);
			icon.x=_wid-icon.width>>1;
			icon.y=_heg-icon.height>>1;
			var bmpd:BitmapData=new BitmapData(_wid,_heg);
			bmpd.draw(ct);
			_bitmap.bitmapData=bmpd;
			this.addChild(_bitmap);
			_bitmap.alpha=1;
			TweenLite.from(_bitmap,0.6,{alpha:0});
			_loader.removeEventListener(LoaderEvent.COMPLETE,completeHandler);
			_loader.unload();
			_loader.dispose();
			_loader=null;
			this.removeChild(ct);
			ct=null;
			this.dispatchEvent(new Event(LOAD_COMPLETE));
		}
		/**
		 *图片类型加载完成 
		 * @param event
		 * 
		 */		
		protected function imgLoaded(event:LoaderEvent):void
		{
			// TODO Auto-generated method stub
			_bitmap=(_loader as ImageLoader).rawContent;
			this.addChild(_bitmap);
			_bitmap.alpha=1;
			TweenLite.from(_bitmap,0.6,{alpha:0});
			if((_bitmap.width<_wid && _bitmap.height<_heg) || _stretch){
				_bitmap.x=_wid-_bitmap.width>>1;
				_bitmap.y=_heg-_bitmap.height>>1;
				this.dispatchEvent(new Event(LOAD_COMPLETE));
				return ;
			}
			else if(_bitmap.width/_bitmap.height<_wid/_heg){
				_bitmap.scaleX=_bitmap.scaleY=_heg/_bitmap.height;
				_bitmap.x=_wid-_bitmap.width>>1;
			}
			else if(_bitmap.width/_bitmap.height>_wid/_heg){
				_bitmap.scaleX=_bitmap.scaleY=_wid/_bitmap.width;
				_bitmap.y=_heg-_bitmap.height>>1;
			}
			this.dispatchEvent(new Event(LOAD_COMPLETE));
		}

		public function get wid():int
		{
			return _wid;
		}

		public function get heg():int
		{
			return _heg;
		}


		public function reLoad(param0:File):void
		{
			// TODO Auto Generated method stub
			_source=param0;
			if(_loader){
				unLoadImg()
			}
			_loader.url=_source.url;
			trace(decodeURI(_source.url));
			load();
		}
		public function unLoadImg():void{
			if(_loader && _bitmap.parent==this) this.removeChild(_bitmap);
		}

		public function get source():File
		{
			return _source;
		}

	}
}