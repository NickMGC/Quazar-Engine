package objects.core;

class NoteSprite extends FlxSprite {
	public function new(index:Int = 0) {
		super();

		final dir = Note.notes[index];

		this.loadSparrowFrames('game/noteSkins/notes').addPrefix('static', '$dir static0', 24).addPrefix(dir, dir, 24);
		for (item in ['press', 'confirm']) this.addPrefix(item, '$dir ${item}0', 24, false);

		this.setScale(0.7).playAnim(dir).updateHitbox();
	}
}