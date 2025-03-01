package menus;

class TitleMenu extends MusicScene {
	var ngSpr:FlxSprite;
	var logo:FlxSprite;
	var gf:FlxSprite;
	var titleText:FlxSprite;

	final randomPhrase:Array<String> = FlxG.random.getObject([for (t in openfl.Assets.getText(Path.txt('introText')).split('\n')) t.split('--')]);

	var text:Alphabet;

	override function create() {
		Path.clearStoredMemory();

		bpm = 102;
		Music.play('freakyMenu', 0).fadeIn(4, 0, 0.5);

		add(gf = Sparrow('ui/title/title', 510, 20));
		gf.addPrefix('left', 'left', 24, false).addPrefix('right', 'right', 24, false).playAnim('left').finishAnim();

		add(logo = Sparrow('ui/title/title', -140, -100));
		logo.addPrefix('bump', 'logo bumpin', 24, false).playAnim('bump').finishAnim();

		add(titleText = Sparrow('ui/title/title', 137, 575));
		titleText.addPrefix('idle', 'ENTER IDLE0', 24, false).addPrefix('press', 'ENTER PRESSED0', 24).playAnim('idle');

		add(ngSpr = Sparrow('ui/title/title', 0, 375));
		ngSpr.addPrefix('idle', 'newgrounds_logo', 0, false).playAnim('idle').precache().setGraphicSize(ngSpr.frameWidth * .8);
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);

		add(text = new Alphabet().setAlign(CENTER, 1280));
		text.screenCenter(Y);

		titleText.visible = logo.visible = gf.visible = ngSpr.active = ngSpr.visible = false;
		skipNextTransOut = true;

		Key.onPress(Key.accept, onAccept);

		super.create();
	}

	var titleTimer:Float = 0;
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (Controls.block) return;

		titleTimer = (titleTimer + elapsed) % 2;

		final timer = FlxEase.quadInOut(titleTimer >= 1 ? 2 - titleTimer : titleTimer);
		titleText.setColor(Util.lerpColor(0xFF33FFFF, 0xFF3333CC, timer)).setAlpha(FlxMath.lerp(1, 0.65, timer));
	}

	override function onBeat() {
		super.onBeat();

		gf.playAnim(curBeat % 2 == 0 ? 'left' : 'right', true);
		logo.playAnim('bump', true);

		if (titleText.visible) return;

		switch curBeat {
			case 1:
				createText('quazar engine by', -90);
			case 3:
				addText('nickngc\niccer');
			case 4:
				deleteText();
			case 5:
				createText('not associated\nwith', -140);
			case 7:
				addText('newgrounds');
				ngSpr.visible = true;
			case 8:
				deleteText();
				ngSpr.visible = false;
			case 9:
				createText(randomPhrase[0], -90);
			case 11:
				addText(randomPhrase[1]);
			case 12:
				deleteText();
			case 13:
				createText('friday', -90);
			case 14:
				addText('night');
			case 15:
				addText('funkin');
			case 16:
				onAccept();
		}
	}

	inline function createText(string:String, ?offset:Float = 0) {
		text.text = string;
		text.screenCenter(Y);
		text.y += offset;
	}

	inline function addText(string:String) text.text += '\n$string';
	inline function deleteText() text.y = FlxG.height; //lolol

	function onAccept() {
		if (!titleText.visible) {
			camera.flash(FlxColor.WHITE, 1);

			for (obj in [text, ngSpr]) obj = FlxDestroyUtil.destroy(obj);

			titleText.visible = logo.visible = gf.visible = true;
			return;
		}

		Controls.block = true;

		camera.flash(Data.flashingLights ? FlxColor.WHITE : 0x4CFFFFFF, 1);
		Sound.play('confirm', 0.7);

		titleText.playAnim('press').setActive(Data.flashingLights).setColor(FlxColor.WHITE).setAlpha(1);

		FlxTimer.wait(1.5, goToState);
	}

	inline function goToState() switchState(MainMenu.new);
}