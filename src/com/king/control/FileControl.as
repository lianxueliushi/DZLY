package com.king.control
{
	import flash.filesystem.File;

	public class FileControl
	{
		public function FileControl()
		{
		}
		/**
		 *获取文件的子文件集 
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getDirectorys($url:String):Array{
			if($url.length>0){
				var file:File=File.applicationDirectory.resolvePath(decodeURI($url));
				if(file.exists && file.isDirectory){
					return file.getDirectoryListing();
				}else return null;
			}else return null;
			
		}
		/**
		 *通过文件来获取文件的文件名 （不带后缀的文件名）
		 * @param $file
		 * @return 
		 * 
		 */		
		public static function getFileName($file:File):String{
			var extension:String=$file.extension;
			var str:String=$file.name;
			return str.substring(0,str.search(extension)-1);
		}
		/**
		 *通过文件的路径来获取文件的文件名 
		 * @param $url 文件路径
		 * @return 文件名称
		 * 
		 */		
		public static function getUrlName($url:String):String{
			var url:String=$url;
			var n:uint=$url.lastIndexOf(".");
			var m:uint=$url.lastIndexOf("/");
			if(n!=-1){
				url=$url.substring(m+1,n);
			}
			else{
				url=$url.substring(m+1,$url.length);
			}
			return $url;
		}
		/**
		 * 
		 * @param $str 文件地址或文件名
		 * @return 文件后缀名 例如：txt jpg png
		 * 
		 */		
		public static function getsuffix($str:String):String{
			var suf:String="";
			if($str){
				var index:int=$str.lastIndexOf(".");
				if(index!=-1){
					suf=$str.substring(index+1);
				}
			}
			return suf.toLowerCase();
		}
		/**
		 *获取当前路径下的子文件夹 
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getFileDirs($url:String):Array{
			var files:Array=FileControl.getDirectorys($url);
			var lists:Array=[];
			if(files && files.length>0){
				for each (var file:File in files) 
				{
					if(file.isDirectory){
						lists.push(file);
					}
				}
				return lists;
			}
			else return null;
		}
		/**
		 *返回图片格式文件 
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getImgFileDirs($url:String):Array{
			var files:Array=FileControl.getDirectorys($url);
			var lists:Array=[];
			if(files && files.length>0){
				for each (var file:File in files) 
				{
					if(!file.isDirectory){
						var ex:String=file.extension.toLowerCase();
						if(ex=="jpg" || ex=="jpeg" ||ex=="png"||ex=="gif" || ex=="bmp"){
							lists.push(file);
						}
						
					}
				}
				return lists;
			}
			else return null;
		}
		/**
		 * 返回视频格式文件
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getVideoFileDirs($url:String):Array{
			var files:Array=FileControl.getDirectorys($url);
			var lists:Array=[];
			if(files && files.length>0){
				for each (var file:File in files) 
				{
					if(!file.isDirectory){
						var ex:String=file.extension.toLowerCase();
						if(ex=="flv" || ex=="mp4"){
							lists.push(file);
						}
					}
				}
				return lists;
			}
			else return null;
		}
		/**
		 *返回图片和视频格式文件  
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getMediaFileDirs($url:String):Array{
			var files:Array=FileControl.getDirectorys($url);
			var lists:Array=[];
			if(files && files.length>0){
				for each (var file:File in files) 
				{
					if(!file.isDirectory){
						var ex:String=file.extension.toLowerCase();
						if(ex=="flv" || ex=="mp4" || ex=="jpg" || ex=="jpeg" ||ex=="png"||ex=="gif" || ex=="bmp"){
							lists.push(file);
						}
					}
				}
				return lists;
			}
			else return null;
		}
		/**
		 * 返回txt格式文件 
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getTxtFileDirs($url:String):Array{
			var files:Array=FileControl.getDirectorys($url);
			var lists:Array=[];
			if(files && files.length>0){
				for each (var file:File in files) 
				{
					if(!file.isDirectory){
						var ex:String=file.extension.toLowerCase();
						if(ex=="txt"){
							lists.push(file);
						}
					}
				}
				return lists;
			}
			else return null;
		}
		/**
		 *返回 mp3格式文件 
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getAudioFileDirs($url:String):Array{
			var files:Array=FileControl.getDirectorys($url);
			var lists:Array=[];
			if(files && files.length>0){
				for each (var file:File in files) 
				{
					if(!file.isDirectory){
						var ex:String=file.extension.toLowerCase();
						if(ex=="mp3"){
							lists.push(file);
						}
					}
				}
				return lists;
			}
			else return null;
		}
	}
}