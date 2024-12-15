package backend;

import flixel.input.keyboard.FlxKey;

@:publicFields @:structInit class Data {
	//Gameplay
	static var downScroll = false;
	static var middleScroll = false;
	static var ghostTapping = true;
	static var flashingLights = true;
	static var reset = true;
	static var safeFrames = 10.;

	//Controls
	static var keyBinds:Map<String, Array<Int>> = [
		'left_note' => [LEFT, A], 'down_note' => [DOWN, S], 'up_note' => [UP, W], 'right_note' => [RIGHT, D],
		'left' => [LEFT, A], 'down' => [DOWN, S], 'up' => [UP, W], 'right' => [RIGHT, D],
		'accept' => [ENTER, SPACE], 'back' => [BACKSPACE, ESCAPE], 'pause' => [ENTER, ESCAPE], 'reset' => [R, NONE]
	];

	//Delay
	static var offset = 0;

	//Graphics
	static var antialiasing = true;
	static var gpuRendering = true;
	static var shaders = true;
	static var showFPS = true;
}

@:publicFields class Settings {
	inline static function resetKeys()
		Data.keyBinds = [
			'left_note' => [LEFT, A], 'down_note' => [DOWN, S], 'up_note' => [UP, W], 'right_note' => [RIGHT, D],
			'left' => [LEFT, A], 'down' => [DOWN, S], 'up' => [UP, W], 'right' => [RIGHT, D],
			'accept' => [ENTER, SPACE], 'back' => [BACKSPACE, ESCAPE], 'pause' => [ENTER, ESCAPE], 'reset' => [R, NONE]
		];

	static function save() {
		for (key in Type.getClassFields(Data)) Reflect.setField(FlxG.save.data, key, Reflect.field(Data, key));
		FlxG.save.flush();

		trace('Settings saved');
	}

	static function load() {
		for (key in Type.getClassFields(Data)) if (Reflect.hasField(FlxG.save.data, key)) Reflect.setField(Data, key, Reflect.field(FlxG.save.data, key));

		if (Init.fpsCounter != null) Init.fpsCounter.visible = Data.showFPS;

		if (FlxG.save.data.volume != null) FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null) FlxG.sound.muted = FlxG.save.data.mute;

		trace('Settings loaded');
	}
}