package com.king.control
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class BgMusicControl extends Sound
	{
		private static  var _instance:BgMusicControl = new BgMusicControl();  
		private var _soundChannel:SoundChannel;
		private var _soundTrans:SoundTransform;
		private var _url:String;
		private var _vol:Number=1;
		private var _soundPosition:Number=0;
		public function BgMusicControl()
		{
			if(_instance){
				throw new Error("只能用getInstance()来获取实例");
			}
			_soundChannel=new SoundChannel();
			_soundTrans=new SoundTransform();
			_soundTrans.volume=_vol;
		}
		public static function getInstance():BgMusicControl{
			return _instance;
		}
		public function set source($url:String):void{
			_soundPosition=0;
			_url=$url;
			load(new URLRequest($url));
			this.addEventListener(Event.COMPLETE,soundLoaded);
		}
		
		protected function soundLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			if(_soundChannel){
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayOver);
			}
			_soundChannel=this.play(_soundPosition,0,_soundTrans);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE,soundPlayOver);
		}
		protected function soundPlayOver(event:Event):void
		{
			// TODO Auto-generated method stub
			_soundPosition=0;
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayOver);
			_soundChannel=super.play(_soundPosition,0,_soundTrans);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE,soundPlayOver);
		}
		public function pause():void{
			_soundPosition=_soundChannel.position;
			_soundChannel.stop();
		}
		public function stop():void{
			_soundPosition=0;
			_soundChannel.stop();
		}
		override public function play(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null):SoundChannel
		{
			// TODO Auto Generated method stub
			if(_soundChannel){
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayOver);
			}
			_soundChannel=super.play(_soundPosition, 0, _soundTrans);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE,soundPlayOver);
			return _soundChannel;
		}
		public function set volume($vol:Number):void{
			_vol=$vol;
			_soundTrans.volume=_vol;
			_soundChannel.soundTransform=_soundTrans;
		}
		
	}
}