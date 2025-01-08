package core.controls;

import states.PlayState.instance as game;

@:publicFields class PlayerControls {
    static function init() {
        for (i => dir in Note.notes) {
            final note = game.playerStrums.strums[i];

            var key = Data.keyBinds['${dir}_note'];

            onPress(key, if (note.animation.curAnim.name != 'confirm' && note != null) {
                note.playAnim('press');
                game.spawnSplash(note);
            });

            onRelease(key, note.playAnim('static'));
        }

        onPress(Key.accept, game.openSubState(new PauseSubState()));
    }
}