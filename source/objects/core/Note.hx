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

        final dir = notes[index % 4];

        Sparrow('game/noteSkins/notes');

		this.addPrefix(dir, '${dir}0', 24, false).playAnim(dir);
        updateHitbox();
    }
}