package objects.options;

import flixel.util.typeLimit.NextState;

class Option {
    public final name:String;
    public final desc:String;
    public final type:String;

	public var value(get, default):String;

    public function new(name:String, desc:String = '', ?type:String) {
        this.name = name;
        this.desc = desc;
        this.type = type;
    }

    public function updateValue(dir:Int = 0):Void {}

	function get_value():String {
        return value;
    }

	public static function bool(name:String, desc:String, value:Bool, callback:Bool -> Void):BoolOption {
		return new BoolOption(name, desc, value, callback);
	}

	public static function int(name:String, desc:String, value:Int, callback:Int -> Void):IntOption {
		return new IntOption(name, desc, value, callback);
	}

	public static function float(name:String, desc:String, value:Float, callback:Float -> Void):FloatOption {
		return new FloatOption(name, desc, value, callback);
	}

	public static function percent(name:String, desc:String, value:Float, callback:Float -> Void):PercentOption {
		return new PercentOption(name, desc, value, callback);
	}

	public static function string(name:String, desc:String, value:String, options:Array<String>, callback:String -> Void):StringOption {
		return new StringOption(name, desc, value, options, callback);
	}

	public static function state(name:String, desc:String, value:NextState):StateOption {
		return new StateOption(name, desc, value);
	}
}

class BaseOption<T> extends Option {
    public var callback:T -> Void;
    var _value:T;

    public function new(name:String, desc:String, _value:T, callback:T -> Void, type:String) {
        super(name, desc, type);

        this.callback = callback;
        this._value = _value;
    }

    override function get_value():String {
        return '$_value';
    }
}

class OptionCategory {
	public var name:String;
	public var options:Array<Option>;
	public var length:Float;

	public function new(name:String, options:Array<Option>) {
		this.name = name;
		this.options = options;
	}
}

class DisplayOption extends FlxSpriteGroup {
	public var option:Option;

	public var label:Alphabet;
	public var value:Alphabet;

	public var checkbox:FlxSprite;

	public var index:Int;

	public function new(option:Option, y:Float = 0, id:Int, index:Int) {
		super(0, y);

		this.option = option;
		this.ID = id;
		this.index = index;

		add(label = new Alphabet(135, 0, option.name, 0.7, false));

		switch option.type {
			case 'bool':
				add(checkbox = Sparrow('ui/options/checkbox', 1110, -2).addPrefix('true', 'true', 0, false).addPrefix('false', 'false', 0, false).playAnim(option.value));
			case 'float' | 'int' | 'percent' | 'string':
				add(value = new Alphabet(795, 0, option.value, 0.7, false).setAlign(RIGHT, 500));
		}
	}

	public function updateValue():Void {
		switch option.type {
			case 'bool':
				checkbox.playAnim(option.value);
			case 'float' | 'int' | 'percent' | 'string':
				value.text = option.value;
		}
	}
}