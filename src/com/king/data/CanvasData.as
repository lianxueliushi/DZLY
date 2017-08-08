package com.king.data
{
	import com.Control.canva.LabiBrush;
	import com.Control.canva.Line;
	import com.Control.canva.MaobiBrush;
	import com.Control.canva.ShuibiBrush;
	import com.Control.canva.ShuimoBrush;
	import com.Control.canva.XiebiBrush;

	public class CanvasData
	{
		public static var brushType:Class=MaobiBrush;
		public static var brushColor:int;
		public static var brushSize:Number=10;
		public static const MAOBI:int=0;
		public static const QIANBI:int=1;
		public static const SHUIBI:int=2;
		public static const LABI:int=3;
		public static const SHUIMO:int=4;
		public static const XIEBI:int=5;
		public function CanvasData()
		{
		}
		public static function set TypeClass($i:int):void{
			switch($i)
			{
				case 0:
				{
					brushType=MaobiBrush;
					break;
				}
				case 1:
				{
					brushType=Line;
					break;
				}
				case 2:
				{
					brushType=ShuibiBrush;
					break;
				}
				case 3:
					brushType=LabiBrush;
					break;
				case 4:
					brushType=ShuimoBrush;
					break;
				case 5:
					brushType=XiebiBrush;
					break;
				default:
				{
					brushType=MaobiBrush;
					break;
				}
			}
		}
	}
}