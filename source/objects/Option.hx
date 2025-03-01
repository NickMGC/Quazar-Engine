package objects;

import flixel.util.typeLimit.NextState;

class Option {
	public var data:OptionValue;

	public var value(get, never):String;
	public var type:String;

	public final name:String;
	public final desc:String;

	public function new(name:String, desc:String, data:OptionValue, type:String) {
		this.name = name;
		this.desc = desc;
		this.data = data;
		this.type = type;
	}

	public function updateValue(dir:Int = 0):Void {
		data = switch data {
			case BOOL(value, callback):
				callback(value = !value);
				BOOL(value, callback);

			case INT(value, min, max, step, callback):
				callback(value = Util.boundInt(value + dir * step, min, max));
				INT(value, min, max, step, callback);

			case FLOAT(value, min, max, step, decimals, callback):
				callback(value = FlxMath.roundDecimal(Util.bound(value + dir * step, min, max), decimals));
				FLOAT(value, min, max, step, decimals, callback);

			case STRING(value, options, callback):
				callback(value = options[(options.indexOf(value) + dir + options.length) % options.length]);
				STRING(value, options, callback);

			case STATE(value):
				Controls.block = true;
				switchState(value);
				STATE(value);
		}
	}

	public static function bool(name:String, desc:String, value:Bool, callback:Bool -> Void):Option {
		return new Option(name, desc, BOOL(value, callback), 'bool');
	}

	public static function int(name:String, desc:String, value:Int, callback:Int -> Void, step:Int = 1, ?min:Int, ?max:Int):Option {
		return new Option(name, desc, INT(value, min, max, step, callback), 'int');
	}

	public static function float(name:String, desc:String, value:Float, callback:Float -> Void, step:Float = 0.1, decimals:Int = 2, ?min:Float, ?max:Float):Option {
		return new Option(name, desc, FLOAT(value, min, max, step, decimals, callback), 'float');
	}

	public static function percent(name:String, desc:String, value:Float, callback:Float -> Void):Option {
		return new Option(name, desc, FLOAT(value, 0, 1, 0.01, 2, callback), 'percent');
	}

	public static function string(name:String, desc:String, value:String, options:Array<String>, callback:String -> Void):Option {
		return new Option(name, desc, STRING(value, options, callback), 'string');
	}

	public static function state(name:String, desc:String, value:NextState):Option {
		return new Option(name, desc, STATE(value), 'state');
	}

	private function get_value():String {
		return switch data {
			case BOOL(v, _): '$v';
			case INT(v, _, _, _, _): '$v';
			case FLOAT(v, _, _, _, _, _): type == 'percent' ? '${v * 100}%' : '$v';
			case STRING(v, _, _): v;
			case STATE(v): '$v';
		}
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

	public function updateValue():Void switch option.type {
		case 'bool':
			checkbox.playAnim(option.value);
		case 'float' | 'int' | 'percent' | 'string':
			value.text = option.value;
	}
}

enum OptionValue {
	BOOL(value:Bool, callback:Bool -> Void);
	INT(value:Int, min:Int, max:Int, step:Int, callback:Int -> Void);
	FLOAT(value:Float, min:Float, max:Float, step:Float, decimals:Int, callback:Float -> Void);
	STRING(value:String, options:Array<String>, callback:String -> Void);
	STATE(state:NextState);
}