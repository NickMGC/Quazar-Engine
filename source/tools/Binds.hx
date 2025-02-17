package tools;

//There's probably a better way of doing this but eh.
class Binds {
    //UI
    public static var accept(get, never):Array<Int>;
    public static var back(get, never):Array<Int>;
    public static var pause(get, never):Array<Int>;
    public static var reset(get, never):Array<Int>;

    private static function get_accept() return Data.keyBinds['accept'];
    private static function get_back() return Data.keyBinds['back'];
    private static function get_pause() return Data.keyBinds['pause'];
    private static function get_reset() return Data.keyBinds['reset'];

    public static var left(get, never):Array<Int>;
    public static var down(get, never):Array<Int>;
    public static var up(get, never):Array<Int>;
    public static var right(get, never):Array<Int>;

    private static function get_left() return Data.keyBinds['left'];
    private static function get_down() return Data.keyBinds['down'];
    private static function get_up() return Data.keyBinds['up'];
    private static function get_right() return Data.keyBinds['right'];

    //Notes
    public static var left_note(get, never):Array<Int>;
    public static var down_note(get, never):Array<Int>;
    public static var up_note(get, never):Array<Int>;
    public static var right_note(get, never):Array<Int>;

    private static function get_left_note() return Data.keyBinds['left_note'];
    private static function get_down_note() return Data.keyBinds['down_note'];
    private static function get_up_note() return Data.keyBinds['right_note'];
    private static function get_right_note() return Data.keyBinds['right_note'];

    inline public static function onPress(key:Array<Int>, callback:Void -> Void) Controls.bind('press', key, callback);
    inline public static function onHold(key:Array<Int>, callback:Void -> Void) Controls.bind('hold', key, callback);
    inline public static function onRelease(key:Array<Int>, callback:Void -> Void) Controls.bind('release', key, callback);
}