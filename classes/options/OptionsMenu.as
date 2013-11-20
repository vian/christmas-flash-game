package options {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	
	public class OptionsMenu extends MovieClip {
		public function OptionsMenu(p_stage:Stage) {
			this.x = (p_stage.width - this.width)/2;
			this.y = (p_stage.height - this.height)/2;
			
			musicVol.init(p_stage);
			effectsVol.init(p_stage);
		}
	}
}