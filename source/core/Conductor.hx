package core;

//TODO: test bpm changes
class Conductor extends FlxBasic {
	public static var song(default, set):FlxSound;

	public static var measure:Timing = new Timing(0.25);
	public static var beat:Timing = new Timing(1);
	public static var step:Timing = new Timing(4);

	public static var time:Float = 0;

	private static var lastTime:Float = 0;
	private static var offset:Float = 0;

	public static var bpm(default, set):Float;
	public static var paused:Bool = true;

	inline public function new() super();

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (paused) return;

		time += elapsed * 1000;

		if (song?.playing) {
			if (song.time < lastTime) offset += song.length;
			if (Math.abs(time - (song.time + offset + Data.offset)) >= 25) time = song.time + offset + Data.offset;

			lastTime = song.time;
		}

		for (timing in [measure, beat, step]) timing.update();
	}

	public static function reset():Void {
		bpm = 60;
		time = lastTime = offset = 0;

		for (timing in [measure, beat, step]) timing.reset();

        paused = true;
		song = null;
	}

	static function set_bpm(value:Float):Float {
		for (timing in [measure, beat, step]) {
			timing.recalculate(value);
			timing.tracker = Data.offset - timing.length;
		}

		return bpm = value;
	}

	@:noCompletion private inline static function set_song(value:FlxSound):FlxSound return song = value ?? Music.self;
}

class Timing {
	public var signal:FlxSignal = new FlxSignal();

	public var length:Float = -1;
	public var tracker:Float = 0;
	public var cur:Int = 0;

	public var mult:Float = 1;

	inline public function new(mult:Float) this.mult = mult;

	public function update():Void {
		if (Conductor.time < length + tracker) return;

		tracker += length;
		cur++;
		signal.dispatch();
	}

	public inline function recalculate(bpm:Float):Void {
		length = (60000 / bpm) * mult;
	}

	public function reset():Void {
		length = -1;
		tracker = cur = 0;
	}
}

typedef TimeSignature = {numerator:Int, denominator:Int}