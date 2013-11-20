package options {
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class PressSpace extends MovieClip {
		public function PressSpace(p_stage:Stage) {
			this.x = (p_stage.width - this.width)/2;
			this.y = (p_stage.height - this.height)/2;
		}
	}
}