package core {
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	
	public class KeyboardManager extends Object {
		private static var instance:KeyboardManager;
		
		private var activeGroup:String;
		private var activeIndex:int;
		private var groups:Array;
		private var stage:Stage;
		
		public function KeyboardManager(stage:Stage) {
			instance = this;
			this.stage = stage;
			activeGroup = null;
			groups = new Array();
		}
		
		public static function getInstance():KeyboardManager {
			return instance;
		}
		
		public static function onKeyDownEvent(e:KeyboardEvent) {
			if (instance) {
				instance.keyDown(e);
			}
		}
		
		public function addObject(obj:InteractiveObject, group:String, tabIndex:uint = 0) {
			if (!groups[group])
				groups[group] = new Array();
			groups[group][tabIndex] = obj;
		}
		
		public function setActiveGroup(group:String) {
			activeGroup = group;
			if (activeGroup != null && groups[activeGroup] && groups[activeGroup][0]) {
				stage.focus = groups[activeGroup][0];
				activeIndex = 0;
			}
		}
		
		public function keyDown(e:KeyboardEvent) {
			if (activeGroup != null) {
				if (e.keyCode == Keyboard.UP) {
					activeIndex--;
					if (activeIndex < 0)
						activeIndex = groups[activeGroup].length-1;
					stage.focus = groups[activeGroup][activeIndex];
				} else if (e.keyCode == Keyboard.DOWN /*|| e.keyCode == Keyboard.TAB*/) {
					activeIndex++;
					if (activeIndex >= groups[activeGroup].length)
						activeIndex = 0;
					stage.focus = groups[activeGroup][activeIndex];
				} else if (e.keyCode == Keyboard.LEFT) {
					if (activeGroup == "regular_levels") {
						activeIndex -= 10;
						if (activeIndex < 0)
							activeIndex = groups[activeGroup].length + activeIndex;
						stage.focus = groups[activeGroup][activeIndex];
					}
				} else if (e.keyCode == Keyboard.RIGHT) {
					if (activeGroup == "regular_levels") {
						activeIndex += 10;
						if (activeIndex >= groups[activeGroup].length)
							activeIndex = activeIndex - groups[activeGroup].length;
						stage.focus = groups[activeGroup][activeIndex];
					}
				}
			}
		}
	}
}