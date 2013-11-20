package field {
	import flash.display.Sprite;
	
	class SplashFlake extends Sprite {
		public var spdX:Number;
		public var spdY:Number;
		public var phase:uint;
		
		public function SplashFlake() {
			graphics.lineStyle(3,0xffffff); 
			graphics.moveTo(0,0); 
			graphics.lineTo(0.2,0.2);
			
			cacheAsBitmap = true;
		}
	}
}