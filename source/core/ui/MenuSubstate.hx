package core.ui;

class MenuSubstate extends FlxSubState {
    var storedControls:Map<String, Map<Int, FlxSignal>> = [];

    override function create() {
        for (i in ['press', 'hold', 'release']) {
            storedControls[i] = Controls.callbacks[i].copy();
            Controls.callbacks[i].clear();
        }

		closeCallback = () -> for (i in ['press', 'hold', 'release']) {
			Controls.callbacks[i].clear();
			Controls.callbacks[i] = storedControls[i].copy();
		};

        super.create();
    }

    override function update(elapsed:Float) super.update(elapsed);
}