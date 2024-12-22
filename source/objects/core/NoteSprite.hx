package objects.core;

class NoteSprite extends FlxSprite {
	public function new(index = 0) {
		super();

        final dir = Note.notes[index];

        this.loadFrames('game/noteSkins/notes');

        this.addPrefix('static', '$dir static0', 24).addPrefix(dir, dir, 24);
        for (item in ['press', 'confirm']) this.addPrefix(item, '$dir ${item}0', 24, false);

        this.setScale(.7).playAnim(dir).updateHitbox();
	}
}