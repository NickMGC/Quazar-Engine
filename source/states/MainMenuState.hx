package states;

class MainMenuState extends MenuState {
    static var curSelected = 0;

    static final options:Array<NextState> = [MainMenuState.new, testing.AlphabetAlign.new, CreditsState.new, states.options.OptionsState.new];

    var menuItems:FlxSpriteGroup;

    override function create() {
        add(Sprite('menuBG'));
        add(menuItems = new FlxSpriteGroup());

		for (i => item in ['storymode', 'freeplay', 'credits', 'options']) {
            final menu = Sparrow(0, (i * 140) + 90, 'mainmenu/buttons');
            menu.addPrefix('idle', '$item idle0', 24, true).addPrefix('selected', '$item selected0', 24, true).playAnim('idle');
            menuItems.add(menu).screenCenter(X);
        }

        onPress(accept, () -> {
            blockControls = true;
            playSound('confirmMenu', .7);
            FlxFlicker.flicker(menuItems.members[curSelected], 1, .06, false, false, (_) -> switchState(options[curSelected]));
        });

        for (dir => val in [up => -1, down => 1]) onPress(dir, () -> changeItem(val));
        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        if (huh != 0) playSound('scrollMenu', .4);

        curSelected = (curSelected + huh + menuItems.length) % menuItems.length;

        for (i => item in menuItems.members) {
            if (i == curSelected) {
                item.playAnim('selected');
                item.centerOffsets();
            } else {
                item.playAnim('idle');
                item.updateHitbox();
            }
            item.screenCenter(X);
        }
    }
}