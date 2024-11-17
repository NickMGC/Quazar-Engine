package core;

import openfl.events.KeyboardEvent;

@:publicFields class Controls {
    static var callbacks:Map<String, Map<Int, FlxSignal>> = ['p' => [], 'h' => [], 'r' => []];

    static var justPressed = false;
    static var blockControls = true;

    static function resetCallbacks() return for (i in ['p', 'h', 'r']) callbacks[i].clear();

    static function keyDown(event:KeyboardEvent) {
        if (blockControls) return;

        if (!justPressed) {
            if (callbacks['p'].exists(event.keyCode)) callbacks['p'][event.keyCode].dispatch();
            justPressed = true;
        }

        if (callbacks['h'].exists(event.keyCode)) callbacks['h'][event.keyCode].dispatch();
    }

    static function keyUp(event:KeyboardEvent) {
        if (blockControls) return;

        justPressed = false;
        if (callbacks['r'].exists(event.keyCode)) callbacks['r'][event.keyCode].dispatch();
    }

    static function init() {
        FlxG.signals.preStateSwitch.add(resetCallbacks);
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
    }

    static function check(type:String, keys:Array<Int>, callback:Void -> Void) {
        for (key in keys) {
            if (!callbacks[type].exists(key)) callbacks[type].set(key, new FlxSignal());
            callbacks[type][key].add(callback);
        }
    }

    inline static function onPress  (keys:Array<Int>, callback:Void -> Void) check('p', keys, callback);
    inline static function onHold   (keys:Array<Int>, callback:Void -> Void) check('h', keys, callback);
    inline static function onRelease(keys:Array<Int>, callback:Void -> Void) check('r', keys, callback);
}