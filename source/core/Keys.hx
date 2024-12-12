package core;

@:publicFields class Keys {
    inline static function onPress(keys:Array<Int>, callback:() -> Void) Controls.check('press', keys, callback);
    inline static function onHold(keys:Array<Int>, callback:() -> Void) Controls.check('hold', keys, callback);
    inline static function onRelease(keys:Array<Int>, callback:() -> Void) Controls.check('release', keys, callback);
}