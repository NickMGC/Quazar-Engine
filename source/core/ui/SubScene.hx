package core.ui;

class SubScene extends FlxSubState {
    var storedControls:Map<String, Map<Int, Array<Void -> Void>>> = [];

    override function create() {
        for (i in ['press', 'hold', 'release']) {
            storedControls[i] = Controls.callbacks[i].copy();
            Controls.callbacks[i].clear();
        }

		closeCallback = restoreControls;

        super.create();
    }

    function restoreControls() for (i in ['press', 'hold', 'release']) {
        Controls.callbacks[i].clear();
        Controls.callbacks[i] = storedControls[i].copy();
    }
}