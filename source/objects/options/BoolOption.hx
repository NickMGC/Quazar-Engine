package objects.options;

class BoolOption extends BaseOption<Bool> {
    public function new(name:String, desc:String, value:Bool, callback:Bool -> Void) {
        super(name, desc, value, callback, 'bool');
    }

    override public function updateValue(dir:Int = 0):Void {
        callback(_value = !_value);
    }
}