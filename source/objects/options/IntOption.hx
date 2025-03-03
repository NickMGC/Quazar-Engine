package objects.options;

class IntOption extends BaseOption<Int> {
    public var min:Int;
    public var max:Int;

    public var step:Int = 1;

    public function new(name:String, desc:String, value:Int, callback:Int -> Void) {
        super(name, desc, value, callback, 'int');
    }

    override public function updateValue(dir:Int = 0):Void {
        callback(_value = Util.boundInt(_value + dir * step, min, max));
    }

    public function setStep(step:Int):Option {
        this.step = step;
        return this;
    }

    public function bound(min:Int, max:Int):Option {
        this.min = min;
        this.max = max;
        return this;
    }
}