package objects.options;

class StringOption extends BaseOption<String> {
    var options:Array<String> = [];

    public function new(name:String, desc:String, value:String, options:Array<String>, callback:String -> Void) {
        super(name, desc, value, callback, 'string');
        this.options = options;
    }

    override public function updateValue(dir:Int = 0):Void {
        callback(_value = options[(options.indexOf(_value) + dir + options.length) % options.length]);
    }
}