package objects.core;

class Sustain extends FlxSpriteGroup {
    public function new(index:Int = 0) {
        super();

        final dir = Note.notes[index];

        final sustain = Sparrow('game/noteSkins/notes');
        sustain.addPrefix('$dir hold', '$dir hold0', 24).playAnim(dir).setAntialiasing(false);
        add(sustain);

        final sustainEnd = Sparrow('game/noteSkins/notes', 0, sustain.y + sustain.height - 1);
        sustainEnd.addPrefix('$dir end', '$dir end0', 24).playAnim(dir).setOrigin().setOffset();
        add(sustainEnd);
    }
}