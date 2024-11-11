package objects;

//taken from psych because my monkey brain doesnt know how to make it any better
@:publicFields class Option {
	public var child:Alphabet;
	public var text(get, set):String;

	var onChange:Void->Void = null;

	var curOption = 0;

	var name = 'Unknown';
	var desc = '';

	private var variable:String = null;

	var type = 'bool';

	var options:Array<String> = null; //string only
	var defaultValue:Dynamic = null;

	//float/percent
	var displayFormat = '%v';
	var changeValue:Dynamic = 1;
	var minValue:Dynamic = null;
	var maxValue:Dynamic = null;
	var scrollSpeed = 50.;
	var decimals = 1;

    function new(name:String, ?desc:String, ?variable:String, ?type = 'bool', ?options:Array<String> = null) {
        this.name = name;
        this.desc = desc;
        this.variable = variable;
        this.type = type;
		this.options = options;

        this.defaultValue = getValue();

        switch(type) {
			case 'bool':
				if(defaultValue == null) defaultValue = false;
			case 'int' | 'float':
				if(defaultValue == null) defaultValue = 0;
			case 'percent':
				if(defaultValue == null) defaultValue = 1;
				displayFormat = '%v%';
				changeValue = .01;
				minValue = 0;
				maxValue = 1;
				scrollSpeed = .5;
				decimals = 2;
			case 'string':
				if(defaultValue == null) defaultValue = '';
				if(options.length > 0) defaultValue = options[0];
		}

        try {
            if(getValue() == null) setValue(defaultValue);

            if (type == 'string') {
                var num = options.indexOf(getValue());
                if(num > -1) curOption = num;
            }
        } catch(e) {}
    }

    inline function change() if(onChange != null) onChange();

    dynamic function getValue():Dynamic return Reflect.getProperty(Data, variable);
	dynamic function setValue(value:Dynamic) return Reflect.setProperty(Data, variable, value);

	function addProperties(?changeValue:Dynamic = 1, ?minValue:Dynamic, ?maxValue:Dynamic, ?scrollSpeed = 50., ?decimals = 1):Option {
		this.changeValue = changeValue;
		this.minValue = minValue;
		this.maxValue = maxValue;
		this.scrollSpeed = scrollSpeed;
		this.decimals = decimals;

		return this;
	}

	private function get_text() return child.text ?? null;

	private function set_text(newValue = '') {
		if(child != null) child.text = newValue;
		return null;
	}
}