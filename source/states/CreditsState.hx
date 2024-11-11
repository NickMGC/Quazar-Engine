package states;

class CreditsState extends MenuState {
    static var curSelected = 1;

    static final credits:Array<{name:String, ?desc:String, ?link:String, ?add:Float}> = [
        {name: 'QUAZAR ENGINE DEVELOPERS', add: 50},
        {name: 'NickNGC',        desc: 'Owner, Programmer, Artist, Composer', link: 'nickngc'},
        {name: 'Iccer',          desc: 'Artist',                                 link: 'iccerdraws', add: 50},
        {name: "FUNKIN' CREW",             add: 50},
        {name: 'Phantom Arcade', desc: 'Director and Artist',                    link: 'PhantomArcade3K'},
        {name: 'ninjamuffin99',  desc: 'Co-Director and Programmer',             link: 'ninja_muffin99'},
        {name: 'Kawai Sprite',   desc: 'Musician',                               link: 'kawaisprite'},
        {name: 'evilsk8r',       desc: 'Artist',                                 link: 'evilsk8r'}
    ];

    var curY = 60.;

    var devs:FlxTypedSpriteGroup<Alphabet>;
    var desc:Alphabet;

    override function create() {
        final bg = new QuazarSpr('menuDesat');
        bg.color = 0xFFea71fd;
        add(bg);

        add(devs = new FlxTypedSpriteGroup());

        for (i in 0...credits.length) {
            var credit = new Alphabet(isTitle(i) ? 90 : 135, curY, credits[i].name, isTitle(i) ? .8 : .7, isTitle(i));
            devs.add(credit).ID = i;

            curY += 50 + credits[i].add ?? 0;

            if (!isTitle(i)) {
                final icon = new QuazarSpr('credits/credits', credit.x + credit.width + 10, credit.y - 5, [{name: credits[i].name, prefix: credits[i].name, fps: 0}]);
                icon.active = false;
                icon.animation.play(credits[i].name);
                add(icon);
            } else add(new FlxSprite(Std.int(credit.x + credit.width + 19), credit.y + 20).makeGraphic(Std.int(1190 - (credit.x + credit.width + 18)), 4, FlxColor.BLACK));
        }

        add(desc = new Alphabet(30, 650, credits[curSelected].desc, .7, false));

        Key.onPress(Data.keyBinds['accept'], () -> FlxG.openURL('x.com/${credits[curSelected].link}'));

        Key.onPress(Data.keyBinds['back'], () -> {
            Key.blockControls = true;
            FlxG.sound.play(Path.sound('cancelMenu'), .6);
            MenuState.switchState(new MainMenuState());
        });

        Key.onPress(Data.keyBinds['up'],   () -> changeItem(-1));
        Key.onPress(Data.keyBinds['down'], () -> changeItem(1));
        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        do (curSelected = (curSelected + huh + credits.length) % credits.length) while (isTitle(curSelected));

        if (huh != 0) FlxG.sound.play(Path.sound('scrollMenu'), .4);

        for (i => credit in devs.members) if (!credit.bold) credit.alpha = i == curSelected ? 1 : .6;

        desc.text = credits[curSelected].desc;
    }

    inline function isTitle(num:Int) return credits[num].desc == null;
}