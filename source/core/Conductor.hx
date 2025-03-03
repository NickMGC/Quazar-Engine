package core;

class Conductor extends FlxBasic {
	public static var self:Conductor;

	public var song(get, default):FlxSound;

	public var measure:Timing = new Timing(0.25);
	public var beat:Timing = new Timing(1);
	public var step:Timing = new Timing(4);

	public var time:Float = 0;
	public var bpm:Float;

	public var paused:Bool = true;

	inline public function new() {
		super();
		self = this;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (paused || !song?.playing) return;

		updateTime(elapsed);
		updateTimings();
	}

	function updateTime(elapsed:Float):Void {
		time += elapsed * 1000;

		if (song?.playing && Math.abs(time - (song.time)) >= 25) {
			time = song.time;
		}
	}

	inline function updateTimings():Void {
		for (timing in [measure, beat, step]) {
			timing.update(time, bpm);
		}
	}

	inline function get_song():FlxSound {
		return song ?? Music.self;
	}
}

class Timing {
	public var signal:FlxSignal = new FlxSignal();

	public var tracker:Float = 0;
	public var cur:Int = 0;

	public var multiplier:Float;

	inline public function new(multiplier:Float) {
		this.multiplier = multiplier;
	}

	public function update(time:Float, bpm:Float):Void {
		while ((time + Data.offset) < tracker) return;
		
		cur++;
		signal.dispatch();
		tracker += (60000 / bpm) * multiplier;
	}
}