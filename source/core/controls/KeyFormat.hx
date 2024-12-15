package core.controls;

import flixel.input.keyboard.FlxKey;

@:publicFields class KeyFormat {
	static var keys:Map<FlxKey, String> = [
		ZERO => '0', ONE => '1', TWO => '2', THREE => '3', FOUR => '4', FIVE => '5', SIX => '6', SEVEN => '7', EIGHT => '8', NINE => '9',
		ESCAPE => 'Esc', CONTROL => 'Ctrl', CAPSLOCK => 'Caps', PRINTSCREEN => 'PrtScrn', PAGEUP => 'PgUp', PAGEDOWN => 'PgDown',
		PERIOD => '.', COMMA => ',', SEMICOLON => ';', GRAVEACCENT => '`', LBRACKET => '[', RBRACKET => ']', QUOTE => "'", NONE => '--'
	];

	static function display(key:FlxKey):String return keys.exists(key) ? keys[key] : getKey(key.toString().toLowerCase());

	private static function getKey(key:String):String {
		return if (key == 'null') '--';
		else if (key.contains('_')) [for (split in key.split('_')) Util.capitalize(split)].join(' ');
		else Util.capitalize(key);
	}
}