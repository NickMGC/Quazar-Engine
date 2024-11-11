package states;

class MainMenuState extends MenuState {
    static var curSelected = 0;

    static final options:Array<{name:String, state:Class<FlxState>}> = [
        {name: 'storymode', state: MainMenuState}, {name: 'freeplay', state: testing.AlphabetAlign}, {name: 'credits', state: CreditsState}, {name: 'options', state: states.options.OptionsState}
    ];

    var menuItems:FlxTypedSpriteGroup<QuazarSpr>;

    override function create() {
        for (obj in [new QuazarSpr('menuBG'), menuItems = new FlxTypedSpriteGroup()]) add(obj);

		for (i => item in options) {
            final animInfo = [{name: 'idle', prefix: '${item.name} idle0', fps: 24, loop: true}, {name: 'select', prefix: '${item.name} selected0', fps: 24, loop: true}];
            menuItems.add(new QuazarSpr('mainmenu/buttons', 0, (i * 140) + 90, animInfo)).screenCenter(X);
        }

        Key.onPress(Data.keyBinds['accept'], () -> {
            Key.blockControls = true;

            FlxG.sound.play(Path.sound('confirmMenu'), .7);
            flixel.effects.FlxFlicker.flicker(menuItems.members[curSelected], 1, .06, false, false, (_) ->  MenuState.switchState(Type.createInstance(options[curSelected].state, [])));
        });

        Key.onPress(Data.keyBinds['up'],   () -> changeItem(-1));
        Key.onPress(Data.keyBinds['down'], () -> changeItem(1));
        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        if (huh != 0) FlxG.sound.play(Path.sound('scrollMenu'), .4);

        curSelected = (curSelected + huh + menuItems.length) % menuItems.length;

        for (i => item in menuItems.members) {
            item.animation.play(i == curSelected ? 'select' : 'idle');
            i == curSelected ? item.centerOffsets() : item.updateHitbox();
            item.screenCenter(X);
        }
    }
}