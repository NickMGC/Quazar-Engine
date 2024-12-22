package objects.core;

@:publicFields class Note extends NoteSprite {
    public static final notes = ['left', 'down', 'up', 'right'];

    var time:Float = .0;
    var length:Float = .0;
    var index:Int = 0;

    var type:String = '';

    var holding = false;
	var hittable = true;

    var sustain:Sustain;
    var parent:StrumNote;

    function setup(json:NoteData, line:StrumLine) {
        index = json.index ?? 0;
        length = json.length ?? 0;
        time = json.time ?? 0;

        type = json.type ?? '';

        holding = false;
		hittable = visible = true;

        return this;
    }
}