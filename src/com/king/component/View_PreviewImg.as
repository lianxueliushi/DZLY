package xy.view
{
	import com.greensock.TweenLite;
	import com.lijingjing.util.PView;
	
	import flash.filesystem.File;
	
	import xy.components.Component_picTransForPreview;

	/**
	 *图片预览 
	 * @author Administrator
	 * 
	 */	
	public class View_PreviewImg extends PView
	{

		private var myPicturn:Component_picTransForPreview;
		public function View_PreviewImg($imgFile:File,$imgFileList:Array,disposeAll:Boolean=false)
		{
			super(disposeAll);
			
			
			var leftBtn:UI_btnLeft=new UI_btnLeft();
			var rightBtn:UI_btnLeft=new UI_btnLeft();
			myPicturn=new Component_picTransForPreview(Globle.stageWidth-200,Globle.stageHeight-100,leftBtn,rightBtn,$imgFileList,$imgFile);
		}
		
		override protected function onCreate():void
		{
			// TODO Auto Generated method stub
			super.onCreate();
			addChild(myPicturn);
			myPicturn.x=100;
			myPicturn.y=50;
			this.setbgColor(0x000000,0.8);
			TweenLite.from(this.bg,0.3,{alpha:0,delay:0.3});
			/*Multitouch.inputMode=MultitouchInputMode.GESTURE;
			multitouch=OSMultiTouch.getInstance();
			gesture=new MultiDragScaleRotate();
			gesture.isRotatable=false;
			gesture.maxScale=2;
			gesture.minScale=0.8;
			multitouch.enableGesture(myPicturn,gesture);*/
		}
		
		
	}
}