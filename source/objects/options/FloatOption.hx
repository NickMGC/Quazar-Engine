package objects.options;

class FloatOption extends BaseOption<Float> {
    public var min:Float;
    public var max:Float;

    public var step:Float = 0.1;
    public var decimals:Int = 2;

    public function new(name:String, desc:String, value:Float, callback:Float -> Void) {
        super(name, desc, value, callback, 'float');
    }

    override public function updateValue(dir:Int = 0):Void {
        callback(_value = FlxMath.roundDecimal(Util.bound(_value + dir * step, min, max), decimals));
    }

    public function setDecimals(decimals:Int):Option {
        this.decimals = decimals;
        return this;
    }
 
    public function setStep(step:Float):Option {
        this.step = step;
        return this;
    }

    public function bound(min:Float, max:Float):Option {
        this.min = min;
        this.max = max;
        return this;
    }
}