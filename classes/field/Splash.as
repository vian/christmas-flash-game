package field {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Splash extends Sprite {
		private static const N_SPLASH:uint = 60;
		
		private var children:Array;
		private var splashTime:uint;
		
		public function Splash(_x:Number, _y:Number) {
			x = _x;
			y = _y;
			splashTime = 0;
			children = new Array(N_SPLASH);
			
			for (var i:uint = 0; i < N_SPLASH; i++) {
				var child:SplashFlake = new SplashFlake();
				
				child.x = 16;
				child.y = 0;
				child.spdX = i - N_SPLASH/2;
				child.spdY = 12 - Math.abs(i - N_SPLASH/2)/4 - uint(Math.random()*4);
				child.phase = uint(Math.random()*10);
				
				children[i] = child;
				addChild(child);
			}
			
			addEventListener(Event.ENTER_FRAME, onFrameEvent);
		}
		
		private function onFrameEvent(e:Event) {
			for (var i:uint = 0; i < N_SPLASH; i++) {
				children[i].x += children[i].spdX/8;
				children[i].y -= children[i].spdY/4;
				children[i].spdY -= 4;
			}
			
			splashTime++;
			if (splashTime > 6 && parent)
				parent.removeChild(this);
		}
	}
}