package states;

class MainMenuState extends MenuState {
    static var curSelected = 0;

    static final options:Array<{name:String, state:Class<FlxState>}> = [
        {name: 'storymode', state: MainMenuState}, {name: 'freeplay', state: testing.AlphabetAlign}, {name: 'credits', state: CreditsState}, {name: 'options', state: states.options.OptionsState}
    ];

    var menuItems:FlxSpriteGroup;

    override function create() {
        add(Sprite('menuBG'));
        add(menuItems = new FlxSpriteGroup());

		for (i => item in options) {
            final menu = Sparrow(0, (i * 140) + 90, 'mainmenu/buttons');
            menu.addPrefix('idle', '${item.name} idle0', 24, true).addPrefix('selected', '${item.name} selected0', 24, true).playAnim('idle');
            menuItems.add(menu).screenCenter(X);
        }

        onPress(accept, () -> {
            Key.blockControls = true;
    
            FlxG.sound.play(Path.sound('confirmMenu'), .7);
            flixel.effects.FlxFlicker.flicker(menuItems.members[curSelected], 1, .06, false, false, (_) -> MenuState.switchState(Type.createInstance(options[curSelected].state, [])));
        });

        for (dir => val in [up => -1, down => 1]) onPress(dir, () -> changeItem(val));

        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        if (huh != 0) FlxG.sound.play(Path.sound('scrollMenu'), .4);

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