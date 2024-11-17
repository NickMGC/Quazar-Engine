package objects.core;

//ngl i got no idea to make it rn, ill leave it for tomorrow i guess
class Note extends FlxSprite {
    var anims = ['left', 'down', 'up', 'right'];

	public function new(index = 0) {
		super();

		frames = Path.sparrow('images/game/noteSkins/notes');
        //strum
        animation.addByPrefix('${anims[index]} static',  '${anims[index]} static0',  24);
        animation.addByPrefix('${anims[index]} press',   '${anims[index]} press0',   24, false);
        animation.addByPrefix('${anims[index]} confirm', '${anims[index]} confirm0', 24, false);

        //note
        animation.addByPrefix(anims[index],           '${anims[index]}0',      24);
        animation.addByPrefix('${anims[index]} hold', '${anims[index]} hold0', 24);
        animation.addByPrefix('${anims[index]} end',  '${anims[index]} end0',  24);
        animation.play(anims[index]);
	}
}