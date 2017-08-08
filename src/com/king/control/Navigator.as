package com.king.control
{
	import com.greensock.TweenMax;
	public class Navigator extends ViewObject
	{
		private static  var _instance:Navigator = new Navigator();  
		private var _navigators:Array=[];
		public function Navigator($name:String="Navigator")
		{
			super($name);
			if(_instance){
				throw new Error("只能用getInstance()来获取实例");
			}
		}
		public static function getInstance():Navigator{
			return _instance;
		}
		public  function addView($view:KingView):void{
			this.addChild($view);
			$view.alpha=1;
			TweenMax.from($view,0.6,{alpha:0});
			_navigators.push($view);
			if(_navigators.length>1){
				var oldView:KingView=_navigators[_navigators.length-2];
				if(oldView.addAble){
					oldView.onPause();
				}
				else{
					_navigators.splice(_navigators.length-2,1);
					this.removeChild(oldView);
					oldView=null;
				}
			}
		}
		public function removeView():void{
			var newView:KingView;
			var removedView:KingView;
			if(_navigators.length<=0){
				return ;
			}
			if(_navigators.length>1){
				newView=_navigators[_navigators.length-2];
				newView.onReStart();
			}
			removedView=_navigators[_navigators.length-1];
			_navigators.pop();
			this.removeChild(removedView);
			removedView=null;
		}
		public function get latestView():KingView{
			if(_navigators.length<1){
				return null;
			}
			else return _navigators[_navigators.length-1]
		}
		public function back():void{
			//移除所有页面，只剩下首页
			if(_navigators.length<1){
				return ;
			}
			var len:int=_navigators.length;
			for (var i:int = 0; i < len-1; i++) 
			{
				removeView();
			}
		}
		public function removeViewAt($n):Boolean{
			if($n<_navigators.length){
				var child:KingView=_navigators.splice($n,1) as KingView;
				this.removeChild(child);	
				return true;
			}
			else{
				return false;
			}
		}
		public function get length():int{
			return _navigators.length;
		}
	}
}