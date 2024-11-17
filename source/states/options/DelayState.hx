package states.options;

class DelayState extends BeatState {
    var holdTime = .0;

    var delayText:FlxText;

    var bf:QuazarSpr;

    var objects:Array<{name:String, pos:Array<Float>}> = [
        {name: 'stageback', pos: [-300, -100]}, {name: 'stagefront', pos: [-230, 500]},
        {name: 'stage_light', pos: [125, 20]}, {name: 'stage_light', pos: [1025, 20]}, {name: 'stagecurtains', pos: [-230, -100]}
    ];

    var props:FlxTypedSpriteGroup<QuazarSpr>;

    override function create() {
        Conductor.bpm = 80;

        FlxG.sound.playMusic(Path.music('songOffset'), .5);

        add(props = new FlxTypedSpriteGroup());
        for (i in 0...objects.length) {
            final prop = new QuazarSpr('stage/${objects[i].name}', objects[i].pos[0], objects[i].pos[1], 'stages');
            prop.scale.set(0.7, 0.7);
            prop.updateHitbox();
            props.add(prop);
        }

        props.members[3].flipX = true;

        add(bf = new QuazarSpr('options/bf', 429, 282, [{name: 'idle', prefix: 'idle', fps: 24}]));
        bf.animation.play('idle');
        bf.animation.finish();

        Key.onPress(Data.keyBinds['back'], onBack);

        Key.onRelease(Data.keyBinds['left'], resetHold);
        Key.onRelease(Data.keyBinds['right'], resetHold);

        Key.onPress(Data.keyBinds['left'], onLeftPress);
        Key.onPress(Data.keyBinds['right'], onRightPress);

        Key.onHold(Data.keyBinds['left'], onLeftHold);
        Key.onHold(Data.keyBinds['right'], onRightHold);

        add(delayText = new FlxText(0, 30, 1280, '${Data.offset}').setFormat(Path.font('FallingSkyBlk.otf'), 32, FlxColor.WHITE, CENTER));

        super.create();
    }

    inline function onLeftPress() updateOffset(-1);
    inline function onRightPress() updateOffset(1);

    inline function onLeftHold() if(holdTime > .5) updateOffset(-1);
    inline function onRightHold() if(holdTime > .5) updateOffset(1);

    inline function resetHold() holdTime = 0;

    function onBack() {
        Key.blockControls = true;
        MenuState.switchState(new OptionsState());
        FlxG.sound.music.stop();
    }

    var mult = 1.;
    function updateOffset(huh = 0) {
        if (huh != 0) {
            delayText.text = '${Data.offset = Std.int(Math.max(-500, Math.min(Data.offset + (huh == -1 ? -1 : 1) * mult, 500)))}';
            mult = holdTime > .5 ? 2 : 1;

            FlxG.sound.play(Path.sound('scrollMenu'), .4);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.anyPressed(Data.keyBinds['left']) || FlxG.keys.anyPressed(Data.keyBinds['right'])) holdTime += elapsed;
    }

    var camTween:FlxTween;
    override function onBeat() {
        if (curBeat % 2 == 0) {
            if (camTween != null) camTween.cancel();
            camTween = FlxTween.num(1.05, 1, 1, {ease: FlxEase.expoOut}, (v) -> FlxG.camera.zoom = v);
        }

        bf.animation.play('idle', true);

        super.onBeat();
    }

    override function destroy() {
        Conductor.bpm = 102;
        super.destroy();
    }
}