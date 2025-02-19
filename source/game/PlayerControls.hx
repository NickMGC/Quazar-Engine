package game;

import game.PlayScene.instance as game;

class PlayerControls {
    public static function init() {
        for (i => direction in Note.notes) {
            final note:StrumNote = game.playField.playerStrums.strums[i];

            final key:Array<Int> = Data.keyBinds['${direction}_note'];

            Key.onPress(key, () -> keyHit(note));
            Key.onRelease(key, () -> keyRelease(note));
        }

        Key.onPress(Key.accept, onAccept);
    }

    inline static function onAccept() game.openSubState(new PauseMenu());

    static function keyRelease(note:StrumNote) {
        note.playAnim('static');
    }

    static function keyHit(note:StrumNote) {
        if (note?.animation.curAnim.name != 'confirm') {
            note.playAnim('press');
            game.playField.spawnSplash(note);
        }
    }
}