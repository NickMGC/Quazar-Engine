package objects.core;

@:publicFields class Splash extends FlxSprite {
	function new(index = 0) {
		super();

		this.loadFrames('game/noteSplashes/splashes');
		for (note in Note.notes) this.addPrefix(note + 1, '$note 10', 24, false).addPrefix(note + 2, '$note 20', 24, false);
	}

	function splash(index = 0) this.playAnim(Note.notes[index % 4] + FlxG.random.int(1, 2)).onAnimFinish(name -> kill());
}