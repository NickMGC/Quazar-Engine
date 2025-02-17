package;

import flixel.util.FlxStringUtil.formatBytes;

import openfl.system.System.totalMemoryNumber;

import openfl.text.TextField;
import openfl.text.TextFormat;

import openfl.utils.Assets;

class FPS extends TextField {
	@:noCompletion var deltaTimeout:Float = 0;

	public function new() {
		super();

		defaultTextFormat = new TextFormat(Assets.getFont(Path.font('fredoka.ttf')).fontName, 15, 0xFFFFFF);

		x = y = 10;

		selectable = mouseEnabled = false;
		multiline = true;
		autoSize = LEFT;
	}

	override function __enterFrame(deltaTime:Float) {
		if (deltaTimeout < 100) {
			deltaTimeout += deltaTime;
			return;
		}

		text = 'FPS: ${FlxG.drawFramerate}\nGC Memory: ${formatBytes(totalMemoryNumber)}';

		deltaTimeout = 0;
	}
}