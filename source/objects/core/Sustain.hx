package objects.core;

enum RenderType {
    STRETCH;
    TILE;
}

@:publicFields class Sustain extends FlxSpriteGroup {
    var id = 0;
    var render = TILE;

    function new(index = 0, ?length = 0.) {
        super();

        id = index % 4;

        switch (render) {
            case TILE:
                for (i in 0...Math.floor(length / 50)) add(setup(55, (50 * i) + 138, 'hold')).scale.y = 1.02;
            case STRETCH:
                final sustain = setup(55, 138, 'hold');
                sustain.antialiasing = false;
                sustain.scale.y = length / 50;
                sustain.updateHitbox();
                sustain.setOrigin().setOffset();
                add(sustain);
        }

        final lastSus = members[members.length - 1];
        add(setup(55, lastSus.y + lastSus.height - 1, 'end'));
    }

    private function setup(x:Float = 0, y:Float = 0, postfix:String) {
        final dir = Note.notes[id] + ' $postfix';
        return Sparrow(x, y, 'game/noteSkins/notes').addPrefix(dir, '${dir}0', 24, false).playAnim(dir).setOrigin().setOffset();
    }
}