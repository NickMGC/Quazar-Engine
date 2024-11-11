package core.ui;

class BeatSubstate extends MenuSubstate {
    function onBeat() {}
    function onStep() {}

    var curMeasure(get, set):Int;
	@:noCompletion @:keep inline function get_curMeasure()        return Std.int(Conductor.measure.cur);
	@:noCompletion @:keep inline function set_curMeasure(val:Int) return Std.int(Conductor.measure.cur = val);

    var curBeat(get, set):Int;
	@:noCompletion @:keep inline function get_curBeat()           return Std.int(Conductor.beat.cur);
	@:noCompletion @:keep inline function set_curBeat(val:Int)    return Std.int(Conductor.beat.cur = val);

	var curStep(get, set):Int;
	@:noCompletion @:keep inline function get_curStep()           return Std.int(Conductor.step.cur);
	@:noCompletion @:keep inline function set_curStep(val:Int)    return Std.int(Conductor.step.cur = val);

    override function create() {
        Conductor.paused = false;
        Conductor.step.signal.add(onStep);
		Conductor.beat.signal.add(onBeat);

        super.create();
    }

	override function destroy() {
        Conductor.paused = true;
        Conductor.step.signal.remove(onStep);
        Conductor.beat.signal.remove(onBeat);

        super.destroy();
    }
}