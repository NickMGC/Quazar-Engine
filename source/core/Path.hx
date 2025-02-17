package core;

import haxe.PosInfos;

import openfl.utils.Assets;
import openfl.system.System;
import openfl.display.BitmapData;
import openfl.media.Sound as OpenFLSound;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;

import sys.FileSystem;

@:keep class Path {
	public static var localAssets:Array<String> = [];
	public static var trackedImages:Map<String, FlxGraphic> = [];
	public static var trackedAudio:Map<String, OpenFLSound> = [];

	public static var exclusions:Array<String> = [
		'assets/music/freakyMenu.ogg', 'assets/music/breakfast.ogg',
		'assets/images/ui/default.png', 'assets/images/ui/default.fnt',
		'assets/images/ui/bold.png', 'assets/images/ui/bold.fnt',
		'assets/images/ui/transition.png'
	];

	public static function get(key:String, ?pos:PosInfos) {
		if (!FileSystem.exists('assets/$key')) {
			trace('$key could not be found: $pos');
			return null;
		}
		return 'assets/$key';
	}

	public static function image(key:String, ?prefix:String = 'images') {
		localAssets.push(key);

		if (!trackedImages.exists(key)) {
			final bitmap:BitmapData = BitmapData.fromFile(get('$prefix/$key.png')) ?? FlxAssets.getBitmapData('flixel/images/logo/default.png');
			if (Data.gpuRendering) bitmap.disposeImage();

			final graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
			graphic.persist = true;
			trackedImages.set(key, graphic);
		}

		return trackedImages[key];
	}

	public static function audio(key:String) {
		localAssets.push(key);
		if (!trackedAudio.exists(key)) trackedAudio.set(key, OpenFLSound.fromFile(get('$key.ogg')) ?? FlxAssets.getSoundAddExtension('flixel/sounds/beep'));
		return trackedAudio[key];
    }

	inline public static function font(key:String) return get('data/fonts/$key');
	inline public static function fnt(key:String) return get('$key.fnt');
	inline public static function video(key:String) return get('videos/$key.mp4');

	inline public static function xml(key:String) return get('$key.xml');
	inline public static function txt(key:String) return get('$key.txt');
	inline public static function json(key:String) return get('$key.json');

	inline public static function sound(key:String) return audio('sounds/$key');
	inline public static function music(key:String) return audio('music/$key');

	inline public static function inst(key:String, ?postfix:String) return audio('data/songs/$key/Inst${postfix != null ? '-$postfix' : ''}');
	inline public static function voices(key:String, ?postfix:String) return audio('data/songs/$key/Voices${postfix != null ? '-$postfix' : ''}');

	inline public static function sparrow(key:String, ?prefix:String = 'images') return FlxAtlasFrames.fromSparrow(image(key, prefix), xml('$prefix/$key'));
	inline public static function aseprite(key:String, ?prefix:String = 'images') return FlxAtlasFrames.fromAseprite(image(key, prefix), json('$prefix/$key'));
	inline public static function packer(key:String, ?prefix:String = 'images') return FlxAtlasFrames.fromTexturePackerJson(image(key, prefix), txt('$prefix/$key'));

	inline public static function exists(key:String) return FileSystem.exists(get(key)) ? true : false;

	public static function clearUnusedMemory() {
		for (key in trackedImages.keys()) if (!localAssets.contains(key) && !exclusions.contains(key)) {
			FlxG.bitmap.remove(trackedImages[key]);
			trackedImages.remove(key);
		}

		for (key in trackedAudio.keys()) if (!localAssets.contains(key) && !exclusions.contains(key)) {
			Assets.cache.clear(key);
			trackedAudio.remove(key);
		}

		System.gc();
	}

	public static function clearStoredMemory() {
		clearUnusedMemory();
		localAssets = [];
	}
}