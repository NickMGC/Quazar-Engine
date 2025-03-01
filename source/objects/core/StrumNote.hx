package objects.core;

class StrumNote extends NoteSprite {
	public var line:StrumLine;
	public var index:Int = 0;

	public function new(line:StrumLine, index:Int = 0) {
		super(index);

		this.line = line;
		this.index = index;

		this.playAnim('static').updateHitbox();
	}
}