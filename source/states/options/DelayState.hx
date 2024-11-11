package states.options;

class DelayState extends BeatState {
    var holdTime = .0;

    var delayText:FlxText;
    override function create() {
        Conductor.bpm = 80;

        FlxG.sound.playMusic(Path.music('songOffset'), .0);
        FlxG.sound.music.fadeIn(.1, 0, .5);

        add(new QuazarSpr('options/delay'));

        Key.onPress(Data.keyBinds['back'], () -> {
            Key.blockControls = true;
            MenuState.switchState(new OptionsState());
            FlxG.sound.music.stop();
        });

        Key.onRelease(Data.keyBinds['left'],  () -> holdTime = 0);
        Key.onRelease(Data.keyBinds['right'], () -> holdTime = 0);
        Key.onPress  (Data.keyBinds['left'],  () -> updateOffset(-1));
        Key.onPress  (Data.keyBinds['right'], () -> updateOffset(1));
        Key.onHold   (Data.keyBinds['left'],  () -> if(holdTime > .5) updateOffset(-1));
        Key.onHold   (Data.keyBinds['right'], () -> if(holdTime > .5) updateOffset(1));

        add(delayText = new FlxText(0, 30, 0, '${Data.offset}').setFormat(Path.font('FallingSkyBlk.otf'), 32, FlxColor.BLACK, CENTER));
        delayText.screenCenter(X);

        super.create();
    }

    var mult = 1.;
    function updateOffset(huh = 0) {
        if (huh != 0) {
            Data.offset = Std.int(Math.max(-500, Math.min(Data.offset + (huh == -1 ? -1 : 1) * mult, 500)));

            if(holdTime > .5) 
                mult = 2;
            else {
                mult = 1;  
                FlxG.sound.play(Path.sound('scrollMenu'), .4);
                holdTime = 0;
            }

            delayText.text = '${Data.offset}';
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.anyPressed(Data.keyBinds['left']) || FlxG.keys.anyPressed(Data.keyBinds['right'])) holdTime += elapsed;
    }

    var camTween:FlxTween;
    override function onBeat() {
        if (camTween != null) camTween.cancel();
        camTween = FlxTween.num(1.05, 1, 0.3, {ease: FlxEase.expoOut}, (v) -> FlxG.camera.zoom = v);

        super.onBeat();
    }

    override function destroy() {
        Conductor.bpm = 102;
        super.destroy();
    }
}