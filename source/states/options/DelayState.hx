package states.options;

class DelayState extends BeatState {
    var holdTime = .0;

    var delayText:FlxText;

    var bf:FlxSprite;

    var objects:Array<{name:String, pos:Array<Float>}> = [
        {name: 'stageback', pos: [-300, -100]}, {name: 'stagefront', pos: [-230, 500]},
        {name: 'stage_light', pos: [125, 20]}, {name: 'stage_light', pos: [1025, 20]}, {name: 'stagecurtains', pos: [-230, -100]}
    ];

    var props:FlxSpriteGroup;

    override function create() {
        bpm = 80;
        playMusic('songOffset', .5);

        add(props = new FlxSpriteGroup());
        for (i in 0...objects.length) props.add(Sprite(objects[i].pos[0], objects[i].pos[1], 'stage/${objects[i].name}', 'stages').setScale(.7));

        props.members[3].flipX = true;

        add(bf = Sparrow(429, 282, 'options/bf').addPrefix('idle', 'idle', 24, false).playAnim('idle').finishAnim());

        add(delayText = new FlxText(0, 30, 1280, '${Data.offset}').setFormat(Path.font('fredoka.ttf'), 32, FlxColor.WHITE, CENTER));

        onPress(back, () -> {
            blockControls = true;
            switchState(OptionsState.new);
            stopMusic();
        });

        for (dir => val in [left => -1, right => 1]) {
            onPress(dir, () -> updateOffset(val));
            onHold(dir, () -> if (holdTime > .5) updateOffset(val));
            onRelease(dir, () -> holdTime = 0);
        }

        super.create();
    }

    var mult = 1.;
    function updateOffset(huh = 0) {
        if (huh != 0) {
            delayText.text = '${Data.offset = Std.int(Math.max(-500, Math.min(Data.offset + (huh == -1 ? -1 : 1) * mult, 500)))}';
            mult = holdTime > .5 ? 3 : 1;

            FlxG.sound.play(Path.sound('scrollMenu'), .4);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.anyPressed(left) || FlxG.keys.anyPressed(right)) holdTime += elapsed;
    }

    var camTween:FlxTween;
    override function onBeat() {
        if (curBeat % 2 == 0) {
            if (camTween != null) camTween.cancel();
            camTween = FlxTween.num(1.05, 1, 1, {ease: FlxEase.expoOut}, (v) -> FlxG.camera.zoom = v);
        }

        bf.playAnim('idle', true);

        super.onBeat();
    }

    override function destroy() {
        bpm = 102;
        super.destroy();
    }
}