package states;

class MainMenuState extends MenuState {
    static var curSelected = 0;

    static final options:Array<NextState> = [PlayState.new, FreeplayState.new, CreditsState.new, OptionsState.new];
    var menuItems:Array<FlxSprite> = [];

    override function create() {
        add(Sprite('menuBG'));

		for (i => item in ['storymode', 'freeplay', 'credits', 'options']) {
            final menu = Sparrow(0, (i * 140) + 90, 'mainmenu/buttons').addPrefix('idle', '$item idle0').addPrefix('selected', '$item selected0').playAnim('idle');
            menu.screenCenter(X);
            add(menu);
            menuItems.push(menu);
        }

        onPress(Key.accept, {
            blockControls = true;
            Sound.play(Path.sound('confirmMenu'), .7);
            FlxFlicker.flicker(menuItems[curSelected], 1, .06, false, false, (_) -> switchState(options[curSelected]));
        });

        for (dir => val in [Key.up => -1, Key.down => 1]) onPress(dir, changeItem(val));
        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        if (huh != 0) Sound.play(Path.sound('scrollMenu'), .4);

        curSelected = (curSelected + huh + menuItems.length) % menuItems.length;

        for (i => item in menuItems) {
            (i == curSelected) ? item.playAnim('selected').centerOffsets() : item.playAnim('idle').updateHitbox();
            item.screenCenter(X);
        }
    }
}