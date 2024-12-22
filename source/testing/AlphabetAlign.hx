package testing;

class AlphabetAlign extends MenuState {
    override function create() {
        bgColor = 0xFF999999;

        add(new Alphabet(308, 200, 'ABCDEFGHIJKLM 01234567890', 0.6, false, CENTER));
        add(new Alphabet(221, 400, 'abcdefghijklm 01234567890', 0.6, CENTER));

        onPress(back, {
            blockControls = true;
            playSound('cancelMenu', .6);
            switchState(states.MainMenuState.new);
        });

        super.create();
    }
}