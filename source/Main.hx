package;

import openfl.display.DisplayObject;

class Main extends flixel.FlxGame {
	public function new() {
		final fps = Std.int(FlxG.stage.application.window.displayMode.refreshRate * 2);

		super(1280, 720, Init, fps, fps, true, false);
	}

	#if !debug
	@:noCompletion override function __hitTest       (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject) return false;
    @:noCompletion override function __hitTestHitArea(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject) return false;
    @:noCompletion override function __hitTestMask   (x:Float, y:Float) return false;
	#end
}