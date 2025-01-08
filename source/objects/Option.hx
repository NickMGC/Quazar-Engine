package objects;

@:publicFields class Option {
	var name:String;
	var desc:String;

	private var variable:String;
	var type:OptionType;

	var defaultValue:Dynamic;
	var onChange:Void -> Void;

	var curOption:Int = 0;

	//alphabet
	var child:Alphabet;
	var text(get, set):String;

	//float/percent
	var changeValue:Float = 1;
	var decimals:Int = 1;

	var minValue:Float;
	var maxValue:Float;

	var displayFormat = '%v';

    function new(name:String, ?desc:String, ?variable:String, ?type:OptionType) {
        this.name = name;
        this.desc = desc;
        this.variable = variable;
        this.type = type;

		if (type == null) return;

		defaultValue = switch(type) {
			case BOOL: false;
			case INT: 0;
			case FLOAT: .0;
			case PERCENT:
				displayFormat = '%v%';
				changeValue = .01;
				minValue = 0;
				maxValue = 1;
				decimals = 2;
				1.;
			case STRING(options):
				final num = options.indexOf(getValue());
                if(num > -1) curOption = num;
				options.length > 0 ? options[0] : '';
		}

		if (getValue() == null) setValue(defaultValue);
    }

    dynamic function getValue():Dynamic return Reflect.getProperty(Data, variable);
	dynamic function setValue(value:Dynamic) return Reflect.setProperty(Data, variable, value);

	function updateValue(huh = 0) {
        if (type == null) return;

		final holdValue = FlxMath.bound((getValue() + (huh * changeValue)), minValue, maxValue);

        setValue(switch(type) {
			case INT: Math.round(holdValue);
			case FLOAT | PERCENT: FlxMath.roundDecimal(holdValue, decimals);
			case STRING(options): options[(curOption = (curOption + huh + options.length) % options.length)];
			default: getValue();
		});

        updateText();
		if(onChange != null) onChange();
    }

    function updateText() {
		var val:Dynamic = getValue();
		if(type == PERCENT) val *= 100;

		text = displayFormat.replace('%v', val).replace('%d', defaultValue);
	}

	function addProperties(?changeValue:Float = 1, ?minValue:Float, ?maxValue:Float, ?decimals:Int = 1):Option {
		this.changeValue = changeValue;
		this.minValue = minValue;
		this.maxValue = maxValue;
		this.decimals = decimals;

		return this;
	}

	private function get_text() return child.text ?? null;

	private function set_text(newValue:String) {
		if(child != null) child.text = newValue;
		return null;
	}
}

enum OptionType {BOOL; INT; FLOAT; PERCENT; STRING(options:Array<String>);}