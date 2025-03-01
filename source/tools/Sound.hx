package tools;

import flixel.system.frontEnds.SoundFrontEnd;
import flixel.sound.FlxSoundGroup;

function play(path:String, volume:Float = 1, looped:Bool = false, ?group:FlxSoundGroup, autoDestroy:Bool = true, ?onComplete:Void -> Void):SoundFrontEnd {
	FlxG.sound.play(Path.sound(path), volume, looped, group, autoDestroy, onComplete);
	return FlxG.sound;   
}