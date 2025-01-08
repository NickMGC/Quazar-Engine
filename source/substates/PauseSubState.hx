package substates;

import states.PlayState.instance as game;

class PauseSubState extends MenuSubstate {
	var textItems:Array<Alphabet> = [];

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected = 0;

	override function create() {
		super.create();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		Sound.playMusic(Path.music('breakfast'), 0);
		Music.fadeIn(1, 0, .5);

		final bg = Graphic(0, 0, 1280, 720, 0xFF000000);
		bg.alpha = 0;
		FlxTween.num(bg.alpha, .6, .4, {ease: FlxEase.quartOut}, (v) -> bg.alpha = v);
		add(bg);

		for (i => item in menuItems) {
			var text = new Alphabet(0, 0, item, .7);
			text.screenCenter();
			text.y += (60 * i) - 50;
			add(text);
			textItems.push(text);
		}

		onPress(Key.back, {
			Music.stop();
			close();
		});

		onPress(Key.accept, {
			Music.stop();
			switch (menuItems[curSelected]) {
				case 'Resume': close();
				case 'Restart Song':
					game.paused = true;
					FlxG.resetState();
				case 'Exit to menu':
					blockControls = true;
					Sound.playMusic(Path.music('freakyMenu'), .5);
					FlxG.switchState(MainMenuState.new);
			}
		});

		for (dir => val in [Key.up => -1, Key.down => 1]) onPress(dir, changeItem(val));
		changeItem();
	}

	function changeItem(huh = 0) {
		if (huh != 0) Sound.play(Path.sound('scrollMenu'), .4);

		curSelected = (curSelected + huh + menuItems.length) % menuItems.length;

		for (i => item in textItems) item.alpha = i == curSelected ? 1 : .6;
	}
}