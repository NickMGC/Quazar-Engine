package objects.core;

@:publicFields class Splash extends FlxSprite {
	function new(cam:FlxCamera) {
		super();

		camera = cam;

		this.loadFrames('game/noteSplashes/splashes');
		for (note in Note.notes) this.addPrefix(note + 1, '$note 10', 24, false).addPrefix(note + 2, '$note 20', 24, false);
	}
}