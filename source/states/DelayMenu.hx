package states;

//TODO: redesign this menu
class DelayMenu extends MusicScene {
    var holdTime:Float = 0;

    var delayText:FlxText;

    var bf:FlxSprite;
    var props:Array<FlxSprite> = [];

    var objects:Array<{name:String, pos:Array<Float>}> = [
        {name: 'stageback', pos: [-300, -100]}, {name: 'stagefront', pos: [-230, 500]},
        {name: 'stage_light', pos: [125, 20]}, {name: 'stage_light', pos: [1025, 20]}, {name: 'stagecurtains', pos: [-230, -100]}
    ];

    override function create() {
        bpm = 80;
        Music.play('songOffset', 0.5);

        for (i in 0...objects.length) {
            props.push(Sprite('stage/${objects[i].name}', objects[i].pos[0], objects[i].pos[1], 'data/stages').setScale(.7));
            add(props[i]);
        }

        props[3].flipX = true;

        add(bf = Sparrow('options/bf', 429, 282).addPrefix('idle', 'idle', 24, false).playAnim('idle').finishAnim());

        add(delayText = new FlxText(0, 30, 1280, '${Data.offset}').setFormat(Path.font('fredoka.ttf'), 32, FlxColor.WHITE, CENTER));

        initControls();

        super.create();
    }

    function onBack() {
        Controls.block = true;
        switchState(OptionsMenu.new);
        Sound.play('cancel', 0.6);
        Music.stop();
    }
    
    inline function onLeft() updateOffset(-1);
    inline function onRight() updateOffset(1);

    inline function onLeftHold() if (holdTime > 0.5) updateOffset(-1);
    inline function onRightHold() if (holdTime > 0.5) updateOffset(1);

    inline function onKeyRelease() holdTime = 0;

    var camTween:FlxTween;
    override function onBeat() {
        if (curBeat % 2 == 0) {
            camTween?.cancel();
            camTween = FlxTween.num(1.05, 1, 1, {ease: FlxEase.expoOut}, bop);
        }

        bf.playAnim('idle', true);

        super.onBeat();
    }
 
    var mult:Float = 1;
    function updateOffset(dir:Int = 0) {
        Data.offset = Std.int(Math.max(-500, Math.min(Data.offset + (dir == -1 ? -1 : 1) * mult, 500)));
        mult = holdTime > 0.5 ? 3 : 1;

        delayText.text = '${Data.offset}';

        Sound.play('scroll', 0.4);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.anyPressed(Key.left) || FlxG.keys.anyPressed(Key.right)) holdTime += elapsed;
    }

    private inline function bop(value:Float) FlxG.camera.zoom = value;

    override function destroy() {
        bpm = 102;
        super.destroy();
    }

    function initControls() {
        Key.onPress(Key.back, onBack);

        Key.onPress(Key.left, onLeft);
        Key.onPress(Key.right, onRight);

        Key.onHold(Key.left, onLeftHold);
        Key.onHold(Key.right, onRightHold);

        for (dir in [Key.left, Key.right]) Key.onRelease(dir, onKeyRelease);
    }
}