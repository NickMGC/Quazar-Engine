package core;

@:publicFields class Conductor extends FlxBasic {
	private inline static function timing() return {cur: .0, last: -1., signal: new FlxSignal()};
	static var timings = {measure: timing(), beat: timing(), step: timing()}; //anon structures are slow but this variable gets created once so it doesnt matter

	static var song(default, set):FlxSound;

	static var bpm  = .0;
	static var time = .0;

	static var paused = true;

	inline function new() super();

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (paused) return;

		timings.beat.cur = ((time += elapsed * 1000) - Data.offset) / (60000 / bpm);
		timings.measure.cur = timings.beat.cur / 4;
		timings.step.cur = timings.beat.cur * 4;

		if (song?.playing && Math.abs(time - song.time) >= 25) time = song.time;

		for (type in [timings.measure, timings.beat, timings.step]) if (Math.floor(type.last) != Math.floor(type.cur)) {
			type.last = type.cur;
			type.signal.dispatch();
		}
	}

	@:noCompletion private inline static function set_song(snd) return song = snd ?? FlxG.sound.music;
}