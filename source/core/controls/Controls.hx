package core.controls;

import openfl.events.KeyboardEvent;

@:publicFields class Controls {
    static var callbacks:Map<String, Map<Int, FlxSignal>> = ['press' => [], 'hold' => [], 'release' => []];
    static var justPressedKeys:Map<Int, Bool> = [];

    static var blockControls = true;

    static function init() {
        FlxG.signals.preStateSwitch.add(() -> {
            for (i in ['press', 'hold', 'release']) callbacks[i].clear();
            justPressedKeys.clear();
        });

        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, event -> {
            if (blockControls) return;

            if (!justPressedKeys[event.keyCode]) {
                if (event.keyCode == 122) FlxG.fullscreen = !FlxG.fullscreen;

                callbacks['press'][event.keyCode]?.dispatch();
                justPressedKeys[event.keyCode] = true;
            }

            callbacks['hold'][event.keyCode]?.dispatch();
        });

        FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, event -> {
            justPressedKeys[event.keyCode] = false;
            if (!blockControls) callbacks['release'][event.keyCode]?.dispatch();
        });
    }

    @:noCompletion static function bind(type:String, keys:Array<Int>, callback:Void -> Void) for (key in keys) {
        if (!callbacks[type].exists(key)) callbacks[type][key] = new FlxSignal();
        callbacks[type][key].add(callback);
    }
}