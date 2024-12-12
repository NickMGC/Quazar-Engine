package;

import openfl.events.UncaughtErrorEvent;

import haxe.CallStack;

class Init extends flixel.FlxState {
	public static var fpsCounter:FPS;

	override function create() {
		@:privateAccess FlxG.save.bind('QuazarEngine', '${FlxG.stage.application.meta.get('company')}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}');

		@:functionCode("
			#include <windows.h>
			setProcessDPIAware()
		")

		openfl.Lib.current.stage.align = "tl";
		openfl.Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;

		openfl.Lib.current.stage.application.window.onClose.add(Settings.save);
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, e -> {
			var errMsg = '';

			for (item in CallStack.exceptionStack(true)) {
				switch (item) {
					case FilePos(s, file, line, column): errMsg += '$file: $line\n';
					default: Sys.println(item);
				}
			}
	
			lime.app.Application.current.window.alert(errMsg += '\n${e.error}', "Error");
			Sys.exit(1);
		});

		Controls.init();
		Settings.load();

		FlxG.plugins.addPlugin(new Conductor());

		FlxG.fixedTimestep = false;
		FlxG.mouse.useSystemCursor = true;

		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		if (FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;

		FlxObject.defaultMoves = false;
		FlxSprite.defaultAntialiasing = Data.antialiasing;

		#if (allow_video && hxvlc) hxvlc.util.Handle.initAsync((s) -> trace('We got ${s ? '' : 'no '}async video loading')); #end

		FlxG.game.addChild(fpsCounter = new FPS());

		MenuState.switchState(new states.TitleState());

		super.create();
	}
}