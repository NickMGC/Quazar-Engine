package backend;

@:publicFields class Util {
    inline static function bound(value:Float, min:Float, max:Float):Float return Math.max(min, Math.min(max, value));

    inline static function capitalize(text:String) return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
}