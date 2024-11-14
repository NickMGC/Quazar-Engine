package states;

class TitleState extends BeatState {
    var skippedIntro = false;

    var ngSpr:QuazarSpr;
	var logo:QuazarSpr;
	var gf:QuazarSpr;
	var titleText:QuazarSpr;

	var randomPhrase:Array<String> = FlxG.random.getObject([for (t in openfl.Assets.getText(Path.txt('data/introText')).split('\n')) t.split('--')]);

	var textGroup:FlxTypedGroup<Alphabet>;

    override function create() {
        Path.clearStoredMemory();

        Conductor.bpm = 102;

        FlxG.sound.playMusic(Path.music('freakyMenu'), 0);
		FlxG.sound.music.fadeIn(4, 0, .5);
    
        super.create();

		add(gf = new QuazarSpr('title/title', 510, 20, [{name: 'left', prefix: 'left', fps: 24}, {name: 'right', prefix: 'right', fps: 24}]));
        gf.animation.play('left');

        add(logo = new QuazarSpr('title/title', -140, -100, [{name: 'bump', prefix: 'logo bumpin', fps: 24}]));
        logo.animation.play('bump');

        add(ngSpr = new QuazarSpr('title/title', 0, 375, [{name: 'idle', prefix: 'newgrounds_logo', fps: 0}]));
        ngSpr.animation.play('idle');
        ngSpr.setGraphicSize(ngSpr.frameWidth * .8);
        ngSpr.updateHitbox();
        ngSpr.screenCenter(X);

        add(titleText = new QuazarSpr('title/title', 137, 575, [{name: 'idle', prefix: 'ENTER IDLE0', fps: 24}, {name: 'press', prefix: 'ENTER PRESSED0', fps: 24, loop: true}]));
		titleText.animation.play('idle');

        add(textGroup = new FlxTypedGroup());

        for (obj in [logo, titleText, gf]) obj.kill();
        ngSpr.active = ngSpr.visible = false;

		Key.onPress(Data.keyBinds['accept'], () -> skipIntro());
    }

    var titleTimer = .0;
	override function update(elapsed:Float):Void {
		super.update(elapsed);

		if (!Key.blockControls) {
            if ((titleTimer += elapsed) > 2) titleTimer -= 2;
				
			final timer = FlxEase.quadInOut(titleTimer >= 1 ? (-titleTimer) + 2 : titleTimer);
			titleText.color = FlxColor.interpolate(0xFF33FFFF, 0xFF3333CC, timer);
			titleText.alpha = FlxMath.lerp(1, .64, timer);
		}
	}

    override function onBeat() {
        gf.animation.play(curBeat % 2 == 0 ? 'left' : 'right', true);
        logo.animation.play('bump', true);

		if (!skippedIntro) {
			ngSpr.visible = curBeat == 7;
			switch (curBeat) {
                case 4, 8, 12: deleteText();

				case 1:  createText(['quazar engine by'], 40);
				case 3:  createText(['nickngc', 'iccer'], 40);
				case 5:  createText(['not associated', 'with'], -40);
				case 7:  createText(['newgrounds'], -40);
				case 9:  createText([randomPhrase[0]]);
				case 11: createText([randomPhrase[1]]);
				case 13: createText(['friday']);
				case 14: createText(['night']);
				case 15: createText(['funkin']);
				case 16: skipIntro();
			}
		}

        super.onBeat();
    }

    inline function createText(textArray:Array<String>, ?offset = 0) for (i in 0...textArray.length) textGroup.add(new Alphabet(0, (textGroup.length * 60) + 200 + offset, textArray[i])).screenCenter(X);
	inline function deleteText() while (textGroup.members.length != 0) textGroup.remove(textGroup.members[0], true).destroy();

    function skipIntro() {
        if (!skippedIntro) {
            FlxG.camera.flash(FlxColor.WHITE, 1);

            skippedIntro = true;
            for (obj in [logo, titleText, gf]) obj.revive();
            ngSpr = FlxDestroyUtil.destroy(ngSpr);
            deleteText();

            return;
        }

        Key.blockControls = true;

        FlxG.camera.flash(Data.flashingLights ? FlxColor.WHITE : 0x4CFFFFFF, 1);
        FlxG.sound.play(Path.sound('confirmMenu'), .7);

        if (!Data.flashingLights) titleText.active = false;
        titleText.animation.play('press');
        titleText.color = FlxColor.WHITE;
        titleText.alpha = 1;

        FlxTimer.wait(1.5, () -> MenuState.switchState(new MainMenuState()));
	}
}