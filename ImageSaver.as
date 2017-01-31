package utilities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.filesystem.*;
	import flash.utils.ByteArray;
	import nid.image.encoder.JPEGEncoder;
	import flash.events.*;
	import flash.display.StageQuality;
	/**
	 * ...
	 * @author Darius Portilla
	 */
	public class ImageSaver 
	{
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public function ImageSaver() 
		{
			
		}
		
				//************ SAVE FUNCTIONS *****************//
		public static function SaveImage(mc:MovieClip, path:String):void {
			
		
			var bitmapdata:BitmapData = new BitmapData(mc.width, mc.height+5, false, 0xffffff);
		//	bitmapdata.draw(mc,null, null, null,null, true);
			bitmapdata.drawWithQuality(mc, null, null, null, null, true, StageQuality.BEST);
			var jpgEncoder:JPEGEncoder = new JPEGEncoder()
			var imgByteArray:ByteArray = jpgEncoder.encode(bitmapdata, 72);
		
			
			
			
			var docs:File = File.applicationStorageDirectory.resolvePath("WN_db");
			var imageFolder:File =docs.resolvePath("images/folder_" + GlobalVarContainer.USER.ID);
			imageFolder.createDirectory();
			var img2Save:File = imageFolder.resolvePath(path);
			
			
			
			var fs:FileStream = new FileStream();

			try{

			 //open file in write mode

			 fs.openAsync(img2Save,FileMode.WRITE);
			 fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onSaveProgress);
			 fs.addEventListener(Event.CLOSE, onSaveComplete);
			 //write bytes from the byte array
			
			 fs.writeBytes(imgByteArray);

			 //close the file

			 fs.close();

			}catch(e:Error){

			 trace(e.message);

			}
		}
		
		private static function onSaveProgress(e:OutputProgressEvent):void 
		{
			//trace(e.bytesPending + " : " + e.bytesTotal);
		}
		
		private static function onSaveComplete(e:Event):void 
		{			
			dispatcher.dispatchEvent(new WN_Event(WN_Event.SAVE_COMPLETE)); 						
		}
		
		//Static Class Event Utilities
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		public static function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		public static function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
	}

}