package core;

@:publicFields class Conductor extends FlxBasic {
	static var timings = {
		measure: {length: .0, last: -1., cur: -1, signal: new FlxSignal()},
		beat: {length: .0, last: -1., cur: -1, signal: new FlxSignal()},
		step: {length: .0, last: -1., cur: -1, signal: new FlxSignal()}
	};

	static var song(default, set):FlxSound;
	static var bpm = {cur: .0, last: .0, offset: .0};

	static var timeSignature = [4, 4];
	static var time = .0;

	static var paused = true;

 	//Data.offset didn't play nice with looping so I had to bring out the big guns.
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

		timings.beat.length = (time - Data.offset - bpm.offset) / (60000 / bpm.cur) * (4 / timeSignature[1]);
		timings.measure.length = timings.beat.length * .25;
		timings.step.length = timings.beat.length * timeSignature[0];

		for (type in [timings.measure, timings.beat, timings.step]) if (Math.floor(type.last) != Math.floor(type.length)) {
			type.last = type.length;
			type.cur++;
			type.signal.dispatch();
		}
	}

	static function reset() {
		song = null;
		timeSignature = [4, 4];

		time = bpm.cur = bpm.last = bpm.offset = offset = lastTime = 0;
        timings.measure.last = timings.beat.last = timings.step.last = timings.measure.cur = timings.beat.cur = timings.step.cur = -1;
        paused = true;
	}

	@:noCompletion private inline static function set_song(snd) return song = snd ?? FlxG.sound.music;
}