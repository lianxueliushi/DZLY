package com.king.component
{
	import com.king.dispatchers.KingDispatcher;
	import com.king.events.NavigatorEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class Component_picTransForPreview extends Component_PictureTransition
	{
		public function Component_picTransForPreview($wid:Number, $heg:Number, $leftBtn:DisplayObject, $rightBtn:DisplayObject, $imgFileList:Array, $currFile:File=null)
		{
			super($wid, $heg, $leftBtn, $rightBtn, $imgFileList, $currFile);
		}
		
		override protected function onImgClick(event:MouseEvent):void
		{
			this.mouseChildren=false;
			this.mouseEnabled=false;
			KingDispatcher.getInstance().dispatchEvent(new NavigatorEvent(NavigatorEvent.REMOVE_VIEW));
		}
	}
}