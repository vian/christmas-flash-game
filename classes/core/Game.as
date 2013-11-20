﻿package core {	import flash.display.SimpleButton;	import flash.display.MovieClip;	import field.GameField;	import flash.ui.Keyboard;	import flash.events.*;	import flash.net.*;	import options.LevelSelectButton;	import options.OptionsMenu;	import options.PressSpace;	import options.IngameMenu;	import flash.net.SharedObject;	import core.KeyboardManager;	import flash.text.TextField;		public class Game extends MovieClip {		private static var instance:Game;		private var dispatchKeyboard:Boolean;		private var curLevel:uint;		private var solData:Array;		private var solStep:uint;		private var keyPresses:Array;		private var numLevels:uint;		private var so:SharedObject;		private var solRecord:String;				public function Game() {			Game.instance = this;						numLevels = 30;			stage.tabChildren = false;			tabChildren = false;						so = SharedObject.getLocal("christmas_tale", "/");			if (so.data.clearedLevels == undefined)				so.data.clearedLevels = new Array();			if (so.data.numLevels == undefined || (so.data.numLevels != undefined && so.data.numLevels != numLevels)) {				for (var i:uint = 1; i <= numLevels; i++)					if (so.data.clearedLevels[i] == undefined)						so.data.clearedLevels[i] = false;			}			so.data.numLevels = numLevels;			so.flush();						keyPresses = new Array();			dispatchKeyboard = false;			new KeyboardManager(stage);			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyboardManager.onKeyDownEvent);			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);		}				public static function getInstance():Game {			if (!Game.instance)				Game.instance = new Game();			return Game.instance;		}				private function onLevelLoaded():void {			solRecord = "";			loading.visible = false;			solStep = 0;			//if (curLevel == 0)			//	levelCombo.prompt = customLevelName;			levelCombo.selectedIndex = curLevel-1;			pressSpace.visible = false;			dispatchKeyboard = true;			keyPresses.splice(0, keyPresses.length);			this.addEventListener(Event.ENTER_FRAME, onGameFrame);			field.activate();		}				private function keyDownHandler(event:KeyboardEvent):void {			if (dispatchKeyboard && 				(event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.UP ||				event.keyCode == Keyboard.SPACE)) {					var foundKeyCode:Boolean = false;					for (var i:uint = 0; i < keyPresses.length; i++) {						if (keyPresses[i] != null && keyPresses[i].keyCode == event.keyCode) {							foundKeyCode = true;							break;						}					}					if (!foundKeyCode)						keyPresses.push(event);					if (keyPresses.length == 1 && field.receiveInput()) {						field.keyDownHandler(keyPresses[0]);												if (keyPresses[0].keyCode == Keyboard.LEFT)							solRecord += "2 ";						else if (keyPresses[0].keyCode == Keyboard.RIGHT)							solRecord += "1 ";						else if (keyPresses[0].keyCode == Keyboard.UP)							solRecord += "3 ";						else if (keyPresses[0].keyCode == Keyboard.SPACE)							solRecord += "4 ";					}			} 						if (currentLabel == "game_screen") {				if (field.gameEnd && event.keyCode == Keyboard.SPACE) {					onPressSpaceClick(null);				}							if ((event.keyCode == Keyboard.ESCAPE/* || event.keyCode == Keyboard.DOWN*/) && !field.gameEnd) {					if (ingameMenu.visible)						onCloseIngameMenu(null)					else						onMenu(null);				}			}		}				private function keyUpHandler(event:KeyboardEvent):void {			for (var i:uint = 0; i < keyPresses.length; i++) {				if (keyPresses[i] != null && keyPresses[i].keyCode == event.keyCode) {					keyPresses.splice(i, 1);					break;				}			}		}				private function initLevelCombo():void {			levelCombo.addEventListener(Event.CHANGE, onLevelChange);			for (var i:uint = 1; i <= numLevels; i++)				levelCombo.addItem({index:i, label: "Level "+i.toString()});		}				private function onLevelChange(event:Event):void {			this.removeEventListener(Event.ENTER_FRAME, onSolutionFrame);			this.removeEventListener(Event.ENTER_FRAME, onGameFrame);						stage.focus = this;			KeyboardManager.getInstance().setActiveGroup(null);						curLevel = levelCombo.selectedItem.index;			dispatchKeyboard = false;			field.pause();			field.clearField();			loading.visible = true;			field.loadData("./levels/level"+curLevel.toString()+".txt", onLevelLoaded);		}				private function showSolution(event:MouseEvent):void {			stage.focus = this;			KeyboardManager.getInstance().setActiveGroup(null);			if (ingameMenu.visible)				ingameMenu.visible = false;							dispatchKeyboard = false;			field.pause();			field.clearField();			loading.visible = true;			field.loadData("./levels/level"+curLevel.toString()+".txt", loadSolution);		}				public function loadSolution() {			var loader:URLLoader = new URLLoader();						loader.addEventListener(Event.COMPLETE, onDataComplete);			loader.addEventListener(Event.OPEN, onDataOpen);			loader.addEventListener(ProgressEvent.PROGRESS, onDataProgress);			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDataSecurityError);			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onDataHttpStatus);			loader.addEventListener(IOErrorEvent.IO_ERROR, onDataIOError);						var request:URLRequest = new URLRequest("./solutions/sol"+curLevel.toString()+".txt");			try {				loader.load(request);			} catch (error:Error) {				trace("Unable to loadSolution with "+request.url);			}		}				private function onDataComplete(event:Event):void {			var loader:URLLoader = URLLoader(event.target);			trace("onDataComplete: " /*+ loader.data*/);						loading.visible = false;						pressSpace.visible = false;			solData = loader.data.split(/\s+/);			solStep = 0;			field.activate();			this.removeEventListener(Event.ENTER_FRAME, onGameFrame);			this.addEventListener(Event.ENTER_FRAME, onSolutionFrame);		}				private function onDataOpen(event:Event):void {			trace("onDataOpen");		}				private function onDataProgress(event:ProgressEvent):void {			trace("onDataProgress");		}				private function onDataSecurityError(event:SecurityErrorEvent):void {			trace("onDataSecurityError");		}				private function onDataHttpStatus(event:HTTPStatusEvent):void {			trace("onDataHttpStatus");		}				private function onDataIOError(event:IOErrorEvent):void {			trace("onDataIOError");		}				private function onGameFrame(event:Event):void {			if (keyPresses.length == 1 && field.receiveInput()) {				field.keyDownHandler(keyPresses[0]);								if (keyPresses[0].keyCode == Keyboard.LEFT)					solRecord += "2 ";				else if (keyPresses[0].keyCode == Keyboard.RIGHT)					solRecord += "1 ";				else if (keyPresses[0].keyCode == Keyboard.UP)					solRecord += "3 ";				else if (keyPresses[0].keyCode == Keyboard.SPACE)					solRecord += "4 ";			}						if (field.gameEnd) {				trace(solRecord);				// TODO: save solution solRecord for currentLevel								this.removeEventListener(Event.ENTER_FRAME, onGameFrame);				so.data.clearedLevels[curLevel] = true;				so.flush();				pressSpace.visible = true;			}		}				private function onSolutionFrame(event:Event):void {			if (field.receiveInput() && currentLabel == "game_screen") {				var e:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);								if (solStep != solData.length) {					if (uint(solData[solStep]) == 1)						e.keyCode = Keyboard.RIGHT;					else if (uint(solData[solStep]) == 2)						e.keyCode = Keyboard.LEFT;					else if (uint(solData[solStep]) == 3)						e.keyCode = Keyboard.UP;					else if (uint(solData[solStep]) == 4) {						e.keyCode = Keyboard.SPACE;						if (solStep != solData.length-1 && uint(solData[solStep+1]) == 4)							solStep++;					}									field.keyDownHandler(e);					solStep++;				}			}						if (field.gameEnd) {				this.removeEventListener(Event.ENTER_FRAME, onSolutionFrame);				pressSpace.visible = true;			}			}				private function onSelectLevel(event:MouseEvent):void {			KeyboardManager.getInstance().setActiveGroup(null);			stage.focus = this;						gotoAndPlay("game_screen");			curLevel = (event.currentTarget as LevelSelectButton).label.match(/\d+/)[0];			dispatchKeyboard = false;		}				private function registerStartScreenEvents():void {			levelSelect.tabChildren = false;			if (levelSelect.numChildren == 1) {				var i:uint;				var b:LevelSelectButton;								for (i = 1; i <= numLevels; i++) {					b = new LevelSelectButton("Level "+i.toString(), so.data.clearedLevels[i]);					b.alpha = 1;					KeyboardManager.getInstance().addObject(b, "regular_levels", i-1);					b.addEventListener(MouseEvent.CLICK, onSelectLevel);					b.x = 5+uint((i-1)/10)*160;					b.y = 5 + ((i-1)%10)*24;					levelSelect.addChild(b);				}				KeyboardManager.getInstance().setActiveGroup("regular_levels");			}		}				private function registerGameEvents():void {					loading.visible = true;						field.pause();			field.clearField();						field.loadData("./levels/level"+curLevel.toString()+".txt", onLevelLoaded);			levelCombo.tabEnabled = false;			menuButton.tabEnabled = false;			soundButton.tabEnabled = false;			initLevelCombo();			menuButton.addEventListener(MouseEvent.CLICK, onMenu);						soundButton.addEventListener(MouseEvent.CLICK, onToggleSound);			soundButton._enabled = so.data.soundEnabled;						KeyboardManager.getInstance().addObject(ingameMenu.mainMenuButton, "ingame_menu", 0);			KeyboardManager.getInstance().addObject(ingameMenu.showSolutionButton, "ingame_menu", 1);			KeyboardManager.getInstance().addObject(ingameMenu.closeButton, "ingame_menu", 2);						ingameMenu.tabChildren = false;						ingameMenu.mainMenuButton.addEventListener(MouseEvent.CLICK, onMainMenuClick);			ingameMenu.showSolutionButton.addEventListener(MouseEvent.CLICK, showSolution);			ingameMenu.closeButton.addEventListener(MouseEvent.CLICK, onCloseIngameMenu);						pressSpace.modalness.addEventListener(MouseEvent.CLICK, onPressSpaceClick);							field.visible = true;			ingameMenu.visible = false;			pressSpace.visible = false;		}				private function gameExit():void {			KeyboardManager.getInstance().setActiveGroup(null);			field.visible = false;			pressSpace.visible = false;			ingameMenu.visible = false;			dispatchKeyboard = false;			field.pause();			this.removeEventListener(Event.ENTER_FRAME, onSolutionFrame);			this.removeEventListener(Event.ENTER_FRAME, onGameFrame);		}				private function onMainMenuClick(e:MouseEvent):void {			KeyboardManager.getInstance().setActiveGroup(null);			stage.focus = this;			gameExit();			gotoAndPlay("start_screen");		}				private function onCloseIngameMenu(e:MouseEvent):void {			KeyboardManager.getInstance().setActiveGroup(null);			stage.focus = this;			field.activate();			ingameMenu.visible = false;		}				private function onMenu(e:MouseEvent):void {			field.pause();			ingameMenu.visible = true;			KeyboardManager.getInstance().setActiveGroup("ingame_menu");		}				private function onPressSpaceClick(e:MouseEvent):void {			KeyboardManager.getInstance().setActiveGroup(null);			stage.focus = this;			pressSpace.visible = false;			if (curLevel > 0 && curLevel < numLevels || (curLevel == numLevels && solStep != 0)) {				dispatchKeyboard = false;				field.pause();				if (solStep == 0)	// not a solution					curLevel++;				field.clearField();				loading.visible = true;				field.loadData("./levels/level"+curLevel.toString()+".txt", onLevelLoaded);			} else {				gameExit();				gotoAndPlay("start_screen");			}		}				private function onToggleSound(e:MouseEvent) {			so.data.soundEnabled = soundButton._enabled;		}	}}