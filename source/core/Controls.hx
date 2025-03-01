package core;

import openfl.events.KeyboardEvent;

class Controls {
	@:noCompletion public static var callbacks:Map<String, Map<Int, Array<Void -> Void>>> = [
		'press' => [],
		'hold' => [],
		'release' => []
	];

	@:noCompletion public static var justPressedKeys:Map<Int, Bool> = [];

	/**
	 * Whether input is blocked or not.
	 */
	public static var block:Bool = true;

	public static function init():Void {
		FlxG.signals.preStateSwitch.add(reset); 

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
	}

	@:noCompletion static function onKeyPress(event:KeyboardEvent):Void {
		if (block) return;

		handleKeyPress(event.keyCode);
		handleKeyEvent(event.keyCode, 'hold');
	}

	@:noCompletion static function onKeyRelease(event:KeyboardEvent):Void {
		justPressedKeys[event.keyCode] = false;

		if (!block) {
			handleKeyEvent(event.keyCode, 'release');
		}
	}

	/**
	 * Checks if a key was pressed and triggers its associated callbacks.
	 */
	@:noCompletion static function handleKeyPress(keyCode:Int):Void {
		toggleFullscreen(keyCode);

		if (!callbacks['press'].exists(keyCode) || justPressedKeys[keyCode]) return;

		for (callback in callbacks['press'][keyCode]) {
			callback();
		}

		justPressedKeys[keyCode] = true;
	}

	/**
	 * Triggers callbacks for a specific key.
	 */
	@:noCompletion static function handleKeyEvent(keyCode:Int, eventType:String):Void {
		if (callbacks[eventType].exists(keyCode)) {
			for (callback in callbacks[eventType][keyCode]) {
				callback();
			}
		}
	}

	@:noCompletion private static function toggleFullscreen(keyCode:Int):Void {
		if (keyCode != 122) return;

		FlxG.fullscreen = !FlxG.fullscreen;

		if (FlxG.save.data != null) {
			FlxG.save.data.fullscreen = FlxG.fullscreen;
		}
	}

	/**
	 * Binds a callback to a specified key.
	 */
	@:noCompletion public static function bind(type:String, keys:Array<Int>, callback:Void -> Void):Void {
		for (key in keys) {
			if (!callbacks[type].exists(key)) {
				callbacks[type][key] = [];
			}

			callbacks[type][key].push(callback);
		}
	}

	static function reset():Void {
		for (type in ['press', 'hold', 'release']) {
			for (key in callbacks[type].keys()) {
				callbacks[type][key] = [];
			}
		}

		justPressedKeys.clear();
	}
}