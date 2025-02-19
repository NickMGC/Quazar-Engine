package core;

class Conductor extends FlxBasic {
	public static var song(default, set):FlxSound;

	public static var measure = Timing(0.25);
	public static var beat = Timing(1);
	public static var step = Timing(4);

	public static var time:Float = 0;
	static var lastTime:Float = 0;
	static var offset:Float = 0;

	public static var bpm:Float;
	public static var paused:Bool = true;

	inline public function new() super();

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (paused) return;

		time += elapsed * 1000;

		if (song?.playing) {
			if (song.looped && song.time < lastTime) offset += song.length;
			if (Math.abs(time - (song.time + offset)) >= 25) time = song.time + offset;
	
			lastTime = song.time;
		}

		for (timing in [measure, beat, step]) while ((time + Data.offset) >= timing.tracker) {
			timing.signal.dispatch();
			timing.cur++;
			timing.tracker += (60000 / Conductor.bpm) * timing.mult;
		}
	}

	public static function reset():Void {
		bpm = 60;

		time = lastTime = offset = 0;
		for (timing in [measure, beat, step]) timing.tracker = timing.cur = 0;

        paused = true;
		song = null;
	}

	@:noCompletion inline static function set_song(value:FlxSound):FlxSound return song = value ?? Music.self;
	@:noCompletion private inline static function Timing(mult:Float):TimingData return {cur: 0, tracker: 0, mult: mult, signal: new FlxSignal()};
}

typedef TimingData = {cur:Int, tracker:Float, mult:Float, signal:FlxSignal}