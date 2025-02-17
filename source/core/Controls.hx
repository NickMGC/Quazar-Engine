package core;

import openfl.events.KeyboardEvent;

class Controls {
    @:noCompletion public static var callbacks:Map<String, Map<Int, Array<Void -> Void>>> = ['press' => [], 'hold' => [], 'release' => []];
    @:noCompletion public static var justPressedKeys:Map<Int, Bool> = [];

    public static var block:Bool = true;

    public static function init() {
        FlxG.signals.preStateSwitch.add(reset); 

        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
        FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
    }

    static function reset() {
        for (type in ['press', 'hold', 'release']) for (key in callbacks[type].keys()) callbacks[type][key] = [];
        justPressedKeys.clear();
    }

    static function keyPressed(event:KeyboardEvent) {
        if (block) return;

        checkKeyPress(event.keyCode);
        checkKey(event.keyCode, 'hold');
    }

    static function keyReleased(event:KeyboardEvent) {
        justPressedKeys[event.keyCode] = false;
        if (block) return;

        checkKey(event.keyCode, 'release');
    }

    private static function checkKeyPress(key:Int) {
        checkFullscreen(key);

        if (!callbacks['press'].exists(key) || justPressedKeys[key]) return;

        for (callback in callbacks['press'][key]) callback();
        justPressedKeys[key] = true;
    }

    private static function checkKey(key:Int, type:String) {
        if (!callbacks[type].exists(key)) return;
        for (callback in callbacks[type][key]) callback();
    }

    private static function checkFullscreen(key:Int) {
        if (key != 122) return;

        FlxG.fullscreen = !FlxG.fullscreen;
        if (FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
    }

    @:noCompletion public static function bind(type:String, keys:Array<Int>, callback:Void -> Void) for (key in keys) {
        if (!callbacks[type].exists(key)) callbacks[type][key] = [];
        callbacks[type][key].push(callback);
    }
}