package handlers;

@:publicFields class AudioHandler {
    static var Music(get, null):FlxSound;
    @:noCompletion inline static function get_Music() return FlxG.sound.music;

    static var Sound(get, null):flixel.system.frontEnds.SoundFrontEnd;
    @:noCompletion inline static function get_Sound() return FlxG.sound;
}