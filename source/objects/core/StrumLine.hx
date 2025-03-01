package objects.core;

class StrumLine extends FlxSpriteGroup {
	public var sustains:FlxTypedSpriteGroup<Sustain>;
	public var splashes:FlxTypedSpriteGroup<Splash>;
	public var notes:FlxTypedSpriteGroup<Note>;

	public var strums:Array<StrumNote> = [];

	public var autoHit:Bool = false;

	public function new(x:Float = 0, y:Float = 0, autoHit:Bool = false) {
		super(0, y);

		this.autoHit = autoHit;

		add(sustains = new FlxTypedSpriteGroup());

		for (i in 0...4) {
			strums.push(new StrumNote(this, i));
			strums[i].x = (strums[i].width + 5) * i;
			add(strums[i]);
		}

		add(notes = new FlxTypedSpriteGroup());
		add(splashes = new FlxTypedSpriteGroup());

		screenCenter(X);
		this.x += x;
	}
}
