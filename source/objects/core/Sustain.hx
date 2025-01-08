package objects.core;

@:publicFields class Sustain extends FlxSpriteGroup {
    function new(index = 0) {
        super();

        final dir = Note.notes[index];

        final sustain = Sparrow('game/noteSkins/notes').addPrefix('$dir hold', '${dir} hold0', 24).playAnim(dir);
        sustain.antialiasing = false;
        add(sustain);

        add(Sparrow(0, sustain.y + sustain.height - 1, 'game/noteSkins/notes')
        .addPrefix('$dir end', '${dir} end0', 24).playAnim(dir).setOrigin().setOffset());
    }
}