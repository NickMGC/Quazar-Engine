package substates;

import core.game.PlayScene.instance as game;

class PauseMenu extends SubScene {
	var textItems:Array<Alphabet> = [];

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	override function create() {
		super.create();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		Music.play('breakfast', 0).fadeIn(1, 0, 0.5);

		add(Graphic(0, 0, 1280, 720, 0xFF000000).setAlpha(0.6));

		for (i => item in menuItems) {
			textItems.push(new Alphabet(30, 262 + (i * 85), item, 0.9));
			add(textItems[i]);
		}

		initControls();
		changeItem();
	}

	function onAccept() {
		Music.stop();
		switch menuItems[curSelected] {
			case 'Resume':
				close();
			case 'Restart Song':
				game.paused = true;
				resetState();
			case 'Exit to menu':
				Controls.block = true;
				Music.play('freakyMenu', 0.5);
				switchState(MainMenu.new);
		}
	}

	function onBack() {
		Music.stop();
		close();
	}

	inline function onUp() changeItem(-1);
    inline function onDown() changeItem(1);

	function changeItem(dir:Int = 0) {
		if (dir != 0) Sound.play('scroll', 0.4);

		curSelected = (curSelected + dir + menuItems.length) % menuItems.length;

		for (i => item in textItems) item.alpha = i == curSelected ? 1 : 0.6;
	}

	function initControls() {
		Key.onPress(Key.accept, onAccept);
		Key.onPress(Key.back, onBack);
        Key.onPress(Key.up, onUp);
        Key.onPress(Key.down, onDown);
	}
}