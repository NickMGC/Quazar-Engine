package states.options;

class DelayState extends MenuState {
    override function create() {
        trace('delay opened');

        FlxG.sound.playMusic(Path.music('songOffset'), .0);
        FlxG.sound.music.fadeIn(.1, 0, .5);

        Key.onPress(Data.keyBinds['back'], () -> {
            MenuState.switchState(new OptionsState());
            FlxG.sound.music.stop();
        });

        super.create();
    }
}