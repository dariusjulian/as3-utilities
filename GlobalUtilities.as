package utilities 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.globalization.DateTimeFormatter;
	/**
	 * ...
	 * @author Darius Portilla
	 */
	public class GlobalUtilities 
	{
		 
		public static var lettersArray:Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
		public static var monthNamesArray:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		public static var monthAbbrevArray:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		
		public function GlobalUtilities() 
		{

		}
		
		public static function strReplace(str:String, search:String, replace:String):String {
			return str.split(search).join(replace);
		}
		
		public static function CheckYear(year_txt:TextField):Boolean
		{
			if (year_txt.length != 4) {
				return false;
			}else {
				return true;
			}
		}		
				
		public static function ChangeColor(mc:DisplayObject, color:uint, a:Number=1):void
		{
			var ct:ColorTransform = new ColorTransform();
			ct.color = color;
			mc.transform.colorTransform = ct;
			mc.alpha = a;
		}		
		
		public static function Validate(tf:TextField, s:String, min:Number=0):Boolean {
			if (tf.text == "" || tf.text == " " || tf.text.length < min) {			
				trace("Textfield: " + tf + " is not valid");
				return false;
			}else {
				return true;
				trace("Textfield: " + tf + " is valid");
			}
			
		}
		
		public static function RemoveWhiteSpaces(s:String):String {
			var rex:RegExp = /[\s\r\n]+/gim;
			s = s.replace(rex,'');
			return s;
		}
		
		public static function isValidEmail(email:String):Boolean {
			var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
			if (emailExpression.test(email)) {		
				trace( email + " is a valid email");
				return true;
			}else{
				trace(email+ " is not valid email");
				return false;
			}
		}
		
		public static function ConvertSQLDate(date:String):String { 
			var splitDate:Array = date.split("-");
			var newDate:String = splitDate[1] + "/" + splitDate[2] + "/" + splitDate[0];
			return newDate;			
		}
		
		public static function GetCurrentDate():Array { 			
			var today:Date = new Date();
			var mo:Number = today.getMonth()+1;
			var da:Number = today.getDate();
			var ye:Number = today.getFullYear();
		//	var d:String = mo+"-"+da+"-"+ye;
			var a:Array = [mo, da, ye];
			trace("Date: " +  mo+"/"+da+"/"+ye);
			return a;
			
		}			
		
		public static function Capitalize(str:String):String { 
			return str.replace(/(^[a-z]|\s[a-z])/g, function():String { return arguments[1].toUpperCase(); } ); 
		}
		
		
		public static function ParseMySQL(date:String):Date
		{
			var split:Array = date.split(" ");
			var splitDate:Array = split[0].split("-");
			var splitTime:Array = split[1].split(":");

			return new Date(splitDate[0],
							splitDate[1] - 1,
							splitDate[2]);
		}
		
		public static function CompareDates(date1 : Date, date2 : Date) : Number
		{
			var date1Timestamp : Number = date1.getTime();
			var date2Timestamp : Number = date2.getTime();
			var millisecondsPerDay:int = 24*60*60*1000; //86400000
			var diff:Number = date1Timestamp - date2Timestamp;
			var result : Number = 0;
			
			if (millisecondsPerDay <= diff) {
				result = 1;
			}			

			trace("Difference= " + result+ " /Mili: "+millisecondsPerDay+ " /Diff: "+diff);

			return result;
		}
		
		public static function getTimeDifference(startTime:Date, endTime:Date) : Number
		{
			if (startTime == null) { return -1; }
			if (endTime   == null) { return -1; }
			//trace(" endTime.valueOf() "+endTime.valueOf()+" startTime.valueOf() "+startTime.valueOf())
			var aTms:* = Math.floor(endTime.valueOf() - startTime.valueOf());
			var timeTaken:* =( int(aTms/(    60*60*1000)) %24 );
			//trace(timeTaken);
			return int(aTms / (24 * 60 * +60 * 1000));				
		}
			
		public static function GetAgeFromDateString(s:String):Number {
			trace("DOB: " + s);
			var a:Array = s.split("/");
			var dob:Date = new Date(a[2], a[0]-1, a[1]);
			var now:Date = new Date();  
			var yearsOld:Number = Number(now.fullYear) - Number(dob.fullYear);  
			if (dob.month > now.month || (dob.month == now.month && dob.date > now.date)) 
			{
			   yearsOld--;
			}
			return yearsOld;  
		}
		
		public static function GetFullDate(a:Array):String {
			var month:String = monthNamesArray[a[0] - 1];
			var day:String = String(a[1]);
			if (a[1] < 10)	day = "0" + String(a[1]);
			var year:String = String(a[2]);
			
			return month + " " + day + ", " + year;			
			
		}
		
		public static function FormatDate(s:String, FIRST:Boolean=false):String {
			var dateArray:Array = s.split("/");
			var n:Number = 0;
			if (FIRST) n = 1;
			var month:String = String(Number(dateArray[0]) + n);		
			if (Number(dateArray[0]) < 10) {
				month = "0" + month;
			}
			return month + "/" + dateArray[1] + "/" + dateArray[2];
		}
		
	}

}