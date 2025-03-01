package tools;

//UI
var accept(get, never):Array<Int>;
var back(get, never):Array<Int>;
var pause(get, never):Array<Int>;
var reset(get, never):Array<Int>;

inline private function get_accept() return Data.keyBinds['accept'];
inline private function get_back() return Data.keyBinds['back'];
inline private function get_pause() return Data.keyBinds['pause'];
inline private function get_reset() return Data.keyBinds['reset'];

var left(get, never):Array<Int>;
var down(get, never):Array<Int>;
var up(get, never):Array<Int>;
var right(get, never):Array<Int>;

inline private function get_left() return Data.keyBinds['left'];
inline private function get_down() return Data.keyBinds['down'];
inline private function get_up() return Data.keyBinds['up'];
inline private function get_right() return Data.keyBinds['right'];

//Notes
var left_note(get, never):Array<Int>;
var down_note(get, never):Array<Int>;
var up_note(get, never):Array<Int>;
var right_note(get, never):Array<Int>;

inline private function get_left_note() return Data.keyBinds['left_note'];
inline private function get_down_note() return Data.keyBinds['down_note'];
inline private function get_up_note() return Data.keyBinds['right_note'];
inline private function get_right_note() return Data.keyBinds['right_note'];

inline function onPress(key:Array<Int>, callback:Void -> Void) Controls.bind('press', key, callback);
inline function onHold(key:Array<Int>, callback:Void -> Void) Controls.bind('hold', key, callback);
inline function onRelease(key:Array<Int>, callback:Void -> Void) Controls.bind('release', key, callback);