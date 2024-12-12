package core;

import openfl.events.KeyboardEvent;

@:publicFields class Controls {
    static var callbacks:Map<String, Map<Int, FlxSignal>> = ['press' => [], 'hold' => [], 'release' => []];

    static var justPressed = false;
    static var blockControls = true;

    static function init() {
        FlxG.signals.preStateSwitch.add(() -> for (i in ['press', 'hold', 'release']) callbacks[i].clear());

        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, event -> {
            if (!blockControls) {
                if (!justPressed) {
                    if (callbacks['press'].exists(event.keyCode)) callbacks['press'][event.keyCode].dispatch();
                    justPressed = true;
                }
        
                if (callbacks['hold'].exists(event.keyCode)) callbacks['hold'][event.keyCode].dispatch();   
            }
        });

        FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, event -> {
            justPressed = false;
            if (!blockControls && callbacks['release'].exists(event.keyCode)) callbacks['release'][event.keyCode].dispatch();
        });
    }

    static function check(type:String, keys:Array<Int>, callback:() -> Void) {
        for (key in keys) {
            if (!callbacks[type].exists(key)) callbacks[type].set(key, new FlxSignal());
            callbacks[type][key].add(callback);
        }
    }
}