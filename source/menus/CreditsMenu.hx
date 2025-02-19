package menus;

class CreditsMenu extends Scene {
    static var curSelected:Int = 0;
    static var curDev:Credit;

    static final categories:Array<CreditCat> = [
        CreditCategory('Quazar Engine Developers', [
            createDev('NickNGC', 'Owner, Programmer, Artist, Composer', 'nickngc'),
            createDev('Iccer', 'Artist', 'iccerdraws')
        ]),
        CreditCategory("Funkin' Crew", [
            createDev('Phantom Arcade', 'Director, Artist', 'PhantomArcade3K'),
            createDev('ninjamuffin99', 'Co-Director, Programmer', 'ninja_muffin99'),
            createDev('Kawai Sprite', 'Musician', 'kawaisprite'),
            createDev('evilsk8r', 'Artist', 'evilsk8r')
        ])
    ];

    var devs:Array<Credit> = [];
    var devsText:Array<Alphabet> = [];
    var desc:Alphabet;

    var curY:Float = 60;

    override function create() {
        add(Sprite('menuDesat').setColor(0xFFea71fd));

        for (category in categories) {
            createTitle(category.name);
            createCredits(category.credits);
        }

        add(desc = new Alphabet(30, 650, '', 0.7, false));

        initControls();
        changeItem();

        super.create();
    }

    inline function onAccept() FlxG.openURL('x.com/${curDev.link}');

    function onBack() {
        Controls.block = true;
        Sound.play('cancel', 0.6);
        switchState(MainMenu.new);
    }

    inline function onUp() changeItem(-1);
    inline function onDown() changeItem(1);

    function createTitle(name:String) {
        final title = new Alphabet(90, curY, name, 0.8, true);
        add(title);

        add(Graphic(Std.int(109 + title.width), curY + 20, Std.int(1190 - (108 + title.width)), 4, FlxColor.BLACK));

        curY += 50;
    }

    function createCredits(credits:Array<Credit>) {
        for (credit in credits) {
            devs.push(credit);
            curY += 50;

            final dev = new Alphabet(135, curY, credit.name, 0.7, false);
            add(dev);
            devsText.push(dev);

            add(Sparrow('credits/credits', 145 + dev.width, curY - 5).addPrefix(credit.name, credit.name, 0, false).playAnim(credit.name));
        }

        curY += 90;
    }

    function changeItem(dir:Int = 0) {
        if (dir != 0) Sound.play('scroll', 0.4);
        curSelected = (curSelected + dir + devs.length) % devs.length;

        curDev = devs[curSelected];
        desc.text = curDev.desc;

        for (i => credit in devsText) credit.alpha = i == curSelected ? 1 : 0.6;
    }

    private static function CreditCategory(name:String, credits:Array<Credit>):CreditCat return {name: name, credits: credits};
    private static function createDev(name:String, desc:String, link:String):Credit return {name: name, desc: desc, link: link};

    function initControls() {
        Key.onPress(Key.accept, onAccept);
        Key.onPress(Key.back, onBack);

        Key.onPress(Key.up, onUp);
        Key.onPress(Key.down, onDown);
    }
}

typedef CreditCat = {name:String, credits:Array<Credit>}
typedef Credit = {name:String, desc:String, link:String}