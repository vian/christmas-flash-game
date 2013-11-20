package core {
	import flash.text.TextField;
	import flash.display.MovieClip; 
	import flash.events.Event;
	import core.LevelEditor;

	dynamic public class Preloader2 extends MovieClip { 
		public function Preloader2() {
			addEventListener(Event.ENTER_FRAME, update); 
		} 

		public function update(e:Event):void { 
			var bytesLoaded:Number = stage.loaderInfo.bytesLoaded;
			var bytesTotal:Number = stage.loaderInfo.bytesTotal;
			var percent:Number = 0;
			if (bytesTotal>0){
				percent = Math.floor(bytesLoaded/bytesTotal*100);
			}
			this.percentText.text = percent.toString() + "%";
			if (bytesLoaded==bytesTotal || bytesTotal==0){
				removeEventListener(Event.ENTER_FRAME, update);
				LevelEditor.getInstance().play();
			}
		} 
	}
}