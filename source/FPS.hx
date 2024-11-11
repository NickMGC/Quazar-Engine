package;

import flixel.FlxG;

class FPS extends openfl.text.TextField {
	@:noCompletion private var times:Array<Float> = [];

	@:noCompletion final now = Sys.time() * 1000;
	@:noCompletion var deltaTimeout = .0;

	public function new() {
		super();

		x = y = 10;

		selectable = mouseEnabled = false;

		defaultTextFormat = new openfl.text.TextFormat(openfl.utils.Assets.getFont(Path.font('FallingSkyBlk.otf')).fontName, 14, 0xFFFFFF);

		multiline = true;
		autoSize = LEFT;

		visible = Data.showFPS;
	}

	override function __enterFrame(deltaTime:Float):Void {
			times.push(now);

			while (times[0] < now - 1000) times.shift();

			if (deltaTimeout < 100) {
				deltaTimeout += deltaTime;
				return;
			}

		text = 'FPS: ${times.length < FlxG.drawFramerate ? times.length : FlxG.drawFramerate}\nMemory: ${flixel.util.FlxStringUtil.formatBytes(cast(openfl.system.System.totalMemory, UInt))}';

		deltaTimeout = 0;
	}
}