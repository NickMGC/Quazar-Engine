package states;

import core.controls.PlayerControls.init as initControls;

@:publicFields class PlayState extends BeatState {
    static var instance:PlayState;

    var playerStrums:StrumLine;
	var opponentStrums:StrumLine;

	var camGame = new FlxCamera();
	var camHUD = new FlxCamera();
	var camOther = new FlxCamera();

    override function create() {
        instance = this;

        bgColor = 0xFF999999;

        for (cam in [camGame, camHUD, camOther]) FlxG.cameras.add(cam, false).bgColor = 0x00000000;

        add(playerStrums = new StrumLine(337, 75));
		add(opponentStrums = new StrumLine(-332, 75));
        opponentStrums.autoHit = true;

        playerStrums.camera = opponentStrums.camera = camHUD;

        onPress(back, switchState(MainMenuState.new));

        initControls();

        super.create();
    }

    function spawnSplash(strum:StrumNote) {
        var splash = strum.line.splashes.recycle(Splash, () -> {
            var spr = new Splash();
            spr.camera = camHUD;
            return spr.setScale(.9);
        });
        splash.splash(strum.index);
        splash.setPosition(strum.x + (strum.width - splash.width) * .5, strum.y + (strum.height - splash.height) * .5);
    }
}