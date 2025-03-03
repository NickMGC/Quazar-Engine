package;

import openfl.display.DisplayObject as Obj;

class Main extends FlxGame {
	public function new() {
		super(1280, 720, Init, 60, 60, true, false);
	}

	#if !debug
	override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<Obj>, interactiveOnly:Bool, hitObject:Obj) {
		return false;
	}

    override function __hitTestHitArea(x:Float, y:Float, shapeFlag:Bool, stack:Array<Obj>, interactiveOnly:Bool, hitObject:Obj) {
		return false;
	}

    override function __hitTestMask(x:Float, y:Float) {
		return false;
	}
	#end
}