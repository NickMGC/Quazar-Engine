package menus;

class BPMTestMenu extends MusicScene {
    var square:FlxSprite;
    override function create() {
        bgColor = 0xFF999999;

        bpm = 130;
        Music.play('bpmTest', 0.5);

        add(square = Graphic(10, 10, 100, 100, FlxColor.GREEN));

        Key.onPress(Key.back, () -> switchState(MainMenu.new));

        super.create();
    }

    var leTween:FlxTween;
    override function onBeat() {
        trace(curBeat);
        if (curBeat == 8) bpm = 160;
        if (curBeat == 16) bpm = 130;

        leTween?.cancel();
        leTween = FlxTween.num(0, 1, 0.1, {ease:FlxEase.linear}, (v) -> square.alpha = v);

        super.onBeat();
    }
}