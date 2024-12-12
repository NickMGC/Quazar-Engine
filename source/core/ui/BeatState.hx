package core.ui;

class BeatState extends MenuState {
    function onMeasure() {}
    function onBeat() {}
    function onStep() {}

    @:keep var curMeasure(get, set):Int;
	@:noCompletion @:keep inline function get_curMeasure() return Std.int(Conductor.timings.measure.cur);
	@:noCompletion @:keep inline function set_curMeasure(val:Int) return Std.int(Conductor.timings.measure.cur = val);

    @:keep var curBeat(get, set):Int;
	@:noCompletion @:keep inline function get_curBeat() return Std.int(Conductor.timings.beat.cur);
	@:noCompletion @:keep inline function set_curBeat(val:Int) return Std.int(Conductor.timings.beat.cur = val);

	@:keep var curStep(get, set):Int;
	@:noCompletion @:keep inline function get_curStep() return Std.int(Conductor.timings.step.cur);
	@:noCompletion @:keep inline function set_curStep(val:Int) return Std.int(Conductor.timings.step.cur = val);

    @:keep var bpm(get, set):Float;
	@:noCompletion @:keep inline function get_bpm() return Conductor.bpm.cur;
	@:noCompletion @:keep inline function set_bpm(val:Float) return Conductor.bpm.cur = val;

    override function create() {
        Conductor.paused = false;
        Conductor.timings.measure.signal.add(onMeasure);
        Conductor.timings.beat.signal.add(onBeat);
        Conductor.timings.step.signal.add(onStep);

        super.create();
    }

	override function destroy() {
        Conductor.reset();
        Conductor.timings.measure.signal.remove(onMeasure);
        Conductor.timings.beat.signal.remove(onBeat);
        Conductor.timings.step.signal.remove(onStep);

        super.destroy();
    }
}