package com.king.component
{
	import com.greensock.TweenLite;
	import com.king.component.Prompt;
	import com.king.control.KingMouseObject;
	import com.king.control.Navigator;
	import com.king.control.ViewObject;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import com.views.View_PreviewImg;

	/**
	 *图片左右切换 简单的图片轮播 
	 * @author Administrator
	 * 
	 */	
	public class Component_PictureTransition extends ViewObject
	{
		/**
		 *左右切换需要两张图片 
		 */		
		private var _img1:ImgContainer;
		private var _img2:ImgContainer;
		private var _currThum:ImgContainer;
		private var _imgContainer:Sprite;
		private var _imgFileList:Array;
		private var _currIndex:int=-1;
		private var _message:Prompt;
		private var _zdTimer:Timer=new Timer(3*1000,0);
		private var _sdTimer:Timer=new Timer(8*1000,0);
		private var _leftBtn:DisplayObject;
		private var _rightBtn:DisplayObject;
		private var _heg:Number;
		private var _wid:Number;

		private var mouseHandler:KingMouseObject;
		/**
		 * 
		 * @param $wid
		 * @param $heg
		 * @param $leftBtn 左按钮 左右按钮用同一个类，右侧按钮180度旋转就可以了
		 * @param $rightBtn 右按钮
		 * @param $imgFileList 图片文件数组
		 * @param $currFile 首次显示的图片
		 * 
		 */		
		public function Component_PictureTransition($wid:Number, $heg:Number, $leftBtn:DisplayObject,$rightBtn:DisplayObject,$imgFileList:Array,$currFile:File=null,$name:String="Component_PictureTransition")
		{
			super($name);
			_wid=$wid;
			_heg=$heg;
			_imgFileList=$imgFileList;
			createMessageTip();
			_imgContainer=new Sprite();
			addChild(_imgContainer);
			/*var ms:Sprite=getRect(_wid,_heg,0xcccccc,0);
			addChild(ms);
			_imgContainer.mask=ms;*/
			
			if(_imgFileList){
				var tempIndex:int=0;
				if($currFile==null){
					_currIndex=0;
				}
				else{
					for (var i:int = 0; i < _imgFileList.length; i++) 
					{
						if($currFile==_imgFileList[i]){
							_currIndex=i;
						}
					}
				}
				_leftBtn=$leftBtn;
				_rightBtn=$rightBtn;
			}
			else{
				_message.showMessage("没有内容！",true);
			}
			onCreate();
		}
		
		override public function onDispose():Boolean
		{
			// TODO Auto Generated method stub
			this.removeChild(_imgContainer);
			if(_zdTimer){
				_zdTimer.removeEventListener(TimerEvent.TIMER,zdTimerTick);
				_zdTimer.stop();
				_zdTimer=null;
			}
			if(_sdTimer){
				_sdTimer.removeEventListener(TimerEvent.TIMER,sdTimerTick);
				_sdTimer.removeEventListener(TimerEvent.TIMER,sdTimerTick);
				_sdTimer.stop();
				_sdTimer=null;
			}
			if(_leftBtn) _leftBtn.removeEventListener(MouseEvent.CLICK,btnClick);
			if(_rightBtn) _rightBtn.removeEventListener(MouseEvent.CLICK,btnClick);
			return super.onDispose();
		}
		
		override public function onCreate():Boolean
		{
			// TODO Auto Generated method stub
			if(_imgFileList==null || _imgFileList.length==0){
				return false;
			}
			createImgUI();
			_zdTimer.addEventListener(TimerEvent.TIMER,zdTimerTick);
			_sdTimer.addEventListener(TimerEvent.TIMER,sdTimerTick);
			if(_leftBtn){
				_leftBtn.addEventListener(MouseEvent.CLICK,btnClick);
				_leftBtn.x=-_leftBtn.width-20;
				_leftBtn.y=_heg-_leftBtn.height>>1;
				addChild(_leftBtn);
			}
			if(_rightBtn){
				_rightBtn.addEventListener(MouseEvent.CLICK,btnClick);
				_rightBtn.rotation=180;
				_rightBtn.x=_wid+_leftBtn.width+20;
				_rightBtn.y=(_heg-_leftBtn.height>>1)+38;
				addChild(_rightBtn);
			}
			return super.onCreate();
		}
		
		
		/**
		 *左右按钮点击 
		 * @param event
		 * 
		 */		
		protected function btnClick(event:Event):void
		{
			// TODO Auto-generated method stub
			_zdTimer.stop();
			_sdTimer.start();
			var tg:DisplayObject=event.currentTarget as DisplayObject;
			try{
				(tg as MovieClip).gotoAndPlay("play");
			}
			catch(e:Error){
				trace(e.message);
			}
			if(tg==_leftBtn){
				moveRight();
			}
			else if(tg==_rightBtn){
				moveLeft();
			}
			tg=null;
		}
		/**
		 *手动翻页时间计时完成 
		 * @param event
		 * 
		 */		
		protected function sdTimerTick(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			_zdTimer.reset();
			_zdTimer.start();
		}
		/**
		 *自动翻页时间计时完成 
		 * @param event
		 * 
		 */		
		protected function zdTimerTick(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			moveLeft();
		}
		/**
		 *左移动 
		 * 
		 */		
		private function moveLeft():void
		{
			if(_imgFileList.length<2){
				return ;
			}
			var anotherTg:ImgContainer=_currThum==_img1?_img2:_img1;
			anotherTg.x=_wid;
			anotherTg.reLoad(getNextfile());
			TweenLite.to(anotherTg,0.6,{x:0});
			TweenLite.to(_currThum,0.6,{x:-_wid,onComplete:unLoadImg,onCompleteParams:[_currThum,anotherTg]});
		}
		/**
		 *右移动 
		 * 
		 */		
		private function moveRight():void{
			if(_imgFileList.length<2){
				return ;
			}
			var anotherTg:ImgContainer=_currThum==_img1?_img2:_img1;
			anotherTg.x=-_wid;
			anotherTg.reLoad(getPrefile());
			TweenLite.to(anotherTg,0.6,{x:0});
			TweenLite.to(_currThum,0.6,{x:_wid,onComplete:unLoadImg,onCompleteParams:[_currThum,anotherTg]});
		}
		/**
		 *卸载图片 
		 * @param $loader 要卸载的loader
		 * @param $an 新的当前Loader
		 * 
		 */		
		private function unLoadImg($loader:ImgContainer,$an:ImgContainer):void{
			$loader.unLoadImg();
			_currThum=$an;
		}
		/**
		 *创建提示信息 
		 * 
		 */		
		private function createMessageTip():void
		{
			_message=new Prompt();
			addChild(_message);
			_message.x=_wid/2-80;
			_message.y=_heg-50;
		}
		private function createImgUI():void
		{
			_img1=new ImgContainer(_wid,_heg,_imgFileList[_currIndex],true);
			if(_imgFileList.length>1){
				_img2=new ImgContainer(_wid,_heg,_imgFileList[_currIndex],true);
				_imgContainer.addChild(_img2);
				_img2.x=_wid;
				_zdTimer.start();
			}
			_imgContainer.addChild(_img1);
			_currThum=_img1;
			mouseHandler=new KingMouseObject(_imgContainer);
			mouseHandler.clickFunction=onImgClick;
			mouseHandler.moveLeftFunction=onMoveLeft;
			mouseHandler.moveRightFunction=onMoveRight;
		}
		
		private function onMoveRight(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			_zdTimer.stop();
			_sdTimer.start();
			moveRight();
		}
		
		private function onMoveLeft(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			_zdTimer.stop();
			_sdTimer.start();
			moveLeft();
		}
		/**
		 *点击图片  
		 * @param event
		 * 
		 */		
		protected function onImgClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
//			this.mouseChildren=false;
//			this.mouseEnabled=false;
			var file:File=_imgFileList[int(_currIndex%_imgFileList.length)];
			var str:String=file.extension.toLowerCase();
			if(str=="jpg" || str=="jpeg" || str=="png" ||str=="gif")
			{
				Navigator.getInstance().addView(new View_PreviewImg(file,_imgFileList));
			}
		
		}
		protected function getRect($wid:int,$heg:int,$color:int,$alpha:Number=1):Sprite{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill($color,$alpha);
			sp.graphics.drawRect(0,0,$wid,$heg);
			sp.graphics.endFill();
			return sp;
		}
		/**
		 *获取上一个文件 
		 * @return 
		 * 
		 */		
		private function getPrefile():File{
			if(_currIndex-1<0){
				_currIndex=_imgFileList.length;
			}
			var index:int=(_currIndex-1)%_imgFileList.length;
			_currIndex--;
			return _imgFileList[index];
		}
		/**
		 *获取下一个文件 
		 * @return 
		 * 
		 */		
		private function getNextfile():File{
			var index:int=(_currIndex+1)%_imgFileList.length;
			_currIndex++;
			trace("index:"+index);
			return _imgFileList[index];
		}
	}
}