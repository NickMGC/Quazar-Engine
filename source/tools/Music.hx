package tools;

import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;

//Mental insanity
class Music {
    @:isVar public static var self(get, set):FlxSound;
    inline private static function get_self() return FlxG.sound.music;
    inline private static function set_self(sound:FlxSound):FlxSound return FlxG.sound.music = sound;


    @:isVar public static var x(get, set):Float;
    inline private static function get_x() return FlxG.sound.music.x;
    inline private static function set_x(x:Float):Float return FlxG.sound.music.x = x;


    @:isVar public static var y(get, set):Float;
    inline private static function get_y() return FlxG.sound.music.y;
    inline private static function set_y(y:Float):Float return FlxG.sound.music.y = y;


    @:isVar public static var persist(get, set):Bool;
    inline private static function get_persist() return FlxG.sound.music.persist;
    inline private static function set_persist(persist:Bool):Bool return FlxG.sound.music.persist = persist;

    public static var name(get, null):String;
    inline private static function get_name() return FlxG.sound.music.name;

    public static var artist(get, null):String;
    inline private static function get_artist() return FlxG.sound.music.artist;

    public static var amplitude(get, null):Float;
    inline private static function get_amplitude() return FlxG.sound.music.amplitude;

    public static var amplitudeLeft(get, null):Float;
    inline private static function get_amplitudeLeft() return FlxG.sound.music.amplitudeLeft;

    public static var amplitudeRight(get, null):Float;
    inline private static function get_amplitudeRight() return FlxG.sound.music.amplitudeRight;

    @:isVar public static var autoDestroy(get, set):Bool;
    inline private static function get_autoDestroy() return FlxG.sound.music.autoDestroy;
    inline private static function set_autoDestroy(autoDestroy:Bool):Bool return FlxG.sound.music.autoDestroy = autoDestroy;


    @:isVar public static var onComplete(get, set):Void -> Void;
    inline private static function get_onComplete() return FlxG.sound.music.onComplete;
    inline private static function set_onComplete(onComplete:Void -> Void):Void -> Void return FlxG.sound.music.onComplete = onComplete;


    @:isVar public static var pan(get, set):Float;
    inline private static function get_pan() return FlxG.sound.music.pan;
    inline private static function set_pan(pan:Float):Float return FlxG.sound.music.pan = pan;

    public static var playing(get, never):Bool;
    inline private static function get_playing() return FlxG.sound.music.playing;

    @:isVar public static var volume(get, set):Float;
    inline private static function get_volume() return FlxG.sound.music.volume;
    inline private static function set_volume(volume:Float):Float return FlxG.sound.music.volume = volume;


    #if FLX_PITCH
    @:isVar public static var pitch(get, set):Float;
    inline private static function get_pitch() return FlxG.sound.music.pitch;
    inline private static function set_pitch(pitch:Float):Float return FlxG.sound.music.pitch = pitch;
    #end


    @:isVar public static var time(get, set):Float;
    inline private static function get_time() return FlxG.sound.music.time;
    inline private static function set_time(time:Float):Float return FlxG.sound.music.time = time;

    public static var length(get, never):Float;
    inline private static function get_length() return FlxG.sound.music.length;

    @:isVar public static var group(get, set):FlxSoundGroup;
    inline private static function get_group() return FlxG.sound.music.group;
    inline private static function set_group(group:FlxSoundGroup):FlxSoundGroup return FlxG.sound.music.group = group;


    @:isVar public static var looped(get, set):Bool;
    inline private static function get_looped() return FlxG.sound.music.looped;
    inline private static function set_looped(looped:Bool):Bool return FlxG.sound.music.looped = looped;


    @:isVar public static var loopTime(get, set):Float;
    inline private static function get_loopTime() return FlxG.sound.music.loopTime;
    inline private static function set_loopTime(loopTime:Float):Float return FlxG.sound.music.loopTime = loopTime;


    @:isVar public static var endTime(get, set):Null<Float>;
    inline private static function get_endTime() return FlxG.sound.music.endTime;
    inline private static function set_endTime(endTime:Null<Float>):Null<Float> return FlxG.sound.music.endTime = endTime;


    @:isVar public static var fadeTween(get, set):FlxTween;
    inline private static function get_fadeTween() return FlxG.sound.music.fadeTween;
    inline private static function set_fadeTween(fadeTween:FlxTween):FlxTween return FlxG.sound.music.fadeTween = fadeTween;

    public static function destroy() {
        FlxG.sound.music.destroy();
        return FlxG.sound.music;
    }

    public static function kill() {
        FlxG.sound.music.kill();
        return FlxG.sound.music;
    }

    public static function loadEmbedded(path:String, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void -> Void) {
        FlxG.sound.music.loadEmbedded(Path.music(path), Looped, AutoDestroy, OnComplete);
        return FlxG.sound.music;
    }

    public static function loadStream(SoundURL:String, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void -> Void, ?OnLoad:Void -> Void) {
        FlxG.sound.music.loadStream(SoundURL, Looped, AutoDestroy, OnComplete, OnLoad);
        return FlxG.sound.music;
    }

    public static function proximity(X:Float, Y:Float, TargetObject:FlxObject, Radius:Float, Pan:Bool = true) {
        FlxG.sound.music.proximity(X, Y, TargetObject, Radius, Pan);
        return FlxG.sound.music;
    }

    public static function play(path:String, volume = 1.0, looped = true, ?group:FlxSoundGroup) {
        FlxG.sound.playMusic(Path.music(path), volume, looped, group);
        return FlxG.sound.music;   
    }

    public static function resume() {
        FlxG.sound.music.resume();
        return FlxG.sound.music;
    }

    public static function pause() {
        FlxG.sound.music.pause();
        return FlxG.sound.music;
    }

    public static function stop() {
        FlxG.sound.music.stop();
        return FlxG.sound.music;
    }

    public static function fadeOut(Duration:Float = 1, ?To:Float = 0, ?onComplete:FlxTween -> Void) {
        FlxG.sound.music.fadeOut(Duration, To, onComplete);
        return FlxG.sound.music;
    }

    public static function fadeIn(Duration:Float = 1, From:Float = 0, To:Float = 1, ?onComplete:FlxTween -> Void) {
        FlxG.sound.music.fadeIn(Duration, From, To, onComplete);
        return FlxG.sound.music;
    }

    public static function getActualVolume() return FlxG.sound.music.getActualVolume();

    public static function setPosition(X:Float = 0, Y:Float = 0) {
        FlxG.sound.music.setPosition(X, Y);
        return FlxG.sound.music;
    }
}