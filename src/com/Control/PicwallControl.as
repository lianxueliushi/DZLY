package com.Control
{
	import com.Data.BgimgData;
	import com.Data.PicwallData;
	import com.Event.PicwallEvent;
	import com.View.PicMc;
	import com.greensock.TweenLite;
	import com.lijingjing.event.LiEvent;
	import com.lijingjing.util.Pic2View;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import flash.printing.PrintJobOrientation;
	import flash.printing.PrintUIOptions;
	
	import xy.components.Component_ThumList;
	import xy.control.LiButtonBox;
	import xy.control.XipingNavigatorBtn;
	import xy.util.FileArrayObj;
	
	public class PicwallControl extends Sprite
	{
		private var picwallView:Component_ThumList;
		private var isDown:Boolean;
		private var mousex:Number;
		private var downX:Number;
		private var mousey:Number;
		private var totalWid:Number;
		private var picwall:DetailView;
		private var bigPic:PicMc;
		private var currIndex:int;
		private var totalHeg:Number;
		private var bg:Sprite;
		private var fileArray:FileArrayObj;
		private var filelist:Array;
		private var btnControl:LiButtonBox;
		private var localIP:String;
		private var bmd:BitmapData;

		private var myPrintJob:PrintJob;
		public function PicwallControl()
		{
			super();
			init();
		}
		
		private function init():void
		{
			// TODO Auto Generated method stub
			fileArray=new FileArrayObj(BgimgData.saveUrl);
			if(fileArray.directoryFileList==null){
				Alert.getInstance().show("暂无留言文件，请检查！",this);
				return;
			}
			filelist=fileArray.directoryFileList.reverse();
			btnControl=new LiButtonBox(filelist,UI_NavigatorBtn,195,500,XipingNavigatorBtn,0,true);
			btnControl.addEventListener(LiEvent.SonClick,onChoose);
			addChild(btnControl);
			btnControl.x=30;
			btnControl.y=60;
			totalWid=PicwallData.wid;
			totalHeg=PicwallData.heg;
			trace(decodeURI(filelist[0].url));
			if(new FileArrayObj(filelist[0].url).imgFileList==null){
				Alert.getInstance().show("留言文件有空文件夹，请删除！",this);
			}
			else{
				picwallView=new Component_ThumList(PicwallData.wid-280,PicwallData.heg,new FileArrayObj(filelist[0].url).imgFileList.reverse(),4,4,null,false);
				this.addChild(picwallView);
				picwallView.x=240;
			}
			
			this.graphics.beginFill(0x000000,0.8);
			this.graphics.drawRect(0,0,totalWid,totalHeg+136);
			this.graphics.endFill();
			
			this.addEventListener(Event.ADDED_TO_STAGE,addtoStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,remove);
		}
		protected function onChoose(event:LiEvent):void
		{
			// TODO Auto-generated method stub
			var tg:XipingNavigatorBtn=event.data as XipingNavigatorBtn;
			var des:String=decodeURI(filelist[tg.id].name)
			if(picwallView){
				picwallView.clearList();
				picwall.txt.text=des+"共有"+Main.shareObj.data["pnum"+des]+"位留言者！";
				if(new FileArrayObj(filelist[tg.id].url).imgFileList!=null){
					picwallView.setSource(new FileArrayObj(filelist[tg.id].url).imgFileList.reverse());
				}
				else{
					Alert.getInstance().show("此文件为空文件夹，请删除！",this);
				}
			}
			else if(new FileArrayObj(filelist[tg.id].url).imgFileList!=null){
				picwallView=new Component_ThumList(PicwallData.wid-280,PicwallData.heg,new FileArrayObj(filelist[tg.id].url).imgFileList.reverse(),4,4,null,false);
				picwallView.addEventListener(LiEvent.SonClick,showDetil);
				this.addChild(picwallView);
				picwallView.x=240;
				
				bigPic=new PicMc(new FileArrayObj(filelist[tg.id].url).imgFileList.reverse()[currIndex].url,PicwallData.wid,PicwallData.heg);
				picwall.bigbg.addChild(bigPic);
				picwall.txt.text=des+"共有"+Main.shareObj.data["pnum"+des]+"位留言者！";
			}
			else if(new FileArrayObj(filelist[tg.id].url).imgFileList==null){
				Alert.getInstance().show("此文件为空文件夹，请删除！",this);
			}
			
		}
		protected function remove(event:Event):void
		{
			// TODO Auto-generated method stub
			picwall.closeBtn.removeEventListener(MouseEvent.CLICK,closeThis);
			picwall.bigbg.removeEventListener(MouseEvent.CLICK,closeBigbg);
			picwall.leftBtn.removeEventListener(MouseEvent.CLICK,onleftBtn);
			picwall.rightBtn.removeEventListener(MouseEvent.CLICK,onRightbtn);
			this.graphics.clear();
			PicwallDispatcher.getInstance().dispatchEvent(new PicwallEvent(PicwallEvent.PIC_REMOVED));
		}
		
		protected function addtoStage(event:Event):void
		{
			// TODO Auto-generated method stub
			PicwallDispatcher.getInstance().addEventListener(PicwallEvent.PIC_CLICK,showDetil);
			if(picwallView)	picwallView.addEventListener(LiEvent.SonClick,showDetil);
			picwall=new DetailView();
			this.addChild(picwall);
			bigPic=new PicMc(PicwallData.getdataAt(currIndex),PicwallData.wid,PicwallData.heg);
			picwall.bigbg.addChild(bigPic);
			picwall.bg.visible=false;
			picwall.bigbg.visible=false;
			picwall.leftBtn.visible=false;
			picwall.rightBtn.visible=false;
			picwall.btn_send.visible=false;
			picwall.mc_send.visible=false;
			picwall.dayin.visible=false;
			picwall.preview.visible=false;
			picwall.btn_send.addEventListener(MouseEvent.CLICK,onCreate2P);
			picwall.closeBtn.addEventListener(MouseEvent.CLICK,closeThis);
			picwall.bigbg.addEventListener(MouseEvent.CLICK,closeBigbg);
			picwall.leftBtn.addEventListener(MouseEvent.CLICK,onleftBtn);
			picwall.rightBtn.addEventListener(MouseEvent.CLICK,onRightbtn);
			picwall.dayin.addEventListener(MouseEvent.CLICK,onPrePrintView);
			picwall.preview.btn_sure.addEventListener(MouseEvent.CLICK,onDayin);
			picwall.preview.btn_cancle.addEventListener(MouseEvent.CLICK,oncancleDayin);
			var netinfo:NetworkInfo = NetworkInfo.networkInfo;
			var interfaces:Vector.<NetworkInterface >  = netinfo.findInterfaces();
			if (interfaces!=null)
			{
				var _macAddress:String = interfaces[0].hardwareAddress;
				localIP = interfaces[0].addresses[0].address;
				for each (var inf:NetworkInterface in interfaces) 
				{
					trace(inf.addresses[0].address);
				}
				
				trace(localIP);
				
			}
			var des:String=decodeURI(filelist[0].name);
			picwall.txt.text=des+"共有"+Main.shareObj.data["pnum"+des]+"位留言者！";
		}
		/**
		 *打印预览 
		 * @param event
		 * 
		 */		
		protected function onPrePrintView(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			picwall.preview.visible=true;
			var bitmap:Bitmap=new Bitmap();
			bmd=new BitmapData(1920,826);
			bmd.draw(bigPic);
			bitmap.bitmapData=bmd;
			
			picwall.preview.bg.addChild(bitmap);
			myPrintJob = new PrintJob();
			myPrintJob.orientation=PrintJobOrientation.LANDSCAPE;
			trace(myPrintJob.pageWidth,myPrintJob.pageHeight);
			bitmap.width=myPrintJob.pageWidth;
			bitmap.scaleY=bitmap.scaleX;
		}
		private function oncancleDayin(e:MouseEvent):void{
			Alert.getInstance().show("取消打印 ",this);
			picwall.preview.visible=false;
		}
		protected function onDayin(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Alert.getInstance().show("开始打印",this);
			picwall.preview.visible=false;
			var options:PrintJobOptions = new PrintJobOptions();
			options.printAsBitmap=true;
			var printOpt:PrintUIOptions=new PrintUIOptions();
		
			if (myPrintJob.start2(printOpt,false)) {
				try { 
					myPrintJob.addPage(picwall.preview.bg, null, options); 
				} 
				catch(e:Error) { 
					// handle error
				} 
				myPrintJob.send();
			} 
		}
		
		protected function onCreate2P(event:MouseEvent):void
		{
			var url:String=picwallView.allFileList[currIndex].url;
			var temp:Array=url.split("/");
			var name:String=temp[temp.length-2]+"/"+temp[temp.length-1];
			trace("http://"+localIP+"/"+decodeURI(name));
			var p2View:Pic2View=new Pic2View("http://"+localIP+"/"+name);
			addChild(p2View);
			TweenLite.from(p2View,0.3,{alpha:0});
		}
		
		protected function closeThis(event:MouseEvent=null):void
		{
			// TODO Auto-generated method stub
			this.parent.removeChild(this);
		}
		protected function onRightbtn(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(picwallView.allFileList.length==1){
				Alert.getInstance().show("浏览完毕！",this);
				return ;
			}
			currIndex++;
			if(currIndex>picwallView.allFileList.length-1){
				currIndex=0;
			}
			bigPic.setSource(picwallView.allFileList[currIndex].url);
			
		}
		protected function closeBigbg(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			picwall.bg.visible=false;
			picwall.bigbg.visible=false;
			picwall.leftBtn.visible=false;
			picwall.rightBtn.visible=false;
			picwall.btn_send.visible=false;
			picwall.mc_send.visible=false;
			picwall.dayin.visible=false;
			picwall.closeBtn.visible=true;
			picwall.preview.visible=false;
		}
		protected function onleftBtn(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(picwallView.allFileList.length==1){
				Alert.getInstance().show("浏览完毕！",this);
				return ;
			}
			currIndex--;
			if(currIndex<0){
				currIndex=picwallView.allFileList.length-1;
			}
			bigPic.setSource(picwallView.allFileList[currIndex].url);
		}
		protected function showDetil(event:LiEvent):void
		{
			// TODO Auto-generated method stub
			this.setChildIndex(picwall,this.numChildren-1);
			var file:File=event.data.file;
			picwall.closeBtn.visible=false;
			picwall.bigbg.visible=true;
			picwall.bg.visible=true;
			picwall.leftBtn.visible=true;
			picwall.rightBtn.visible=true;
			picwall.btn_send.visible=true;
			picwall.mc_send.visible=true;
			picwall.dayin.visible=true;
			currIndex=picwallView.allFileList.indexOf(file);
			if(currIndex==-1){
				Alert.getInstance().show("找不到图片="+file.url,this,false);
				return;
			}
			bigPic.setSource(picwallView.allFileList[currIndex].url);
		}
		
		
		
	}
}