package objects.core;

class StrumLine extends FlxSpriteGroup {
	public var sustains:FlxTypedSpriteGroup<Sustain>;

	public var strums:Array<StrumNote> = [];

	public var notes:FlxTypedSpriteGroup<Note>;
	public var splashes:FlxTypedSpriteGroup<Splash>;

	public var autoHit:Bool = false;

	public function new(x:Float = 0, y:Float = 0) {
		super(0, y);

		add(sustains = new FlxTypedSpriteGroup<Sustain>());

		for (i in 0...4) {
			strums.push(new StrumNote(i, this));
			strums[i].x = (strums[i].width + 5) * i;
			add(strums[i]);
		}

		add(notes = new FlxTypedSpriteGroup<Note>());
		add(splashes = new FlxTypedSpriteGroup<Splash>());

		screenCenter(X);
		this.x += x;
	}
}
