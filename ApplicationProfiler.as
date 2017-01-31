package  
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer; 
	/**
	 * ...
	 * @author Darius Portilla
	 */
	public class ApplicationProfiler extends MovieClip
	{
		private var startTime:Number; //Use to calculate relative time  
		private	var framesNumber:Number = 0; //Current number of fps  
		private	var fps:TextField =  new TextField(); //A TextField to display the actual fps  
		private var tms:TextField = new TextField();
		public function ApplicationProfiler(has_bg:Boolean = true, w:Number=80, h:Number=40 ) 
		{
			if(has_bg) {
				var mc:MovieClip = CreateBack(w, h);
			}
			addChild(mc);
			fpsCounter()
		}
		
		private function fpsCounter():void
		{
			startTime = getTimer(); //Gets the time in milliseconds since the movie started
			addChild(fps); // Adds the TextField to the stage
			addChild(tms); // Adds the TextField to the stage
			fps.autoSize = "left";
			tms.autoSize = "left";
			tms.y = 20;
			addEventListener(Event.ENTER_FRAME, checkFPS); //Adds an EnterFrame listener and executes the checkFPS function
		}
		
		private function checkFPS(e:Event):void
		{
			var currentTime:Number = (getTimer() - startTime) / 1000; //Gets the time in seconds since the function is executed
			framesNumber++; //Ads one to the frame counter
			
			if (currentTime > 1) //If the time in seconds is greater than 1			
			{
				fps.htmlText = "<font color='#FFFFFF'>FPS: " + (Math.floor((framesNumber/currentTime)*10.0)/10.0)+"</font>"; //Calculates the frame rate and displays it in the textfield
				tms.htmlText="<font color='#E3CB5A'>Mem: "+(System.totalMemory/1024)+"</font>";
				startTime = getTimer(); //Reset the start time
				framesNumber = 0; //Reset the number of frames
			}
			
		}
		
		public function CreateBack(w:Number, h:Number):MovieClip {
							
			var rect:MovieClip = new MovieClip();
			
			var gr:Graphics = rect.graphics;
			gr.beginFill(0x000000, 1);
			gr.drawRect(0, 0, w, h);
			gr.endFill();
			return rect;
		}
	
	}
}