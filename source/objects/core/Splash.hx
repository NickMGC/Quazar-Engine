package objects.core;

class Splash extends FlxSprite {
	public function new(cam:FlxCamera) {
		super();

		camera = cam;

		this.loadSparrowFrames('game/noteSplashes/splashes');
		for (note in Note.notes) this.addPrefix(note + 1, '$note 10', 24, false).addPrefix(note + 2, '$note 20', 24, false);
	}
}