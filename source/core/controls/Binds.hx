package core.controls;

@:publicFields class Binds {
    //UI
    static var accept(get, never):Array<Int>;
    static var back(get, never):Array<Int>;
    static var pause(get, never):Array<Int>;
    static var reset(get, never):Array<Int>;

    private static function get_accept() return Data.keyBinds['accept'];
    private static function get_back() return Data.keyBinds['back'];
    private static function get_pause() return Data.keyBinds['pause'];
    private static function get_reset() return Data.keyBinds['reset'];

    static var left(get, never):Array<Int>;
    static var down(get, never):Array<Int>;
    static var up(get, never):Array<Int>;
    static var right(get, never):Array<Int>;

    private static function get_left() return Data.keyBinds['left'];
    private static function get_down() return Data.keyBinds['down'];
    private static function get_up() return Data.keyBinds['up'];
    private static function get_right() return Data.keyBinds['right'];

    //Notes
    static var left_note(get, never):Array<Int>;
    static var down_note(get, never):Array<Int>;
    static var up_note(get, never):Array<Int>;
    static var right_note(get, never):Array<Int>;

    private static function get_left_note() return Data.keyBinds['left_note'];
    private static function get_down_note() return Data.keyBinds['down_note'];
    private static function get_up_note() return Data.keyBinds['right_note'];
    private static function get_right_note() return Data.keyBinds['right_note'];
}