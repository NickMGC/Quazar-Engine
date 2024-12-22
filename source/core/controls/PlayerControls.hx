package core.controls;

@:publicFields class PlayerControls {
    static function init() {
        for (i => dir in Note.notes) {
            final note = PlayState.instance.playerStrums.strums[i];
            onPress(Data.keyBinds['${dir}_note'], {
                if (note.animation.curAnim.name != 'confirm' && note != null) {
                    note.playAnim('press');
                    PlayState.instance.spawnSplash(note);
                }
            });

            onRelease(Data.keyBinds['${dir}_note'], note.playAnim('static'));
        }
    }
}