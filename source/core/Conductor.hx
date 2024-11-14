package core;

@:publicFields class Conductor extends FlxBasic {
	static var timings = {measure: {cur: .0, last: -1., signal: new FlxSignal()}, beat: {cur: .0, last: -1., signal: new FlxSignal()}, step: {cur: .0, last: -1., signal: new FlxSignal()}};
	static var song(default, set):FlxSound;

	static var bpm = .0;
	private static var lastBpm = .0;
    private static var bpmChangeOffset = .0;

	static var time = .0;
	static var paused = true;

	inline function new() super();

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (paused) return;

		time += elapsed * 1000;
		if (song?.playing && Math.abs(time - song.time) >= 25) time = song.time;

        if (lastBpm != bpm) {
            bpmChangeOffset = (time - Data.offset) * (1 - (lastBpm / bpm));
            lastBpm = bpm;
        }

		timings.beat.cur = (time - Data.offset - bpmChangeOffset) / (60000 / bpm);
		timings.measure.cur = timings.beat.cur * 0.25;
		timings.step.cur = timings.beat.cur * 4;

		for (type in [timings.measure, timings.beat, timings.step]) if (Math.floor(type.last) != Math.floor(type.cur)) {
			type.last = type.cur;
			type.signal.dispatch();
		}
	}

	@:noCompletion private inline static function set_song(snd) return song = snd ?? FlxG.sound.music;
}