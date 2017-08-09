package
{
	import com.king.control.FileControl;
	import com.king.control.KingView;
	import com.king.control.Navigator;
	import com.king.data.BgimgData;
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
			Data.localData=SharedObject.getLocal("xy_dzly");
			if(Data.localData.data["pnum"]!=null){
				Data.personNum=Data.localData.data["pnum"];
			}else{
				var array:Array=FileControl.getImgFileDirs(BgimgData.saveUrl);
				Data.localData.data["pnum"]=Data.personNum=array.length;
				for each (var file:File in array) 
				{
					var str1:String=file.name.slice(0,8);
					var str2:String=file.name.slice(0,6);
					if(Data.localData.data["num"+str1]==null){
						Data.localData.data["num"+str1]=0;
					}
					if(Data.localData.data["num"+str2]==null){
						Data.localData.data["num"+str2]=0;
					}
					Data.localData.data["num"+str1]++;
					Data.localData.data["num"+str2]++;
				}
				
			}
			stage.color=0xcccccc;
			Data.localData.flush();
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