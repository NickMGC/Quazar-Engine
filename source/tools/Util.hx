package tools;

import flixel.util.FlxColor;

class Util {
    inline public static function bound(value:Float, min:Float, max:Float):Float return Math.max(min, Math.min(max, value));
    inline public static function boundInt(value:Float, min:Float, max:Float):Int return Std.int(Math.max(min, Math.min(max, value)));

    inline public static function lerp(a:Float, b:Float, ratio:Float) return b + (a - b) * Math.exp(-FlxG.elapsed * ratio);
    inline public static function lerpCool(a:Float, b:Float, ratio:Float, elapsed:Float) return b + (a - b) * Math.exp(-elapsed * ratio);

    inline public static function lerpColor(Color1:FlxColor, Color2:FlxColor, Factor:Float = 0.5) return FlxColor.interpolate(Color1, Color2, Math.exp(-FlxG.elapsed * Factor));

    inline public static function capitalize(text:String) return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
}