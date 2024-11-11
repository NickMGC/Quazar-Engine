package testing;

class AlphabetAlign extends MenuState {
    override function create() {
        persistentUpdate = persistentDraw = true;

        FlxG.camera.bgColor = 0xFF999999;

        add(new Alphabet(308, 200, 'ABCDEFGHIJKLM 01234567890', 0.6, false, CENTER));
        add(new Alphabet(221, 400, 'abcdefghijklm 01234567890', 0.6, CENTER));

        Key.onPress(Data.keyBinds['back'], () -> {
            Key.blockControls = true;
            FlxG.sound.play(Path.sound('cancelMenu'), 0.7);
            MenuState.switchState(new states.MainMenuState());
        });

        super.create();
    }
}