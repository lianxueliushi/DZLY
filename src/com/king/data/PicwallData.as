package com.king.data
{
	public class PicwallData
	{
		private static var picList:Array;
		public static const wid:Number=1561;
		public static const heg:Number=741;
		public static const picWid:Number=250;
		public static const picHeg:Number=108;
		public static const thumWid:Number=96;
		public static const thumHeg:Number=40.3;

		public function PicwallData()
		{
		}
		public static function getdataAt($n:int):String{
			var str:String;
			if(!picList || $n>picList.length-1){
				return null;
			}
			else{
				str=picList[$n];
				return str;
			}
		}
		public static function getindex($str:String):int{
			var n:int=0;
			if(!picList){
				return 0;
			}
			else{
				n=picList.indexOf($str);
				return n;
			}
		}
	}
}