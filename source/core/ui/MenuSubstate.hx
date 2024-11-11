package core.ui;

class MenuSubstate extends FlxSubState {
	private var storedControls:Map<String, Map<Int, FlxSignal>>;

	override function create() {
		storedControls = Key.callbacks;
		Key.callbacks.clear();

		closeCallback = () -> Key.callbacks = storedControls;

		super.create();
	}

	override function update(elapsed:Float) {super.update(elapsed);}
}