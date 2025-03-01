package;

import lime.app.Application;

import openfl.events.UncaughtErrorEvent;
import openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR as ERROR;
import openfl.Lib;

import haxe.CallStack;

#if (allow_video && hxvlc)
import hxvlc.util.Handle.initAsync;
#end

class Init extends FlxState {
	public static var fpsCounter:FPS;

	override function create():Void {
		@:privateAccess FlxG.save.bind('QuazarEngine', '${FlxG.stage.application.meta.get('company')}/${FlxSave.validate(FlxG.stage.application.meta.get('file'))}');

		@:functionCode("#include <windows.h>\nsetProcessDPIAware()")

		Lib.current.stage.align = 'tl';
		Lib.current.stage.scaleMode = NO_SCALE;

		Lib.current.stage.application.window.onClose.add(Settings.save);
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(ERROR, onError);

		FlxG.game.addChild(fpsCounter = new FPS());

		Controls.init();
		Settings.load();

		FlxG.fixedTimestep = false;
		FlxG.mouse.useSystemCursor = true;

		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		if (FlxG.save.data?.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;

		FlxObject.defaultMoves = false;
		FlxSprite.defaultAntialiasing = Data.antialiasing;

		#if (allow_video && hxvlc) initAsync(checkStatus); #end

		switchState(TitleMenu.new);

		super.create();
	}

	function checkStatus(enabled:Bool):Void {
		trace('Async video loading is currently ${enabled ? 'on' : 'off'}.');
	}

	function onError(e:UncaughtErrorEvent):Void {
		var errorMessage:String = '';

		for (item in CallStack.exceptionStack(true)) {
			switch item {
				case FilePos(s, file, line, column): errorMessage += '$file: $line\n';
				default: Sys.println(item);
			}
		}

		Application.current.window.alert(errorMessage += '\n${e.error}', "Error");
		trace(errorMessage += '\n${e.error}');

		Sys.exit(1);
	}
}