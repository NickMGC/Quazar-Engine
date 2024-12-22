package objects.core;

@:publicFields class StrumNote extends NoteSprite {
    var index = 0;
    var line:StrumLine;

    function new(index = 0, line:StrumLine) {
        super(index);

        this.index = index;
        this.line = line;

        this.playAnim('static').updateHitbox();
    }
}