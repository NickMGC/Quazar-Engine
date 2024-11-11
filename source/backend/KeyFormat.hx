package backend;

import flixel.input.keyboard.FlxKey;

@:publicFields class KeyFormat {
	static var keys:Map<FlxKey, String> = [
		ZERO => '0', ONE => '1', TWO => '2', THREE => '3', FOUR => '4', FIVE => '5', SIX => '6', SEVEN => '7', EIGHT => '8', NINE => '9',
		ESCAPE => 'Esc', CONTROL => 'Ctrl', CAPSLOCK => 'Caps', PRINTSCREEN => 'PrtScrn', PAGEUP => 'PgUp', PAGEDOWN => 'PgDown',
		PERIOD => '.', COMMA => ',', SEMICOLON => ';', GRAVEACCENT => '`', LBRACKET => '[', RBRACKET => ']', QUOTE => "'", NONE => '--'
	];

	static function display(key:FlxKey) {
		if (keys.exists(key)) return keys[key];
	
		var label = Std.string(key);
		if(label.toLowerCase() == 'null') return '--';

		var arr:Array<String> = label.split('_');
		for (i in 0...arr.length) arr[i] = Util.capitalize(arr[i]);
		return arr.join(' ');
	}
}