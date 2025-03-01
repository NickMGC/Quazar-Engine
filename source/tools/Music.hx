package tools;

import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;

@:isVar var self(get, set):FlxSound;
inline private function get_self() return FlxG.sound.music;
inline private function set_self(sound:FlxSound):FlxSound return FlxG.sound.music = sound;


@:isVar var x(get, set):Float;
inline private function get_x() return FlxG.sound.music.x;
inline private function set_x(x:Float):Float return FlxG.sound.music.x = x;


@:isVar var y(get, set):Float;
inline private function get_y() return FlxG.sound.music.y;
inline private function set_y(y:Float):Float return FlxG.sound.music.y = y;


@:isVar var persist(get, set):Bool;
inline private function get_persist() return FlxG.sound.music.persist;
inline private function set_persist(persist:Bool):Bool return FlxG.sound.music.persist = persist;

var name(get, null):String;
inline private function get_name() return FlxG.sound.music.name;

var artist(get, null):String;
inline private function get_artist() return FlxG.sound.music.artist;

var amplitude(get, null):Float;
inline private function get_amplitude() return FlxG.sound.music.amplitude;

var amplitudeLeft(get, null):Float;
inline private function get_amplitudeLeft() return FlxG.sound.music.amplitudeLeft;

var amplitudeRight(get, null):Float;
inline private function get_amplitudeRight() return FlxG.sound.music.amplitudeRight;

@:isVar var autoDestroy(get, set):Bool;
inline private function get_autoDestroy() return FlxG.sound.music.autoDestroy;
inline private function set_autoDestroy(autoDestroy:Bool):Bool return FlxG.sound.music.autoDestroy = autoDestroy;


@:isVar var onComplete(get, set):Void -> Void;
inline private function get_onComplete() return FlxG.sound.music.onComplete;
inline private function set_onComplete(onComplete:Void -> Void):Void -> Void return FlxG.sound.music.onComplete = onComplete;


@:isVar var pan(get, set):Float;
inline private function get_pan() return FlxG.sound.music.pan;
inline private function set_pan(pan:Float):Float return FlxG.sound.music.pan = pan;

var playing(get, never):Bool;
inline private function get_playing() return FlxG.sound.music.playing;

@:isVar var volume(get, set):Float;
inline private function get_volume() return FlxG.sound.music.volume;
inline private function set_volume(volume:Float):Float return FlxG.sound.music.volume = volume;


#if FLX_PITCH
@:isVar var pitch(get, set):Float;
inline private function get_pitch() return FlxG.sound.music.pitch;
inline private function set_pitch(pitch:Float):Float return FlxG.sound.music.pitch = pitch;
#end


@:isVar var time(get, set):Float;
inline private function get_time() return FlxG.sound.music.time;
inline private function set_time(time:Float):Float return FlxG.sound.music.time = time;

var length(get, never):Float;
inline private function get_length() return FlxG.sound.music.length;

@:isVar var group(get, set):FlxSoundGroup;
inline private function get_group() return FlxG.sound.music.group;
inline private function set_group(group:FlxSoundGroup):FlxSoundGroup return FlxG.sound.music.group = group;


@:isVar var looped(get, set):Bool;
inline private function get_looped() return FlxG.sound.music.looped;
inline private function set_looped(looped:Bool):Bool return FlxG.sound.music.looped = looped;


@:isVar var loopTime(get, set):Float;
inline private function get_loopTime() return FlxG.sound.music.loopTime;
inline private function set_loopTime(loopTime:Float):Float return FlxG.sound.music.loopTime = loopTime;


@:isVar var endTime(get, set):Null<Float>;
inline private function get_endTime() return FlxG.sound.music.endTime;
inline private function set_endTime(endTime:Null<Float>):Null<Float> return FlxG.sound.music.endTime = endTime;


@:isVar var fadeTween(get, set):FlxTween;
inline private function get_fadeTween() return FlxG.sound.music.fadeTween;
inline private function set_fadeTween(fadeTween:FlxTween):FlxTween return FlxG.sound.music.fadeTween = fadeTween;

function destroy() {
	FlxG.sound.music.destroy();
	return FlxG.sound.music;
}

function kill() {
	FlxG.sound.music.kill();
	return FlxG.sound.music;
}

function loadEmbedded(path:String, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void -> Void) {
	FlxG.sound.music.loadEmbedded(Path.music(path), Looped, AutoDestroy, OnComplete);
	return FlxG.sound.music;
}

function loadStream(SoundURL:String, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void -> Void, ?OnLoad:Void -> Void) {
	FlxG.sound.music.loadStream(SoundURL, Looped, AutoDestroy, OnComplete, OnLoad);
	return FlxG.sound.music;
}

function proximity(X:Float, Y:Float, TargetObject:FlxObject, Radius:Float, Pan:Bool = true) {
	FlxG.sound.music.proximity(X, Y, TargetObject, Radius, Pan);
	return FlxG.sound.music;
}

function play(path:String, volume:Float = 1, looped:Bool = true, ?group:FlxSoundGroup) {
	FlxG.sound.playMusic(Path.music(path), volume, looped, group);
	return FlxG.sound.music;   
}

function resume() {
	FlxG.sound.music.resume();
	return FlxG.sound.music;
}

function pause() {
	FlxG.sound.music.pause();
	return FlxG.sound.music;
}

function stop() {
	FlxG.sound.music.stop();
	return FlxG.sound.music;
}

function fadeOut(Duration:Float = 1, ?To:Float = 0, ?onComplete:FlxTween -> Void) {
	FlxG.sound.music.fadeOut(Duration, To, onComplete);
	return FlxG.sound.music;
}

function fadeIn(Duration:Float = 1, From:Float = 0, To:Float = 1, ?onComplete:FlxTween -> Void) {
	FlxG.sound.music.fadeIn(Duration, From, To, onComplete);
	return FlxG.sound.music;
}

function getActualVolume() {
    return FlxG.sound.music.getActualVolume();
}

function setPosition(X:Float = 0, Y:Float = 0) {
	FlxG.sound.music.setPosition(X, Y);
	return FlxG.sound.music;
}