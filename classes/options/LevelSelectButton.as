package options {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.FocusEvent;
	
	dynamic public class LevelSelectButton extends Sprite {
		private var isCleared:Boolean;
		private var bLabel:String;
		private var txt:TextField;
		private var btn:SimpleButton;
		
		public function LevelSelectButton(buttonLabel:String, isCleared:Boolean) {						
			btn = new SimpleButton();

			var upg:LSUpG = new LSUpG();
			var overg:LSOverG = new LSOverG();
			var downg:LSDownG = new LSDownG();
			var upr:LSUpR = new LSUpR();
			var overr:LSOverR = new LSOverR();
			var downr:LSDownR = new LSDownR();
			
			if (isCleared) {
				btn.upState = upg;
				btn.overState = overg;
				btn.downState = downg;
				btn.hitTestState = new LSHittestG();
			}
			else {
				btn.upState = upr;
				btn.overState = overr;
				btn.downState = downr;
				btn.hitTestState = new LSHittestR();
			}
			
			addChild(btn);
			
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.CENTER;
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Arial";
			tf.color = 0x000000;
			tf.size = 14;
			
			txt.defaultTextFormat = tf;
			txt.text = buttonLabel;
			txt.selectable = false;
			txt.mouseEnabled = false;
			addChild(txt);
			
			this.bLabel = buttonLabel;
			this.isCleared = isCleared;
			
			addEventListener(FocusEvent.FOCUS_IN, onReceiveFocus);
		}
		
		private function onReceiveFocus(e:FocusEvent):void {
			stage.focus = btn;
		}
		
		public function get label():String {
			return this.bLabel;
		}
	}
}