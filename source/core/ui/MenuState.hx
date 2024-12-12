package core.ui;

@:publicFields class MenuState extends flixel.addons.ui.FlxUIState {
	override function create() {
		persistentUpdate = persistentDraw = true;
		Key.blockControls = false;

		if(!FlxTransitionableState.skipNextTransOut) {
			FlxG.state.openSubState(new Transition());
			Transition.finish = closeSubState;
		}

		FlxTransitionableState.skipNextTransOut = false;

		super.create();

		Path.clearUnusedMemory();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
	}

	static function switchState(?nextState:FlxState) {
		if(nextState == null) {
			FlxG.resetState();
			FlxTransitionableState.skipNextTransIn = false;
			return;
		}
		
		FlxTransitionableState.skipNextTransIn ? FlxG.switchState(nextState) : startTransition(nextState);
		FlxTransitionableState.skipNextTransIn = false;
	}

	static function startTransition(?nextState:FlxState) {
		if(nextState == null) return;

		FlxG.state.openSubState(new Transition(true));
		Transition.finish = () -> nextState == FlxG.state ? FlxG.resetState() : FlxG.switchState(nextState);
	}

	static function getState():MenuState return cast FlxG.state;
}