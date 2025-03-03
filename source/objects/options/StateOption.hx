package objects.options;

class StateOption extends Option {
    var _value:NextState;

    public function new(name:String, desc:String, _value:NextState) {
        super(name, desc, 'state');
        this._value = _value;
    }

    override public function updateValue(dir:Int = 0):Void {
        Controls.block = true;
        switchState(_value);
    }
}