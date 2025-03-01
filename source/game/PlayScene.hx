package game;

class PlayScene extends MusicScene {
	public static var self:PlayScene;
	public var paused:Bool = false;

	public var camGame:FlxCamera = new FlxCamera();
	public var camHUD:FlxCamera = new FlxCamera();
	public var camOther:FlxCamera = new FlxCamera();

	public var inst:FlxSound;
	public var vocals:FlxSound;
	public var vocalsOpponent:FlxSound;

	public var playField:PlayField;

	override function create():Void {
		self = this;

		bgColor = 0xFF999999;

		for (cam in [camGame, camHUD, camOther]) FlxG.cameras.add(cam, false).bgColor = 0x00000000;
		
		add(playField = new PlayField(camHUD));

		Key.onPress(Key.accept, onAccept);

		super.create();
	}

	inline function onAccept():Void {
		openSubState(new PauseMenu());
	}

	override function openSubState(SubState:FlxSubState):Void {
		super.openSubState(SubState);

		if (!paused) return;
		for (sound in [inst, vocals, vocalsOpponent]) sound?.pause();

		FlxTimer.globalManager.forEach(pauseTmr);
		FlxTween.globalManager.forEach(pauseTwn);

		FlxG.camera.followLerp = 0;
		paused = conductor.paused = true;
		persistentUpdate = false;
	}

	override function closeSubState():Void {
		super.closeSubState();

		if (!paused) return;
		for (sound in [inst, vocals, vocalsOpponent]) sound?.resume();

		FlxTimer.globalManager.forEach(resumeTmr);
		FlxTween.globalManager.forEach(resumeTwn);

		paused = conductor.paused = false;
		persistentUpdate = true;
	}

	function pauseTmr(tmr:FlxTimer):Void if (!tmr.finished) tmr.active = false;
	function resumeTmr(tmr:FlxTimer):Void if (!tmr.finished) tmr.active = true;

	function pauseTwn(twn:FlxTween):Void if (!twn.finished) twn.active = false;
	function resumeTwn(twn:FlxTween):Void if (!twn.finished) twn.active = true;
}