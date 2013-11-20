package options {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.SimpleButton;
	
	public class IngameMenu extends MovieClip {
		public function IngameMenu(p_stage:Stage) {
			this.x = (p_stage.width - this.width)/2;
			this.y = (p_stage.height - this.height)/2;
		}
	}
}