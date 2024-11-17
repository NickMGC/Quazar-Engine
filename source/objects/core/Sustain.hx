package objects.core;

enum RenderType {
    STRETCH;
    TILE;
}

@:publicFields class Sustain extends FlxTypedSpriteGroup<QuazarSpr> {
    private static var animArray = [{name: 'left hold', prefix: 'left hold0', fps: 24, loop: false}, {name: 'left end', prefix: 'left end0', fps: 24, loop: false}];

    function new(length = 0, ?render:RenderType = TILE) {
        super();

        switch (render) {
            case TILE: for (i in 0...Math.floor(length / 50)) add(createSustain(50 * i));
            case STRETCH: stretchedSustain();
        }

        final lastSus = members[members.length - 1];

        var end = new QuazarSpr('game/noteSkins/notes', 0, render == TILE ? (lastSus.y + lastSus.height) : lastSus.height, animArray);
        end.animation.play('left end');
        end.animation.finish();
        end.active = false;
        add(end);
    }

    private function createSustain(y:Float = 0) {
        var sustain = new QuazarSpr('game/noteSkins/notes', 0, y, animArray);
        sustain.animation.play('left hold');
        sustain.animation.finish();
        sustain.updateHitbox();
        sustain.origin.set(0, 0);
        sustain.offset.set(0, 0);
        sustain.active = false;
        return sustain;
    }

    private function stretchedSustain() {
        var sustain = createSustain();
        sustain.antialiasing = false;
        sustain.scale.y = length / 50;
        add(sustain);
    }
}