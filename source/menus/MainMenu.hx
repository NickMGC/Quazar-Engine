package menus;

class MainMenu extends Scene {
	static var curSelected:Int = 0;

	static final options:Array<MenuItem> = [
		{name: 'storymode', state: PlayScene.new},
		{name: 'freeplay', state: FreeplayMenu.new},
		{name: 'credits', state: CreditsMenu.new},
		{name: 'options', state: OptionsMenu.new}
	];

	var menuItems:Array<FlxSprite> = [];

	override function create() {
		add(Sprite('ui/menuBG'));

		for (i => item in options) {
			menuItems.push(Sparrow('ui/mainmenu/buttons', 0, (i * 140) + 90));
			for (anim in ['idle', 'selected']) menuItems[i].addPrefix(anim, '${item.name} ${anim}0');
			add(menuItems[i]);
		}

		initControls();
		changeItem();

		super.create();
	}

	inline function goToState(_:FlxFlicker) switchState(options[curSelected].state);

	function onAccept() {
		Sound.play('confirm', 0.7);
		Controls.block = true;
		FlxFlicker.flicker(menuItems[curSelected], 1, 0.06, false, false, goToState);
	}

	inline function onUp() changeItem(-1);
	inline function onDown() changeItem(1);

	function changeItem(dir:Int = 0) {
		if (dir != 0) Sound.play('scroll', 0.4);

		curSelected = (curSelected + dir + menuItems.length) % menuItems.length;

		for (i => item in menuItems) {
			i == curSelected ? item.playAnim('selected').centerOffsets() : item.playAnim('idle').updateHitbox();
			item.screenCenter(X);
		}
	}

	function initControls() {
		Key.onPress(Key.accept, onAccept);
		Key.onPress(Key.up, onUp);
		Key.onPress(Key.down, onDown);
	}
}

typedef MenuItem = {name:String, state:NextState}