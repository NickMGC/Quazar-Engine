package game;

class PlayField extends FlxContainer {
	public var playerStrums:StrumLine;
	public var opponentStrums:StrumLine;

	public function new(camera:FlxCamera) {
		super();

		Music.stop();

		add(playerStrums = new StrumLine(337, 75));
		add(opponentStrums = new StrumLine(-332, 75, true));

		this.camera = camera;

		PlayerControls.init(this);
	}
}