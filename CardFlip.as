package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	/*
	fLen constant is responsible for distortion for perspective: larger
	constants will result in less distortion, smaller in more distortion.
	Constants less than picWidth, will give undesirable effects.
	*/


	/*
	We imported to the Library two 166 by 240 pixels jpeg images, Frist.jpg and Second.jpg.
	They are cataloged in the Library as bitmaps named "First" and "Second".
	We linked them to AS3 via the Linakge item in the Library menu.

	You can replace those images by your own images with different names, say YourImg1, YourImg2,
	and different dimensions. Both images, YourImg1 and YourImg2,
	have to have to be of the same size, though, as they serve as the front
	and the back of the flipping card. After, you import
	new images, you have to link them to AS3 through Linkage
	in the Library menu. Flash will create the corresponding BitmapData
	subclasses with the names YourImg1 and YourImg2.

	You have to change the values of picWidth and picHeight variables below
	to reflect the width and the height of your images.
	*/

	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class CardFlip extends Sprite
	{
		
		private	var fLen:Number=400;
		private var picWidth:Number=160
		private var picHeight:Number=196;
		private var isMoving:Boolean=false;
		private var spCard:Sprite = new Sprite();
		private var numSlices:Number;
		private var sliceWidth:Number=1;
		private var firstSlices:Array=[]; 
		private var secondSlices:Array = [];
		private var curTheta:Number = 0;
		private var spSide0:Sprite=new Sprite();
		private var spSide1:Sprite = new Sprite();
		private var bdFirst:BitmapData;
		private var bdSecond:BitmapData;
		
		//** Bitmap loader variables**//
		private var imageLoader:Loader;
		private var image1:String;
		private var image2:String;
		private var loadCnt:Number = 0;
		public var Perc:Number;
		public var AbortCnt:Number=0;
		private var abortID:uint;
		private var imagePath:String;
		public var ident:String;
		//public var isType:String = "card";
		
		public function CardFlip(c1:String, c2:String, i:String)
		{
			this.buttonMode = true;
			image1 = c1;
			image2 = c2;
			ident = i;
			
			loadImage(image1)
			
			
		}
		
		public function loadImage(img:String):void
		{
		
			imageLoader= new Loader();
			 var request:URLRequest= new URLRequest(img);
			imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress, false, 0, true);
			
			if(loadCnt<1){
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSide1Complete, false, 0, true);
			}else {
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSide2Complete, false, 0, true);
			}
			imageLoader.load(request);
			
			abortID = setTimeout(abortLoader, 6000);

				// abort the abort when loaded


		}
		
		private function SetUpCard():void {
			this.addChild(spCard);

			//You may want to position your card differently within your movie
			//by changing the next two lines.

		//	spCard.x=picWidth/2;

		//	spCard.y=picHeight/2;


			spCard.addChild(spSide0);

			spCard.addChild(spSide1);



			numSlices =picWidth/sliceWidth;
			
		

			cutSlices();
			
			renderView(curTheta);
			
			
			this.addEventListener(Event.ENTER_FRAME, onEnter);
			
			
			spSide0.addEventListener(MouseEvent.CLICK,sideClicked);

			spSide1.addEventListener(MouseEvent.CLICK,sideClicked);
		}
		
		public function cutSlices():void {
			
			var i:int;
			
			for(i=0;i<numSlices-1;i++){
				
				firstSlices[i]=new Bitmap(new BitmapData(sliceWidth+1,picHeight));
				
				firstSlices[i].bitmapData.copyPixels(bdFirst,new Rectangle(i*sliceWidth,0,sliceWidth+1,picHeight),new Point(0,0));
				
				secondSlices[i]=new Bitmap(new BitmapData(sliceWidth+1,picHeight));
				
				secondSlices[i].bitmapData.copyPixels(bdSecond,new Rectangle(i*sliceWidth,0,sliceWidth+1,picHeight),new Point(0,0));
				
				spSide0.addChild(firstSlices[i]);
				
				spSide1.addChild(secondSlices[i]);
			}
			
			firstSlices[numSlices-1]=new Bitmap(new BitmapData(sliceWidth,picHeight));
				
			firstSlices[numSlices-1].bitmapData.copyPixels(bdFirst,new Rectangle((numSlices-1)*sliceWidth,0,sliceWidth,picHeight),new Point(0,0));
				
			secondSlices[numSlices-1]=new Bitmap(new BitmapData(sliceWidth,picHeight));
				
			secondSlices[numSlices-1].bitmapData.copyPixels(bdSecond,new Rectangle((numSlices-1)*sliceWidth,0,sliceWidth,picHeight),new Point(0,0));
				
			spSide0.addChild(firstSlices[numSlices-1]);
				
			spSide1.addChild(secondSlices[numSlices-1]);
		}



		private	function renderView(t:Number):void {

				var j:int;

				var curv0:Array=[];
				
				var curv1:Array=[];
				
				var curv2:Array=[];
				
				var curv3:Array=[];
				
				var curNormal:Number;
				
				var factor1:Number;
				
				var factor2:Number;
				
				var curTransMatrix:Matrix;
				
				t=t*Math.PI/180;
				
				curNormal=Math.cos(t);
				
				if(curNormal>=0){
					
					for(j=0;j<numSlices;j++){
						
						firstSlices[j].visible=true;
						
						secondSlices[j].visible=false;
						
					}
				
				} else {
					
					for(j=0;j<numSlices;j++){
						
						firstSlices[j].visible=false;
						
						secondSlices[j].visible=true;
						
					}
				}
				
				for(j=0;j<numSlices;j++){
					
						factor1=fLen/(fLen-Math.sin(t)*(-picWidth/2+j*sliceWidth));
						
						factor2=fLen/(fLen-Math.sin(t)*(-picWidth/2+(j+1)*sliceWidth));
						
						curv0=[factor1*(-picWidth/2+j*sliceWidth)*Math.cos(t),-factor1*picHeight/2];
						
						curv1=[factor2*(-picWidth/2+(j+1)*sliceWidth)*Math.cos(t),-factor2*picHeight/2];
					
						curv2=[factor2*(-picWidth/2+(j+1)*sliceWidth)*Math.cos(t),factor2*picHeight/2];
					
						curv3=[factor1*(-picWidth/2+j*sliceWidth)*Math.cos(t),factor1*picHeight/2];
					
						curTransMatrix=calcMatrixForSides(curv0,curv1,curv2,curv3);
					
						firstSlices[j].transform.matrix=curTransMatrix;
						
				}
						
					for(j=0;j<numSlices;j++){
						
						factor1=fLen/(fLen-Math.sin(t)*(picWidth/2-j*sliceWidth));
						
						factor2=fLen/(fLen-Math.sin(t)*(picWidth/2-(j+1)*sliceWidth));
					
						curv0=[factor1*(picWidth/2-j*sliceWidth)*Math.cos(t),-factor1*picHeight/2];
						
						curv1=[factor2*(picWidth/2-(j+1)*sliceWidth)*Math.cos(t),-factor2*picHeight/2];
					
						curv2=[factor2*(picWidth/2-(j+1)*sliceWidth)*Math.cos(t),factor2*picHeight/2];
					
						curv3=[factor1*(picWidth/2-j*sliceWidth)*Math.cos(t),factor1*picHeight/2];
					
						curTransMatrix=calcMatrixForSides(curv0,curv1,curv2,curv3);
					
						secondSlices[j].transform.matrix=curTransMatrix;
				}
				
		}


		private	function calcMatrixForSides(v0:Array,v1:Array,v2:Array,v3:Array):Matrix {
				
				var curMatrix:Matrix;
				
				var transMatrix:Matrix;
				
				var v:Array=findVecMinusVec(v1,v0);
				
				var w:Array=findVecMinusVec(v3,v0);
				
				curMatrix=new Matrix(v[0]/sliceWidth,v[1]/sliceWidth,w[0]/picHeight,w[1]/picHeight);
				
				transMatrix=new Matrix(1,0,0,1,v0[0],v0[1]);
				
				curMatrix.concat(transMatrix);
				
				return curMatrix;
				
		}

		private	function findVecMinusVec(v:Array,w:Array):Array {
				
				return [v[0]-w[0],v[1]-w[1],v[2]-w[2]];
				
		}


		private	function sideClicked(e:MouseEvent):void {
				
				if(isMoving==false){
				
				isMoving=true;
				
				}
				
		}


		private function onEnter(e:Event): void {
				
				if(isMoving){
					
					curTheta+=36;
					
					curTheta=curTheta%360;
							
					renderView(curTheta);
					
					if((curTheta%180)==0){
						
						isMoving=false;
						
					}
							
					
				}
				
		}
		
		
		
		private	function abortLoader():void {
			AbortCnt++;
			try {
				imageLoader.close();
				if (AbortCnt < 4) {
					loadImage(imagePath);
					trace("Loader Aborted "+AbortCnt+"!!!");
				}else{				
					this.dispatchEvent(new LoadedImageEvent(LoadedImageEvent.LOADER_TIMEOUT));
					trace("Loader TIMED OUT!!!!");
				}
			}catch (error:Error) {
				trace("Loader cannot close");
				}
		}
		
		private function abortAbort():void{
			clearTimeout(abortID);
		}
		
		private function loadProgress(event:ProgressEvent):void {
			var percentLoaded:Number = Math.round(event.bytesLoaded/event.bytesTotal *100);
			Perc = percentLoaded;
			this.dispatchEvent(new LoadedImageEvent(LoadedImageEvent.SHOW_PROGRESS));
		}
		
		
		private function onSide1Complete(e:Event):void {
			abortAbort();
			bdFirst = e.target.content.bitmapData
					
			imageLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSide1Complete);
			
			loadCnt++;
			loadImage(image2)
			
		}
		
		private function onSide2Complete(e:Event):void {
			abortAbort();
			bdSecond = e.target.content.bitmapData
			
			
			this.dispatchEvent(new LoadedImageEvent(LoadedImageEvent.LOADED_IMAGE_COMPLETE));
			imageLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSide2Complete);
			
			SetUpCard();
		}
	
	}	
	
}