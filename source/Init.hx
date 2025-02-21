package;

import openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR as ERROR;

import haxe.CallStack;

class Init extends flixel.FlxState {
	public static var fpsCounter:FPS;

	override function create() {
		@:privateAccess FlxG.save.bind('QuazarEngine', '${FlxG.stage.application.meta.get('company')}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}');

		@:functionCode("#include <windows.h>\nsetProcessDPIAware()")

		openfl.Lib.current.stage.align = 'tl';
		openfl.Lib.current.stage.scaleMode = NO_SCALE;

		openfl.Lib.current.stage.application.window.onClose.add(Settings.save);
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(ERROR, onError);

		FlxG.game.addChild(fpsCounter = new FPS());

		Controls.init();
		Settings.load();

		FlxG.plugins.addPlugin(new Conductor());

		FlxG.fixedTimestep = false;
		FlxG.mouse.useSystemCursor = true;

		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		if (FlxG.save.data?.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;

		FlxObject.defaultMoves = false;
		FlxSprite.defaultAntialiasing = Data.antialiasing;

		#if (allow_video && hxvlc) hxvlc.util.Handle.initAsync(isInit); #end

		switchState(menus.TitleMenu.new);

		super.create();
	}

	function isInit(s:Bool) {
		trace('We got ${s ? '' : 'no '}async video loading');
	}

	function onError(e:openfl.events.UncaughtErrorEvent) {
		var errMsg:String = '';

		for (item in CallStack.exceptionStack(true)) {
			switch item {
				case FilePos(s, file, line, column): errMsg += '$file: $line\n';
				default: Sys.println(item);
			}
		}

		lime.app.Application.current.window.alert(errMsg += '\n${e.error}', "Error");
		trace(errMsg += '\n${e.error}');
		Sys.exit(1);
	}
}