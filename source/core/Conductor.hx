package core;

@:publicFields class Conductor extends FlxBasic {
	static var timings = {
		measure: {length: .0, last: -1., cur: 0, signal: new FlxSignal()},
		beat: {length: .0, last: -1., cur: 0, signal: new FlxSignal()},
		step: {length: .0, last: -1., cur: 0, signal: new FlxSignal()}
	};

	static var song(default, set):FlxSound;
	static var bpm = {cur: .0, last: .0, offset: .0};

	static var time = .0;

	static var paused = true;

	private static var offset = .0;
	private static var lastTime = .0;

	inline function new() super();

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (paused) return;

		time += elapsed * 1000;

		if (song?.playing) {
			if (song.time < lastTime) offset += song.length;
			if (Math.abs(time - (song.time + offset)) >= 25) time = song.time + offset;

			lastTime = song.time;
		}

		if (bpm.last != bpm.cur) {
			bpm.offset = time * (1 - bpm.last / bpm.cur);
            bpm.last = bpm.cur;
        }

		timings.beat.length = (time - Data.offset - bpm.offset) / (60000 / bpm.cur);
		timings.measure.length = timings.beat.length * .25;
		timings.step.length = timings.beat.length * 4;

		for (type in [timings.measure, timings.beat, timings.step]) if (Math.floor(type.last) != Math.floor(type.length)) {
			type.last = type.length;
			type.cur++;
			type.signal.dispatch();
		}
	}

	static function reset() {
		song = null;

		timings.measure.length = timings.beat.length = timings.step.length = time = bpm.cur = bpm.last = bpm.offset = offset = lastTime = timings.measure.cur = timings.beat.cur = timings.step.cur = 0;
        timings.measure.last = timings.beat.last = timings.step.last = -1;
        paused = true;
	}

	@:noCompletion private inline static function set_song(snd) return song = snd ?? Music;
}