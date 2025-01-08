package;

import flixel.util.FlxStringUtil.formatBytes as format;
import openfl.system.System.totalMemoryNumber as GCmem;

class FPS extends openfl.text.TextField {
	@:noCompletion var times:Array<Float> = [];

	@:noCompletion final now = Sys.time() * 1000;
	@:noCompletion var deltaTimeout = .0;

	public function new() {
		super();

		x = y = 10;

		selectable = mouseEnabled = false;

		defaultTextFormat = new openfl.text.TextFormat(openfl.utils.Assets.getFont(Path.font('fredoka.ttf')).fontName, 15, 0xFFFFFF);

		multiline = true;
		autoSize = LEFT;
	}

	override function __enterFrame(deltaTime:Float) {
		times.push(now);

		while (times[0] < now - 1000) times.shift();

		if (deltaTimeout < 100) {
			deltaTimeout += deltaTime;
			return;
		}

		text = 'FPS: ${times.length < FlxG.drawFramerate ? times.length : FlxG.drawFramerate}\nGC Memory: ${format(GCmem)}';

		deltaTimeout = 0;
	}
}