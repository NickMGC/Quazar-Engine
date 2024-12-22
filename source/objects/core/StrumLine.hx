package objects.core;

@:publicFields class StrumLine extends FlxSpriteGroup {
	var sustains:FlxTypedSpriteGroup<Sustain>;

	var strums:Array<StrumNote> = [];

	var notes:FlxTypedSpriteGroup<Note>;
	var splashes:FlxTypedSpriteGroup<Splash>;

	var autoHit = false;

	function new(x:Float = 0, y:Float = 0) {
		super(0, y);

		add(sustains = new FlxTypedSpriteGroup<Sustain>());

		for (i in 0...4) {
			var strum = new StrumNote(i, this);
			strum.x = (strum.width + 5) * i;
			add(strum);
			strums.push(strum);
		}

		add(notes = new FlxTypedSpriteGroup<Note>());
		add(splashes = new FlxTypedSpriteGroup<Splash>());

		screenCenter(X);
		this.x += x;
	}
}
