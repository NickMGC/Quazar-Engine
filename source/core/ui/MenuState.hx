package core.ui;

@:publicFields class MenuState extends FlxState {
	override function create() {
		persistentUpdate = persistentDraw = true;
		blockControls = false;

		if(!TransitionState.skipNextTransOut) {
			FlxG.state.openSubState(new Transition());
			Transition.finish = closeSubState;
		}

		TransitionState.skipNextTransOut = false;

		super.create();

		Path.clearUnusedMemory();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
	}

	override function startOutro(onOutroComplete:() -> Void) {
		if (TransitionState.skipNextTransIn) {
			TransitionState.skipNextTransIn = false;
			return super.startOutro(onOutroComplete);
		}

		FlxG.state.openSubState(new Transition(true));
		Transition.finish = onOutroComplete;
	}

	static function getState():MenuState return cast FlxG.state;
}