package objects.core;

@:publicFields class Note extends FlxSprite {
    public static final notes = ['left', 'down', 'up', 'right'];

    var time = .0;
    var length = .0;
    var index = 0;

    var type:String;

    var holding = false;
	var hittable = true;

    function new() {
        super();

        Sparrow('game/noteSkins/notes');
		this.addPrefix(Note.notes[index], '${Note.notes[index]}0', 24, false);
        this.playAnim(Note.notes[index]);
        updateHitbox();
    }
}