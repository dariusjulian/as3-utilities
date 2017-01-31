
/********************************************************
 * ******************************************************
 * @author Darius Portilla
 * @Date 10/29/2013 
 * @path com.sixfoot.utilities.XMLUtil.as
 * ******************************************************
 ********************************************************/

package utilities
{
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.events.Event;

	
	public class XMLUtil
	{
		public static var myXML:XML;
		private static var loader:URLLoader = new URLLoader();
		private static var dispatcher:EventDispatcher = new EventDispatcher();

		
		public static function LoadMXL(x:String):void {
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onLoadXML)
			loader.load(new URLRequest(x));

		}
		
		private static function onLoadXML(e:Event):void{
				
			try {
					//Convert the downloaded text into an XML
					XML.ignoreWhitespace = true; 
					myXML = new XML(e.target.data);
									
					dispatcher.dispatchEvent(new XMLUtilityEvent(XMLUtilityEvent.XML_LOADED));
					
				} catch (e:TypeError){
					//Could not convert the data, probavlu because
					//because is not formated correctly
					trace("Could not parse the XML")
					trace(e.message)
				}
					
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