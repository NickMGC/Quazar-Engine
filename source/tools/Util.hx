package tools;

inline function bound(value:Float, min:Float, max:Float):Float {
	return Math.max(min, Math.min(max, value));
}

inline function boundInt(value:Float, min:Float, max:Float):Int {
	return Std.int(bound(value, min, max));
}

inline function lerp(a:Float, b:Float, ratio:Float):Float {
	return b + (a - b) * Math.exp(-FlxG.elapsed * ratio);
}

inline function lerpColor(Color1:FlxColor, Color2:FlxColor, Factor:Float = 0.5):FlxColor {
	return FlxColor.interpolate(Color1, Color2, Factor);
}

inline function capitalize(text:String):String {
	return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
}