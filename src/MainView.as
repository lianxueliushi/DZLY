package
{
	import com.king.control.BgMusicControl;
	import com.king.control.KingView;
	import com.king.control.Navigator;
	import com.king.dispatchers.KingDispatcher;
	import com.king.events.MyEvent;
	import com.king.events.NavigatorEvent;
	import com.views.View_PreviewImg;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	public class MainView extends KingView
	{
		private var backTimer:Timer;
		public function MainView($add:Boolean=true, $name:String="MainView")
		{
			super($add, $name);
			Data.stageWidth=stage.stageWidth;
			Data.stageHeight=stage.stageHeight;
			Mouse.hide();
			backTimer=new Timer(Data.backTime,1);
			backTimer.addEventListener(TimerEvent.TIMER_COMPLETE,timeComplete);
			backTimer.start();
			stage.addEventListener(KeyboardEvent.KEY_UP,showMouse);
			KingDispatcher.getInstance().addEventListener(NavigatorEvent.ADD_VIEW,addView);
			KingDispatcher.getInstance().addEventListener(NavigatorEvent.REMOVE_VIEW,removeView);
			KingDispatcher.getInstance().addEventListener(NavigatorEvent.BACK_VIEW,timeComplete);
			KingDispatcher.getInstance().addEventListener(MyEvent.MOUSE_CLICK,onImgClick);
			stage.addEventListener(MouseEvent.CLICK,onStageClick);
			trace(Data.bgMusicUrl);
			BgMusicControl.getInstance().source=Data.bgMusicUrl;
			BgMusicControl.getInstance().volume=Data.bgMusicVolume;
			addChild(Navigator.getInstance());
		}
		
		protected function onImgClick(event:MyEvent):void
		{
			// TODO Auto-generated method stub
			Navigator.getInstance().addView(new View_PreviewImg(event.data.file,event.data.fileList));
		}
		
		protected function onStageClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			resetTimer();
		}
		
		protected function removeView(event:Event):void
		{
			// TODO Auto-generated method stub
			Navigator.getInstance().removeView();
		}
		
		protected function timeComplete(event:TimerEvent=null):void
		{
			// 计时结束回到默认页面
			backTimer.stop();
			Navigator.getInstance().back();
		}
		
		protected function showMouse(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(event.keyCode==Keyboard.ALTERNATE && event.ctrlKey){
				Mouse.show();
			}
			backTimer.reset();
			backTimer.start();
		}
		private function resetTimer():void{
			backTimer.reset();
			backTimer.start();
		}
		protected function addView(event:NavigatorEvent):void
		{
			// 具体方法由子类实现
			
		}
	}
}