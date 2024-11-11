package backend;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;

import openfl.display.BitmapData;
import openfl.media.Sound;

import sys.io.File;
import sys.FileSystem;

@:keep @:publicFields class Path {
	static final invalidChars = ~/[~&\\;:<>#]/;
	static final hideChars = ~/[.,'"%?!]/;

	static var localAssets:Array<String> = [];
	static var trackedImages:Map<String, FlxGraphic> = [];
	static var trackedAudio:Map<String, Sound> = [];

	static var exclusions:Array<String> = [
		'assets/sounds/confirmMenu.ogg', 'assets/sounds/cancelMenu.ogg', 'assets/sounds/scrollMenu.ogg',
		'assets/music/freakyMenu.ogg', 'assets/music/breakfast.ogg',
		'assets/images/default.png', 'assets/images/default.fnt',
		'assets/images/bold.png', 'assets/images/bold.fnt',
		'assets/images/ui/transition.png'
	];

	static function get(key:String, ?pos:haxe.PosInfos) {
		try {
			if (!FileSystem.exists('assets/$key')) {
				trace('$key could not be found: $pos');
				return null;
			}
			return 'assets/$key';
		} catch(e:Dynamic) {
			trace('Error accessing $key: $e');
			return null;
		}
	}

	static function image(key:String) {
		localAssets.push(key);

		if (!trackedImages.exists(key)) {
			final bitmap = BitmapData.fromFile(get('$key.png')) ?? FlxAssets.getBitmapData('flixel/images/logo/default.png');
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

	inline static function font (key:String) return get('data/fonts/$key');
	inline static function fnt  (key:String) return get('$key.fnt');
	inline static function video(key:String) return get('videos/$key.mp4');
	inline static function xml  (key:String) return get('$key.xml');
	inline static function txt  (key:String) return get('$key.txt');
	inline static function json (key:String) return get('$key.json');
	inline static function sound(key:String) return audio('sounds/$key');
	inline static function music(key:String) return audio('music/$key');

	inline static function inst  (key:String, ?postfix:String) return audio('data/songs/${formatSongPath(key)}/Inst${postfix != null ? '-$postfix' : ''}');
	inline static function voices(key:String, ?postfix:String) return audio('data/songs/${formatSongPath(key)}/Voices${postfix != null ? '-$postfix' : ''}');
	inline static function formatSongPath(key:String) return hideChars.split(invalidChars.split(key.replace(' ', '-')).join('-')).join('').toLowerCase();

	inline static function sparrowAtlas(key:String) return FlxAtlasFrames.fromSparrow(image(key), xml(key));

	inline static function getFileText(key:String) return FileSystem.exists(get(key)) ? File.getContent(get(key)) : null;
	inline static function fileExists (key:String) return FileSystem.exists(get(key)) ? true : false;

	static function clearUnusedMemory() {
		removeMapContent(trackedImages, (key) -> {
			trackedImages[key].destroy();
			FlxG.bitmap.remove(trackedImages[key]);
		});

		removeMapContent(trackedAudio,  (key) -> openfl.Assets.cache.clear(key));

		openfl.system.System.gc();
	}

	static function clearStoredMemory() {
		clearUnusedMemory();
		localAssets = [];
	}

	@:noCompletion static function removeMapContent(map:Map<Any, Any>, callback:String -> Void) {
		for (key in map.keys()) if (!localAssets.contains(key) && !exclusions.contains(key)) {
			callback(key);
			map.remove(key);
		}
	}
}