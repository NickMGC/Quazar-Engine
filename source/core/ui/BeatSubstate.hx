package core.ui;

class BeatSubstate extends MenuSubstate {
    function onMeasure() {}
    function onBeat() {}
    function onStep() {}

    var curMeasure(get, set):Int;
	@:noCompletion @:keep inline function get_curMeasure()        return Std.int(Conductor.timings.measure.cur);
	@:noCompletion @:keep inline function set_curMeasure(val:Int) return Std.int(Conductor.timings.measure.cur = val);

    var curBeat(get, set):Int;
	@:noCompletion @:keep inline function get_curBeat()           return Std.int(Conductor.timings.beat.cur);
	@:noCompletion @:keep inline function set_curBeat(val:Int)    return Std.int(Conductor.timings.beat.cur = val);

	var curStep(get, set):Int;
	@:noCompletion @:keep inline function get_curStep()           return Std.int(Conductor.timings.step.cur);
	@:noCompletion @:keep inline function set_curStep(val:Int)    return Std.int(Conductor.timings.step.cur = val);

    override function create() {
        Conductor.paused = false;
        Conductor.timings.beat.signal.add(onMeasure);
        Conductor.timings.beat.signal.add(onBeat);
        Conductor.timings.step.signal.add(onStep);

        super.create();
    }

	override function destroy() {
        Conductor.time = 0;
        Conductor.paused = true;
        Conductor.timings.beat.signal.remove(onMeasure);
        Conductor.timings.beat.signal.remove(onBeat);
        Conductor.timings.step.signal.remove(onStep);

        super.destroy();
    }
}