package backend;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;

import openfl.display.BitmapData;
import openfl.media.Sound;

import sys.FileSystem;

@:keep @:publicFields class Path {
	static var localAssets:Array<String> = [];
	static var trackedImages:Map<String, FlxGraphic> = [];
	static var trackedAudio:Map<String, Sound> = [];

	static var exclusions:Array<String> = [
		'assets/music/freakyMenu.ogg', 'assets/music/breakfast.ogg',
		'assets/images/default.png', 'assets/images/default.fnt',
		'assets/images/bold.png', 'assets/images/bold.fnt',
		'assets/images/ui/transition.png',
		'assets/sounds/tick.ogg'
	];

	static function get(key:String, ?pos:haxe.PosInfos) {
		if (!FileSystem.exists('assets/$key')) {
			trace('$key could not be found: $pos');
			return null;
		}
		return 'assets/$key';
	}

	static function image(key:String, ?prefix:String = 'images') {
		localAssets.push(key);

		if (!trackedImages.exists(key)) {
			final bitmap = BitmapData.fromFile(get('$prefix/$key.png')) ?? FlxAssets.getBitmapData('flixel/images/logo/default.png');
			if (Data.gpuRendering) bitmap.disposeImage();

			final graphic = FlxGraphic.fromBitmapData(bitmap, false, key);
			graphic.persist = true;
			trackedImages.set(key, graphic);
		}

		return trackedImages[key];
	}

	static function audio(key:String) {
		localAssets.push(key);
		if (!trackedAudio.exists(key)) trackedAudio.set(key, Sound.fromFile(get('$key.ogg')) ?? FlxAssets.getSound('flixel/sounds/beep'));
		return trackedAudio[key];
    }

	inline static function font(key:String) return get('data/fonts/$key');
	inline static function fnt(key:String) return get('$key.fnt');
	inline static function video(key:String) return get('videos/$key.mp4');

	inline static function xml(key:String) return get('$key.xml');
	inline static function txt(key:String) return get('$key.txt');
	inline static function json(key:String) return get('$key.json');

	inline static function sound(key:String) return audio('sounds/$key');
	inline static function music(key:String) return audio('music/$key');

	inline static function inst(key:String, ?postfix:String) return audio('data/songs/$key/Inst${postfix != null ? '-$postfix' : ''}');
	inline static function voices(key:String, ?postfix:String) return audio('data/songs/$key/Voices${postfix != null ? '-$postfix' : ''}');

	inline static function sparrow(key:String, ?prefix:String = 'images') return FlxAtlasFrames.fromSparrow(image(key, prefix), xml('$prefix/$key'));
	inline static function aseprite(key:String, ?prefix:String = 'images') return FlxAtlasFrames.fromAseprite(image(key, prefix), json('$prefix/$key'));
	inline static function packer(key:String, ?prefix:String = 'images') return FlxAtlasFrames.fromTexturePackerJson(image(key, prefix), txt('$prefix/$key'));

	inline static function exists(key:String) return FileSystem.exists(get(key)) ? true : false;

	static function clearUnusedMemory() {
		removeMapContent(trackedImages, (key) -> FlxG.bitmap.remove(trackedImages[key]));
		removeMapContent(trackedAudio, (key) -> openfl.Assets.cache.clear(key));

		openfl.system.System.gc();
	}

	static function clearStoredMemory() {
		localAssets = [];
		clearUnusedMemory();
	}

	@:noCompletion static function removeMapContent(map:Map<Any, Any>, callback:String -> Void) {
		for (key in map.keys()) if (!localAssets.contains(key) && !exclusions.contains(key)) {
			callback(key);
			map.remove(key);
		}
	}
}