package com.king.control
{
	public interface KingObject
	{
		/**
		 *一个物体，拥有创建，开始运行，暂停运行，销毁 四个状态
		 * @param target
		 * 
		 */		
		function onCreate():Boolean;
		function onReStart():Boolean;
		function onPause():Boolean;
		function onDispose():Boolean;
	}
}