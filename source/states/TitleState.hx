package states;

class TitleState extends BeatState {
    var ngSpr:FlxSprite;
	var logo:FlxSprite;
	var gf:FlxSprite;
	var titleText:FlxSprite;

	var randomPhrase:Array<String> = FlxG.random.getObject([for (t in openfl.Assets.getText(Path.txt('data/introText')).split('\n')) t.split('--')]);

    var text:Alphabet;

    override function create() {
        Path.clearStoredMemory();

        bpm = 102;

        Sound.playMusic(Path.music('freakyMenu'), 0);
        Music.fadeIn(4, 0, .5);

        add(gf = Sparrow(510, 20, 'title/title')
        .addPrefix('left', 'left', 24, false).addPrefix('right', 'right', 24, false).playAnim('left').finishAnim());

        add(logo = Sparrow(-140, -100, 'title/title').addPrefix('bump', 'logo bumpin', 24, false).playAnim('bump').finishAnim());

        add(titleText = Sparrow(137, 575, 'title/title')
        .addPrefix('idle', 'ENTER IDLE0', 24, false).addPrefix('press', 'ENTER PRESSED0', 24).playAnim('idle'));

        add(ngSpr = Sparrow(0, 375, 'title/title').addPrefix('idle', 'newgrounds_logo', 0, false).playAnim('idle').precache()); 
        ngSpr.setGraphicSize(ngSpr.frameWidth * .8);
        ngSpr.updateHitbox();
        ngSpr.screenCenter(X);

        add(text = new Alphabet().setAlign(CENTER, 1280));
        text.lineSpacing = -15;
        text.screenCenter(Y);

        titleText.visible = logo.visible = gf.visible = ngSpr.active = ngSpr.visible = false;
        skipNextTransOut = true;

        onPress(Key.accept, skipIntro());

        super.create();
    }

    var titleTimer = .0;
	override function update(elapsed:Float) {
		super.update(elapsed);

        if (blockControls) return;

        titleTimer = (titleTimer + elapsed) % 2;

        final timer = FlxEase.quadInOut(titleTimer >= 1 ? 2 - titleTimer : titleTimer);
		titleText.color = FlxColor.interpolate(0xFF33FFFF, 0xFF3333CC, timer);
		titleText.alpha = FlxMath.lerp(1, .65, timer);
	}

    override function onBeat() {
        super.onBeat();

        gf.playAnim(curBeat % 2 == 0 ? 'left' : 'right', true);
        logo.playAnim('bump', true);

		if (titleText.visible) return;

		switch (curBeat) {
            case 5, 13: deleteText();

			case 2:  createText('quazar engine by', -90);
			case 4:  addText('nickngc\niccer');
			case 6:  createText('not associated\nwith', -140);
			case 8:
                addText('\nnewgrounds');
                ngSpr.visible = true;
            case 9:
                deleteText();
                ngSpr.visible = false;

			case 10: createText(randomPhrase[0], -90);
			case 12: addText(randomPhrase[1]);
			case 14: createText('friday', -90);
			case 15: addText('night');
			case 16: addText('funkin');
			case 17: skipIntro();
		}
    }

    inline function createText(string:String, ?offset = 0.) {
        text.text = string;
        text.screenCenter(Y);
        text.y += offset;
    }

    inline function addText(string:String) text.text += '\n$string';
	inline function deleteText() text.y = FlxG.height; //lolol

    function skipIntro() {
        if (!titleText.visible) {
            camera.flash(FlxColor.WHITE, 1);

            for (obj in [text, ngSpr]) obj = FlxDestroyUtil.destroy(obj);

            titleText.visible = logo.visible = gf.visible = true;
            return;
        }

        blockControls = true;

        camera.flash(Data.flashingLights ? FlxColor.WHITE : 0x4CFFFFFF, 1);
        Sound.play(Path.sound('confirmMenu'), .7);

        titleText.active = Data.flashingLights;
        titleText.playAnim('press');
        titleText.color = FlxColor.WHITE;
        titleText.alpha = 1;

        FlxTimer.wait(1.5, () -> switchState(MainMenuState.new));
	}
}