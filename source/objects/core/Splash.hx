package objects.core;

@:publicFields class Splash extends FlxSprite {
	function new(index = 0) {
		super();

        final id = index % 4;
		final dir = Note.notes[id];

		Sparrow('game/noteSplashes/splashes');
		for (i in [1, 2]) this.addPrefix(dir + i, '$dir ${i}0', 24, false);

		this.playAnim(dir + FlxG.random.int(1, 2));

        animation.finishCallback = _ -> kill;
	}
}