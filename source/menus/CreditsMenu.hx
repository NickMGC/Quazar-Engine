package menus;

class CreditsMenu extends Scene {
	static var curSelected:Int = 0;

	static final categories:Array<CreditCategory> = [
		new CreditCategory('Quazar Engine Developers', [
			Credit.make('NickNGC', 'Owner, Programmer, Artist, Composer', 'x.com/nickngc'),
			Credit.make('Iccer', 'Artist', 'x.com/iccerdraws')
		]),
		new CreditCategory("Funkin' Crew", [
			Credit.make('Phantom Arcade', 'Director, Artist', 'x.com/PhantomArcade3K'),
			Credit.make('ninjamuffin99', 'Co-Director, Programmer', 'x.com/ninja_muffin99'),
			Credit.make('Kawai Sprite', 'Musician', 'x.com/kawaisprite'),
			Credit.make('evilsk8r', 'Artist', 'x.com/evilsk8r')
		])
	];

	var credits:Array<Credit> = [];
	var desc:Alphabet;

	var curY:Float = 60;

	override function create() {
		add(Sprite('ui/menuDesat').setColor(0xFFea71fd));

		for (category in categories) createCategory(category);

		add(desc = new Alphabet(30, 650, '', 0.7, false));

		initControls();
		changeItem();

		super.create();
	}

	inline function onAccept() FlxG.openURL(credits[curSelected].data.link);

	function onBack() {
		Controls.block = true;
		Sound.play('cancel', 0.6);
		switchState(MainMenu.new);
	}

	function createCategory(category:CreditCategory) {
		final title = new Alphabet(90, curY, category.name, 0.8, true);
		add(title);
		add(Graphic(Std.int(109 + title.width), curY + 20, Std.int(1190 - (108 + title.width)), 4, FlxColor.BLACK));

		curY += 50;

		for (credit in category.credits) {
			credits.push(new Credit(credit, curY += 50));
			add(credits[credits.length - 1]);
		}
		
		curY += 110;
	}

	function changeItem(dir:Int = 0) {
		if (dir != 0) Sound.play('scroll', 0.4);

		curSelected = (curSelected + dir + credits.length) % credits.length;
		desc.text = credits[curSelected].data.desc;

		for (i => credit in credits) credit.text.alpha = i == curSelected ? 1 : 0.6;
	}

	function initControls() {
		Key.onPress(Key.accept, onAccept);
		Key.onPress(Key.back, onBack);

		Key.onPress(Key.up, onUp);
		Key.onPress(Key.down, onDown);
	}

	inline function onUp() changeItem(-1);
	inline function onDown() changeItem(1);
}

class Credit extends FlxSpriteGroup {
	public var data:CreditData;
	public var text:Alphabet;

	public function new(data:CreditData, y:Float = 0) {
		super(0, y);

		this.data = data;

		add(text = new Alphabet(135, 0, data.name, 0.7, false));
		add(Sparrow('ui/credits/icons', 145 + text.width, -5).addPrefix(data.name, data.name, 0, false).playAnim(data.name));
	}

	public static function make(name:String, desc:String, link:String):CreditData {
		return {name: name, desc: desc, link: link};
	}
}

class CreditCategory {
	public var name:String;
	public var credits:Array<CreditData>;

	public function new(name:String, credits:Array<CreditData>) {
		this.name = name;
		this.credits = credits;
	}
}

typedef CreditData = {name:String, desc:String, link:String}