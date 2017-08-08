package
{
	import com.Data.BgimgData;
	import com.king.control.FileControl;
	import com.king.control.KingView;
	import com.king.control.Navigator;
	import com.king.events.NavigatorEvent;
	import com.views.CanvaView;
	import com.views.PicsWallView;
	
	import flash.display.StageDisplayState;
	import flash.filesystem.File;
	import flash.net.SharedObject;

	[SWF(width="1920",height="1080")]
	public class Main extends MainView
	{
		public function Main()
		{
			super();
			stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;
			Data.localData=SharedObject.getLocal("xy_dzly1");
			if(Data.localData.data["pnum"]!=null){
				Data.personNum=Data.localData.data["pnum"];
			}else{
				var array:Array=FileControl.getImgFileDirs(BgimgData.saveUrl);
				Data.localData.data["pnum"]=Data.personNum=array.length;
				for each (var file:File in array) 
				{
					var str1:String=file.name.slice(0,8);
					var str2:String=file.name.slice(0,6);
					Data.localData.data[str1+"num"]++;
					Data.localData.data[str2+"num"]++;
					trace(str2+"num");
				}
				
			}
			Data.localData.flush();
			trace("2017.08:"+Data.localData.data["201708num"]+Data.localData.data["pnum"]);
			addViewByName("navigator");
		}
		
		override protected function addView(event:NavigatorEvent):void
		{
			// TODO Auto Generated method stub
			addViewByName(event.data);
			
		}
		private function addViewByName($name:String):void{
			var view:KingView;
			switch($name)
			{
				case "navigator":
				{
					view=new CanvaView();
					Navigator.getInstance().addView(view);
					break;
				}
				case "picWallView":
				{
					view=new PicsWallView();
					Navigator.getInstance().addView(view);
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
	}
}