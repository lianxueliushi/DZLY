package com.views
{
	import com.king.component.ImgThumList;
	import com.king.component.Prompt;
	import com.king.component.SkinButton;
	import com.king.control.FileControl;
	import com.king.control.KingView;
	import com.king.control.Navigator;
	import com.king.data.BgimgData;
	import com.king.data.PicwallData;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import ui.btn_back;
	
	public class PicsWallView extends KingView
	{
		[Embed(source="/assets/bg3.jpg")]
		private var SKIN:Class;
		private var _btnBack:btn_back;
		private var _sousuoTxt:TextField;
		private var _lable:TextField;
		private var imgThum:ImgThumList;

		private var _sourceList:Array;

		private var temp:Array;

		private var mess:Prompt;
		public function PicsWallView($name:String="ViewObject")
		{
			super($name);
			var skin:Bitmap=new SKIN();
			this.addChild(skin);
			_sourceList=FileControl.getImgFileDirs(BgimgData.saveUrl).reverse();
			imgThum=new ImgThumList(1722,790,6,4);
			imgThum.gapH=30;
			imgThum.gapV=30;
			imgThum.imgList=_sourceList;
			this.addChild(imgThum);
			imgThum.x=104;
			imgThum.y=156;
			_btnBack=new btn_back();
			this.addChild(_btnBack);
			_btnBack.x=1591;
			_btnBack.y=975;
			_btnBack.addEventListener(MouseEvent.CLICK,onBackClick);
			
			var _tf:TextFormat=new TextFormat();
			_tf.size=20;
			_tf.font=new FONT_FZCS().fontName;
			_sousuoTxt=new TextField();
			_sousuoTxt.type=TextFieldType.INPUT;
			_sousuoTxt.background = true; 
			_sousuoTxt.width=200;
			_sousuoTxt.height=50;
			_sousuoTxt.x=164;
			_sousuoTxt.y=126;
			_sousuoTxt.text="输入日期";
			_sousuoTxt.setTextFormat(_tf);
//			_sousuoTxt.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(_sousuoTxt);
			
			
			var date:Date=new Date();
			_lable=new TextField();
			_lable.autoSize=TextFieldAutoSize.LEFT;
			_lable.x=370;
			_lable.y=126;
			_lable.defaultTextFormat=_tf;
			_lable.embedFonts=true;
			this.addChild(_lable);
			temp=[];
			var riqi:String=date.fullYear+""+dateformat(date.month+1)+""+dateformat(date.date);
			_lable.text=date.fullYear+"年"+(date.month+1)+"月"+date.date+"日的留言人数为："+searchDate(riqi).length+"人次";
		}
		private function dateformat($data:int):String{
			if($data<10){
				return "0"+$data;
			}
			else return $data+"";
		}
		override protected function addedToView(event:Event):void
		{
			// TODO Auto Generated method stub
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
			super.addedToView(event);
		}
		
		
		protected function keyHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(event.keyCode==Keyboard.ENTER){
				var des:String=_sousuoTxt.text;
				if(des.length==8){
					_lable.text=des.substr(0,4)+"年"+des.substr(4,2)+"月"+des.substr(6,2)+"日的留言人数为："+searchDate(des).length+"人次";
				}
				else if(des.length==6){ 
					_lable.text=des.substr(0,4)+"年"+des.substr(4,2)+"月的留言人数为："+searchDate(des).length+"人次";
				}
				else if(des.length==4){
					_lable.text=des.substr(0,4)+"年的留言人数为："+searchDate(des).length+"人次";
				}
				else{
					showMessage("请输入日期格式如：20170808");
				}
			}
		}
		private function searchDate(text:String):Array
		{
			// TODO Auto Generated method stub
			temp=[];
			for each (var f:File in _sourceList) 
			{
				if(f.name.search(text)!=-1){
					temp.push(f);
				}
			}
			imgThum.clear();
			if(temp.length>0){
				imgThum.imgList=temp;
			}
			else{
				showMessage("当日无人留言!");
			}
			return temp;
		}
		private function showMessage($str:String,$autodispear:Boolean=true,$time:int=3):void{
			mess=new Prompt();
			mess.showMessage($str,$autodispear,$time);
			this.addChild(mess);
			mess.x=Data.stageWidth-mess.width>>1;
			mess.y=Data.stageHeight-200;
		}
		protected function onBackClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Navigator.getInstance().removeView();
		}
	}
}