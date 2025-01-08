package objects.options;

//havent tested if it works or not,, will prolly switch to this when i wont be lazy
@:publicFields class Option<T> {
    var name:String;
    var desc:String;

    var value(default, set):T;
    var onChange:T->Void;

    var minValue:Float;
    var maxValue:Float;

    var changeValue:Float = 1;
    var decimals:Int = 1;

    var child:Alphabet;

    function new(name:String, desc:String, value:T, ?onChange:T->Void) {
        this.name = name;
        this.desc = desc;

        this.value = value;
        this.onChange = onChange;
    }

    function setDecimals<T:Option>(option:T, value:Int):T {
        decimals = value;
        return option;
    }

    function setChangeValue<T:Option>(option:T, value:Float):T {
        changeValue = value;
        return option;
    }

    function bound<T:Option>(option:T, min:Float, max:Float):T {
        minValue = min;
        maxValue = max;
        return option;
    }

    private function set_value(newValue:T):T {
        if (onChange != null) onChange(newValue);
        return this.value = newValue;
    }
}