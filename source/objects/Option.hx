package objects;

import flixel.util.typeLimit.NextState;

class Option {
    public final name:String;
    public final desc:String;
    var data:OptionValue;

    public var type(get, never):String;
    public var value(get, never):String;

    public var categoryIndex:Int;

    public function new(name:String, desc:String, data:OptionValue) {
        this.name = name;
        this.desc = desc;
        this.data = data;
    }

    public function updateValue(dir:Int = 0):Void data = switch data {
        case BOOL(value, callback):
            callback(value = !value);
            BOOL(value, callback);

        case INT(value, min, max, step, callback):
            callback(value = Std.int(FlxMath.bound(value + dir * step, min, max)));
            INT(value, min, max, step, callback);

        case FLOAT(value, min, max, step, decimals, callback):
            callback(value = FlxMath.roundDecimal(FlxMath.bound(value + dir * step, min, max), decimals));
            FLOAT(value, min, max, step, decimals, callback);

        case PERCENT(value, callback):
            callback(value = FlxMath.roundDecimal(FlxMath.bound(value + dir * 0.01, 0, 1), 2));
            PERCENT(value, callback);

        case STRING(value, options, callback):
            callback(value = options[(options.indexOf(value) + dir + options.length) % options.length]);
            STRING(value, options, callback);

        case STATE(value):
            Controls.block = true;
            switchState(value);
            STATE(value);
    }

    private function get_value():String return switch data {
        case BOOL(v, _): '$v';
        case INT(v, _, _, _, _): '$v';
        case FLOAT(v, _, _, _, _, _): '$v';
        case PERCENT(v, _): '${v * 100}%';
        case STRING(v, _, _): v;
        case STATE(_): '';
    }

    private function get_type():String return switch data {
        case BOOL(_, _): 'bool';
        case INT(_, _, _, _, _): 'int';
        case FLOAT(_, _, _, _, _, _): 'float';
        case PERCENT(_, _): 'percent';
        case STRING(_, _, _): 'string';
        case STATE(_): 'state';
    }

    public static function bool(name:String, desc:String, value:Bool, callback:Bool -> Void):Option
        return new Option(name, desc, BOOL(value, callback));

    public static function int(name:String, desc:String, value:Int, callback:Int -> Void, step:Int = 1, ?min:Int, ?max:Int):Option
        return new Option(name, desc, INT(value, min, max, step, callback));

    public static function float(name:String, desc:String, value:Float, callback:Float -> Void, step:Float = 0.1, decimals:Int = 2, ?min:Float, ?max:Float):Option
        return new Option(name, desc, FLOAT(value, min, max, step, decimals, callback));

    public static function percent(name:String, desc:String, value:Float, callback:Float -> Void):Option
        return new Option(name, desc, PERCENT(value, callback));

    public static function string(name:String, desc:String, value:String, options:Array<String>, callback:String -> Void):Option
        return new Option(name, desc, STRING(value, options, callback));

    public static function state(name:String, desc:String, value:NextState):Option
        return new Option(name, desc, STATE(value));
}

class OptionCategory {
    public var name:String;
    public var options:Array<Option>;

    public function new(name:String, options:Array<Option>) {
        this.name = name;
        this.options = options;
    }
}

enum OptionValue {
    BOOL(value:Bool, callback:Bool -> Void);
    INT(value:Int, min:Int, max:Int, step:Int, callback:Int -> Void);
    FLOAT(value:Float, min:Float, max:Float, step:Float, decimals:Int, callback:Float -> Void);
    PERCENT(value:Float, callback:Float -> Void);
    STRING(value:String, options:Array<String>, callback:String -> Void);
    STATE(state:NextState);
}

class DisplayOption extends FlxSpriteGroup {
    public var option:Option;

    public var label:Alphabet;
    public var value:Alphabet;

    public var checkbox:FlxSprite;

    public function new(option:Option, y:Float = 0, id:Int) {
        super(0, y);

        this.setID(id).option = option;

        add(label = new Alphabet(135, 0, option.name, 0.7, false));

        switch option.type {
            case 'bool':
                add(checkbox = Sparrow('options/checkbox', 1110, -2).addPrefix('true', 'true', 0, false).addPrefix('false', 'false', 0, false).playAnim(option.value));
            case 'float' | 'int' | 'percent' | 'string':
                add(value = new Alphabet(795, 0, option.value, 0.7, false).setAlign(RIGHT, 500));
        }
    }

    public function updateValue():Void switch option.type {
        case 'bool':
            checkbox.playAnim(option.value);
        case 'float' | 'int' | 'percent' | 'string':
            value.text = option.value;
    }

    public function setSelected(selected:Bool):Void label.alpha = selected ? 1 : 0.6;
}