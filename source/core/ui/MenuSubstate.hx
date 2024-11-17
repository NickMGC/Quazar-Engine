package core.ui;

class MenuSubstate extends FlxSubState {
	var storedControls:Map<String, Map<Int, FlxSignal>>;

	override function create() {
		storedControls = Key.callbacks;
		Key.callbacks.clear();

		closeCallback = resetControls;

		super.create();
	}

	inline function resetControls() Key.callbacks = storedControls;

	override function update(elapsed:Float) {super.update(elapsed);}
}