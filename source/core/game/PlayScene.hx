package core.game;

class PlayScene extends MusicScene {
    public static var instance:PlayScene;
    public var paused:Bool = false;

	public var camGame:FlxCamera = new FlxCamera();
	public var camHUD:FlxCamera = new FlxCamera();
	public var camOther:FlxCamera = new FlxCamera();

    public var inst:FlxSound;
	public var vocals:FlxSound;
	public var vocalsOpponent:FlxSound;

    public var playField:PlayField;

    override function create() {
        instance = this;

        bgColor = 0xFF999999;

        for (cam in [camGame, camHUD, camOther]) FlxG.cameras.add(cam, false).bgColor = 0x00000000;

        Music.stop();
        
        add(playField = new PlayField());
        playField.camera = camHUD;

        PlayerControls.init();

        super.create();
    }

    override function openSubState(SubState:FlxSubState) {
		super.openSubState(SubState);

        if (!paused) return;

        for (sound in [inst, vocals, vocalsOpponent]) sound?.pause();

        FlxTimer.globalManager.forEach(pauseTmr);
        FlxTween.globalManager.forEach(pauseTwn);

        FlxG.camera.followLerp = 0;
        paused = Conductor.paused = true;
        persistentUpdate = false;
	}

	override function closeSubState() {
		super.closeSubState();

        if (!paused) return;

        for (sound in [inst, vocals, vocalsOpponent]) sound?.resume();

        FlxTimer.globalManager.forEach(resumeTmr);
        FlxTween.globalManager.forEach(resumeTwn);

        paused = Conductor.paused = false;
        persistentUpdate = true;
	}

    function pauseTmr(tmr:FlxTimer) if (!tmr.finished) tmr.active = false;
    function resumeTmr(tmr:FlxTimer) if (!tmr.finished) tmr.active = true;

    function pauseTwn(twn:FlxTween) if (!twn.finished) twn.active = false;
    function resumeTwn(twn:FlxTween) if (!twn.finished) twn.active = true;
}