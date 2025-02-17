package objects.core;

class Note extends NoteSprite {
    public static final notes = ['left', 'down', 'up', 'right'];

    public var time:Float = 0;
    public var length:Float = 0;
    public var index:Int = 0;

    public var type:String = '';

    public var holding:Bool = false;
	public var hittable:Bool = true;

    public var sustain:Sustain;
    public var parent:StrumNote;

    public function setup(json:NoteData, line:StrumLine) {
        index = json.index ?? 0;
        length = json.length ?? 0;
        time = json.time ?? 0;

        type = json.type ?? '';

        holding = false;
		hittable = visible = true;

        return this;
    }
}