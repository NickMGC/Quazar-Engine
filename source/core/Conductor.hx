package core;

@:structInit @:publicFields class Timing {
	var cur = .0;
	var last = -1.;
	var signal = new FlxSignal();

	inline function new() {}
}

@:publicFields class Conductor extends FlxBasic {
	static var measure:Timing = new Timing();
	static var beat:Timing    = new Timing();
	static var step:Timing    = new Timing();

	static var song(default, set):FlxSound;

	static var bpm  = .0;
	static var time = .0;

	static var paused = true;

	inline function new() super();

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (paused) return;

		time += elapsed * 1000;
		if (song?.playing && Math.abs(time - song.time) > 20) time = song.time;

		beat.cur = (time - Data.offset) / (60000 / bpm);
		measure.cur = beat.cur * 4;
		step.cur = beat.cur / 4;

		for (type in [measure, beat, step]) if (Math.floor(type.last) != Math.floor(type.cur)) {
			type.last = type.cur;
			type.signal.dispatch();
		}
	}

	@:noCompletion inline static function set_song(snd) return song = snd ?? FlxG.sound.music;
}