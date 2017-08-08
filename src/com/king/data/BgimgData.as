package com.king.data
{
	
	import com.king.control.FileControl;
	public class BgimgData
	{
		public static const saveUrl:String="D:/项目资料/资料_河南科技学院校史馆/电子留言/留言文件";
		private static var _saveList:Array;
		public function BgimgData()
		{
		}
		public static function get saveList():Array
		{
			_saveList=FileControl.getImgFileDirs(saveUrl);
			return _saveList;
		}
	}
}