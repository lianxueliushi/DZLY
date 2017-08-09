package com.king.component
{
	import com.greensock.TweenLite;
	import com.king.control.VScrollControl;
	import com.king.control.ViewObject;
	import com.king.dispatchers.KingDispatcher;
	import com.king.events.MyEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class ImgThumList extends ViewObject
	{
		private var _wid:int;
		private var _heg:int;
		private var _gapV:int=15;
		private var _gapH:int=10;
		private var _row:int=3;
		private var _col:int=6;
		private var _thumWid:int;
		private var _thumHeg:int;
		private var _imgList:Array;
		private var _container:VScrollControl;
		private var _perPage:int;
		private var _tempList:Array=[];
		private var _page:int=-1;
		public function ImgThumList($wid:int,$heg:int,$col:int,$row:int,$name:String="ViewObject")
		{
			super($name);
			_wid=$wid;
			_heg=$heg;
			_row=$row;
			_col=$col;
			_container=new VScrollControl($wid,$heg);
			_container.addEventListener(MyEvent.DragEndToBottom,setPerPage);
			_thumWid=(_wid-_gapH*(_col+1))/_col;
			_thumHeg=(_heg-_gapV*(_row+1))/_row;
			_perPage=_col*_row;
			this.addChild(_container);
		}
		
		private function setPerPage(e:Event=null):void{
			_page++;
			_tempList=_imgList.slice(_page*_perPage,_page*_perPage+_perPage);
			if(_tempList.length>0){
				for (var i:int = 0; i < _tempList.length; i++) 
				{
					var img:ImgContainer=new ImgContainer(_thumWid,_thumHeg,null,true);
					var xx:int=_gapH+(_thumWid+_gapH)*int((i+_page*_perPage)%_col);
					var yy:int=_gapV+(_thumHeg+_gapV)*int((i+_page*_perPage)/_col);
					_container.addCell(img,xx,yy);
					TweenLite.delayedCall(0.2*i,loadImg,[img,_tempList[i]]);
					img.addEventListener(MouseEvent.CLICK,onClick);
				}
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			KingDispatcher.getInstance().dispatchEvent(new MyEvent(MyEvent.MOUSE_CLICK,{file:(event.currentTarget as ImgContainer).source,fileList:_imgList}));
		}
		
		private function loadImg($img:ImgContainer,$source:File):void
		{
			// TODO Auto Generated method stub
			$img.source=$source;
			$img.load();
		}
		public function set imgList(value:Array):void
		{
			_page=-1;
			_imgList = value;
			if(_imgList.length>0){
				setPerPage();
			}
			
		}
		public function clear():void{
			_container.removeAll();
			_tempList=[];
		}
		public function set gapV(value:int):void
		{
			_gapV = value;
			_thumWid=(_wid-_gapH*(_col+1))/_col;
			_thumHeg=(_heg-_gapV*(_row+1))/_row;
		}

		public function set gapH(value:int):void
		{
			_gapH = value;
			_thumWid=(_wid-_gapH*(_col+1))/_col;
			_thumHeg=(_heg-_gapV*(_row+1))/_row;
		}
		
		
	}
}