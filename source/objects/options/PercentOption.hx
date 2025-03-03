package objects.options;

class PercentOption extends BaseOption<Float> {
    public function new(name:String, desc:String, value:Float, callback:Float -> Void) {
        super(name, desc, value, callback, 'percent');
    }

    override public function updateValue(dir:Int = 0):Void {
        callback(_value = FlxMath.roundDecimal(Util.bound(_value + dir * 0.01, 0, 1), 2));
    }
}