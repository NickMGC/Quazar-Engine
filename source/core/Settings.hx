package core;

import flixel.input.keyboard.FlxKey;

@:structInit class Data {
	//Gameplay
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var flashingLights:Bool = true;
	public static var reset:Bool = true;
	public static var safeFrames:Float = 10;

	//Controls
	public static var keyBinds:Map<String, Array<Int>> = [
		'left_note' => [LEFT, A],
		'down_note' => [DOWN, S],
		'up_note' => [UP, W],
		'right_note' => [RIGHT, D],

		'left' => [LEFT, A],
		'down' => [DOWN, S],
		'up' => [UP, W],
		'right' => [RIGHT, D],

		'accept' => [ENTER, SPACE],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R, NONE]
	];

	//Delay
	public static var offset:Int = 0;

	//Graphics
	public static var framerate:Int = 60;
	public static var antialiasing:Bool = true;
	public static var gpuRendering:Bool = true;
	public static var shaders:Bool = true;
	public static var showFPS:Bool = true;
}

class Settings {
	inline public static function resetKeys():Void {
		Data.keyBinds = [
			'left_note' => [LEFT, A],
			'down_note' => [DOWN, S],
			'up_note' => [UP, W],
			'right_note' => [RIGHT, D],
	
			'left' => [LEFT, A],
			'down' => [DOWN, S],
			'up' => [UP, W],
			'right' => [RIGHT, D],
	
			'accept' => [ENTER, SPACE],
			'back' => [BACKSPACE, ESCAPE],
			'pause' => [ENTER, ESCAPE],
			'reset' => [R, NONE]
		];
	}

	public static function save():Void {
		for (key in Type.getClassFields(Data)) Reflect.setField(FlxG.save.data, key, Reflect.field(Data, key));
		FlxG.save.flush();

		if (FlxG.save.data.volume != null) FlxG.save.data.volume = FlxG.sound.volume;
		if (FlxG.save.data.mute != null) FlxG.save.data.mute = FlxG.sound.muted;

		trace('Settings saved');
	}

	public static function load():Void {
		for (key in Type.getClassFields(Data)) if (Reflect.hasField(FlxG.save.data, key)) Reflect.setField(Data, key, Reflect.field(FlxG.save.data, key));

		FlxSprite.defaultAntialiasing = Data.antialiasing;
		if (Init.fpsCounter != null) Init.fpsCounter.visible = Data.showFPS;

		if (FlxG.save.data.volume != null) FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null) FlxG.sound.muted = FlxG.save.data.mute;

		trace('Settings loaded');
	}
}