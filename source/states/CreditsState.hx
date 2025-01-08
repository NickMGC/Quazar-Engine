package states;

class CreditsState extends MenuState {
    static var curSelected = 1;

    static final credits:Array<{name:String, ?desc:String, ?link:String, ?add:Float}> = [
        {name: 'QUAZAR ENGINE DEVELOPERS', add: 50},
        {name: 'NickNGC',        desc: 'Owner, Programmer, Artist, Composer', link: 'nickngc'},
        {name: 'Iccer',          desc: 'Artist',                              link: 'iccerdraws', add: 50},
        {name: "FUNKIN' CREW",             add: 50},
        {name: 'Phantom Arcade', desc: 'Director, Artist',                    link: 'PhantomArcade3K'},
        {name: 'ninjamuffin99',  desc: 'Co-Director, Programmer',             link: 'ninja_muffin99'},
        {name: 'Kawai Sprite',   desc: 'Musician',                            link: 'kawaisprite'},
        {name: 'evilsk8r',       desc: 'Artist',                              link: 'evilsk8r'}
    ];

    var devs:Array<Alphabet> = [];
    var desc:Alphabet;

    override function create() {
        add(Sprite('menuDesat').setColor(0xFFea71fd));

        for (i in 0...credits.length) {
            var credit = new Alphabet(isTitle(i) ? 90 : 135, 60, credits[i].name, isTitle(i) ? .8 : .7, isTitle(i));
            for (j in 0...i) credit.y += 50 + credits[j].add ?? 0;
            add(credit);
            devs.push(credit);

            if (!isTitle(i))
                add(Sparrow(credit.x + credit.width + 10, credit.y - 5, 'credits/credits').addPrefix(credits[i].name, credits[i].name, 0, false).playAnim(credits[i].name));
            else
                add(Graphic(Std.int(credit.x + credit.width + 19), credit.y + 20, Std.int(1190 - (credit.x + credit.width + 18)), 4, FlxColor.BLACK));
        }

        add(desc = new Alphabet(30, 650, credits[curSelected].desc, .7, false));

        onPress(Key.accept, FlxG.openURL('x.com/${credits[curSelected].link}'));

        onPress(Key.back, {
            blockControls = true;
            Sound.play(Path.sound('cancelMenu'), .6);
            switchState(MainMenuState.new);
        });

        for (dir => val in [Key.up => -1, Key.down => 1]) onPress(dir, changeItem(val));
        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        if (huh != 0) Sound.play(Path.sound('scrollMenu'), .4);
        do (curSelected = (curSelected + huh + credits.length) % credits.length) while (isTitle(curSelected));

        for (i => credit in devs) if (!credit.bold) credit.alpha = i == curSelected ? 1 : .6;
        desc.text = credits[curSelected].desc;
    }

    inline function isTitle(num:Int) return credits[num].desc == null;
}