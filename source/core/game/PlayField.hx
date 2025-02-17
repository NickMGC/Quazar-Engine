package core.game;

class PlayField extends FlxContainer {
    public var playerStrums:StrumLine;
	public var opponentStrums:StrumLine;

    public function new() {
        super();

        add(playerStrums = new StrumLine(337, 75));
		add(opponentStrums = new StrumLine(-332, 75));
        opponentStrums.autoHit = true;
    }

    public function spawnSplash(strum:StrumNote) {
        var splash:Splash = strum.line.splashes.recycle(Splash, newSplash);

        splash.setPosition(Std.int(strum.x + (strum.width - splash.width) * 0.5), Std.int(strum.y + (strum.height - splash.height) * 0.5));
        splash.playAnim(Note.notes[strum.index % 4] + FlxG.random.int(1, 2));

        function killSplash(name:String) splash.kill();

        splash.onAnimFinish(killSplash);
    }

    function newSplash() {
        return new Splash(PlayScene.instance.camHUD).setScale(0.9);
    }
}