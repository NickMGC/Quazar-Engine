package tools;

import flixel.system.frontEnds.SoundFrontEnd;
import flixel.sound.FlxSoundGroup;

//TODO: add all methods
class Sound {
    @:isVar public static var self(get, never):SoundFrontEnd;
    inline private static function get_self() return FlxG.sound;

    public static function play(path:String, volume:Float = 1, looped:Bool = false, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void -> Void) {
        FlxG.sound.play(Path.sound(path), volume, looped, group, autoDestroy, onComplete);
        return FlxG.sound;   
    }
}