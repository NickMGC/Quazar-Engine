package core;

class MusicScene extends Scene {
	function onMeasure() {}
	function onBeat() {}
	function onStep() {}

	var conductor:Conductor = new Conductor();

	var curBeat(get, never):Int;
	inline function get_curBeat() return conductor.beat.cur;

	var curStep(get, never):Int;
	inline function get_curStep() return conductor.step.cur;
	
	var curMeasure(get, never):Int;
	inline function get_curMeasure() return conductor.measure.cur;

	var bpm(get, set):Float;
	inline function get_bpm() return conductor.bpm;
	inline function set_bpm(val:Float) return conductor.bpm = val;

	override function create():Void {
		add(conductor);

		conductor.paused = false;
		conductor.measure.signal.add(onMeasure);
		conductor.beat.signal.add(onBeat);
		conductor.step.signal.add(onStep);

		super.create();
	}

	override function destroy():Void {
		super.destroy();

		conductor.measure.signal.remove(onMeasure);
		conductor.beat.signal.remove(onBeat);
		conductor.step.signal.remove(onStep);
		conductor = null;
	}
}