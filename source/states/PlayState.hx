package states;

import core.controls.PlayerControls;

@:publicFields class PlayState extends BeatState {
    static var instance:PlayState;
    var paused = false;

    var playerStrums:StrumLine;
	var opponentStrums:StrumLine;

	var camGame = new FlxCamera();
	var camHUD = new FlxCamera();
	var camOther = new FlxCamera();

    var inst:FlxSound;
	var vocals:FlxSound;
	var vocalsOpponent:FlxSound;

    override function create() {
        instance = this;

        bgColor = 0xFF999999;

        for (cam in [camGame, camHUD, camOther]) FlxG.cameras.add(cam, false).bgColor = 0x00000000;

        add(playerStrums = new StrumLine(337, 75));
		add(opponentStrums = new StrumLine(-332, 75));
        opponentStrums.autoHit = true;

        playerStrums.camera = opponentStrums.camera = camHUD;

        Music.stop();

        Conductor.song = inst;

        PlayerControls.init();

        super.create();
    }

    function spawnSplash(strum:StrumNote) {
        var splash = strum.line.splashes.recycle(Splash, () -> return new Splash(camHUD).setScale(.9));
        splash.setPosition(Std.int(strum.x + (strum.width - splash.width) * .5), Std.int(strum.y + (strum.height - splash.height) * .5));
        splash.playAnim(Note.notes[strum.index % 4] + FlxG.random.int(1, 2)).onAnimFinish(name -> splash.kill());
    }

    override function openSubState(SubState:FlxSubState) {
		super.openSubState(SubState);

        if (paused) {
            for (sound in [inst, vocals, vocalsOpponent]) sound?.pause();

            FlxTimer.globalManager.forEach(tmr -> if (!tmr.finished) tmr.active = false);
            FlxTween.globalManager.forEach(twn -> if (!twn.finished) twn.active = false);

            FlxG.camera.followLerp = 0;
            paused = Conductor.paused = true;
            persistentUpdate = false;
        }
	}

	override function closeSubState() {
		super.closeSubState();

        if (paused) {
            for (sound in [inst, vocals, vocalsOpponent]) sound?.resume();

            FlxTimer.globalManager.forEach(tmr -> if (!tmr.finished) tmr.active = true);
            FlxTween.globalManager.forEach(twn -> if (!twn.finished) twn.active = true);
    
            paused = Conductor.paused = false;
            persistentUpdate = true;
        }
	}
}