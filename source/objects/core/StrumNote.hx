package objects.core;

class StrumNote extends NoteSprite {
    public var index:Int = 0;
    public var line:StrumLine;

    public function new(index:Int = 0, line:StrumLine) {
        super(index);

        this.index = index;
        this.line = line;

        this.playAnim('static').updateHitbox();
    }
}