package core.ui;

class MenuSubstate extends FlxSubState {
	var storedControls:Map<String, Map<Int, FlxSignal>>;

	override function create() {
		storedControls = Controls.callbacks;
		for (i in ['press', 'hold', 'release']) Controls.callbacks[i].clear();

		closeCallback = () -> Controls.callbacks = storedControls;

		super.create();
	}

	override function update(elapsed:Float) {super.update(elapsed);}
}