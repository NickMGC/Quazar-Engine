package core.ui;

class MusicSubScene extends SubScene {
    function onMeasure() {}
    function onBeat() {}
    function onStep() {}

    @:keep var curMeasure(get, never):Int;
	@:noCompletion @:keep inline function get_curMeasure() return Conductor.measure.cur;

    @:keep var curBeat(get, never):Int;
	@:noCompletion @:keep inline function get_curBeat() return Conductor.beat.cur;

    @:keep var curStep(get, never):Int;
	@:noCompletion @:keep inline function get_curStep() return Conductor.step.cur;

    @:keep var bpm(get, set):Float;
	@:noCompletion @:keep inline function get_bpm() return Conductor.bpm;
	@:noCompletion @:keep inline function set_bpm(val:Float) return Conductor.bpm = val;

    override function create() {
        Conductor.paused = false;
        Conductor.measure.signal.add(onMeasure);
        Conductor.beat.signal.add(onBeat);
        Conductor.step.signal.add(onStep);

        super.create();
    }

	override function destroy() {
        Conductor.reset();
        Conductor.measure.signal.remove(onMeasure);
        Conductor.beat.signal.remove(onBeat);
        Conductor.step.signal.remove(onStep);

        super.destroy();
    }
}