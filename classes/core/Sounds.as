package core {
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	
	public class Sounds extends Object {
		private static var instance:Sounds;
		
		private var snd:Array;
		private var so:SharedObject;
		
		public function Sounds() {
			instance = this;
			
			so = SharedObject.getLocal("christmas_tale", "/");
			if (so.data.soundEnabled == undefined) {
				so.data.soundEnabled = true;
				so.flush();
			}
			
			snd = new Array();
			snd["bounce"] = new BounceSound();
			snd["complete"] = new CompleteSound();
			snd["drop"] = new DropSound();
			snd["get"] = new GetSound();
			snd["hole"] = new HoleSound();
			snd["move"] = new MoveSound();
			snd["push"] = new PushSound();
			snd["splash"] = new SplashSound();
			snd["teleport"] = new TeleportSound();
		}
		
		public static function getInstance():Sounds {
			if (!instance)
				instance = new Sounds();
			return instance;
		}
		
		public function playSound(soundName:String):void {
			/*if (so.data.effectsVolume == undefined) {
				so.data.effectsVolume = 1;
				so.flush();
			}*/
			
			if (snd[soundName] != null && so.data.soundEnabled)
				snd[soundName].play(0, 0/*, new SoundTransform(so.data.effectsVolume)*/);
		}
	}
}