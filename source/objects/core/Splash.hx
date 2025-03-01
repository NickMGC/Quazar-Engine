package objects.core;

class Splash extends FlxSprite {
	public function new(cam:FlxCamera) {
		super();

		camera = cam;

		this.loadSparrowFrames('game/noteSplashes/splashes');
		for (note in Note.notes) this.addPrefix(note + 1, '$note 10', 24, false).addPrefix(note + 2, '$note 20', 24, false);
	}

	public static function spawn(strum:StrumNote):Void {
		var splash:Splash = strum.line.splashes.recycle(Splash, newSplash);

		splash.setPosition(Std.int(strum.x + (strum.width - splash.width) * 0.5), Std.int(strum.y + (strum.height - splash.height) * 0.5));
		splash.playAnim(Note.notes[strum.index % 4] + FlxG.random.int(1, 2));

		function killSplash(name:String):Void splash.kill();

		splash.onAnimFinish(killSplash);
	}

	static function newSplash():Splash {
		return new Splash(PlayScene.self.camHUD).setScale(0.9);
	}
}