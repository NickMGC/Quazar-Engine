package states.options;

import objects.Option;

class OptionsState extends MenuState {
    static var curSelected = 1;
    var curOption:Option;

    final options:Array<{?option:Option, ?title:String, ?state:NextState, ?add:Float}> = [ 
        {title: 'Gameplay Settings', add: 50},
        {option: new Option('Downscroll',            'Changes your note direction from up to down.',                'downScroll',     BOOL)},
        {option: new Option('Middlescroll',          "Puts player's notes in the centre.",                          'middleScroll',   BOOL)},
        {option: new Option('Ghost Tapping',         "Tapping won't cause a miss when there's no notes to be hit.", 'ghostTapping',   BOOL)},
        {option: new Option('Flashing Lights',       "Includes flashing lights during some in-game moments.",       'flashingLights', BOOL)},
        {option: new Option('Reset Character',       'Determines whether the character should reset or not.',       'reset',          BOOL), add: 50},
        {option: new Option('Safe frames',           'Adjusts how strict the timing window is for hitting notes.',  'safeFrames',     FLOAT).addProperties(.1, 2, 10, 5), add: 50},
        {option: new Option('Change Controls...'), state: ControlsState.new},
        {option: new Option('Change Delay...'),    state: DelayState.new, add: 50},
        {title: 'Graphics Settings', add: 50},
        {option: new Option('Anti-Aliasing',         'Anti-Aliasing is used to make graphics look less pixelated.', 'antialiasing',   BOOL)},
        {option: new Option('GPU Rendering',         'Puts the workload on the GPU when rendering graphics.',       'gpuRendering',   BOOL)},
        {option: new Option('Shaders',               'Shaders are used for various visual effects.',                'shaders',        BOOL)},
        {option: new Option('Show Debug statistics', "Shows debug statistics like Framerate and Memory.",           'showFPS',        BOOL)}
    ];

    var optionArray:Array<Alphabet> = [];
    var checkboxes:Array<FlxSprite> = [];

    var desc:Alphabet;
    var bgClipped:FlxSprite;

    inline function background() return Sprite('menuDesat').setScrollFactor().setColor(0xFFea71fd);

    override function create() {
        if (!Music.playing) Sound.playMusic(Path.music('freakyMenu'), .5);

        add(background());

        for (i in 0...options.length) {
            var option = new Alphabet(135, 60, isTitle(i) ? options[i].title : options[i].option.name, isTitle(i) ? .8 : .7, isTitle(i));
            for (j in 0...i) option.y += 50 + options[j].add ?? 0;

            if (isTitle(i)) {
                option.screenCenter(X);

                add(Graphic(90, option.y + 20, Std.int(option.x) - 107, 4, FlxColor.BLACK));
                add(Graphic(Std.int(option.x + option.width + 19), option.y + 20, Std.int(1190 - (option.x + option.width + 18)), 4, FlxColor.BLACK));

            } else if (options[i].option.type != null) {
                switch(options[i].option.type) {
                    case BOOL:
                        var checkbox = Sparrow(1110, option.y - 2, 'options/checkbox')
                        .addPrefix('unchecked', 'unchecked', 0, false).addPrefix('checked', 'checked', 0, false)
                        .playAnim('${options[i].option.getValue() ? '' : 'un'}checked');
                        checkbox.ID = i;
                        add(checkbox);
                        checkboxes.push(checkbox);
                    default:
                        var text = new Alphabet(795, option.y, options[i].option.getValue(), .7, false, RIGHT);
                        text.autoSize = false;
                        text.fieldWidth = 500;
                        add(text);

                        options[i].option.child = text;
                        options[i].option.updateText();
                }
            }

            add(option);
            optionArray.push(option);
        }

        add(bgClipped = background());
        bgClipped.clipRect = new flixel.math.FlxRect(0, 630, 1280, 90);

        add(desc = new Alphabet(0, 650, '', .7, false).setScrollFactor());

        onPress(Key.back, {
            Settings.save();
            Settings.load();

            blockControls = true;
            Sound.play(Path.sound('cancelMenu'), .6);
            switchState(states.MainMenuState.new);
        });

        onPress(Key.accept, {
            if (curOption.type == BOOL) {
                Sound.play(Path.sound('scrollMenu'), .4);
    
                curOption.setValue(curOption.getValue() ? false : true);

                for (checkbox in checkboxes) if (checkbox?.ID == curSelected) checkbox.playAnim('${curOption.getValue() ? '' : 'un'}checked');
            }

            if (options[curSelected].state != null) {
                blockControls = true;
                switchState(options[curSelected].state);
            }
        });

        for (dir => val in [Key.up => -1, Key.down => 1]) onPress(dir, changeItem(val));

        for (dir => val in [Key.left => -1, Key.right => 1]) {
            onPress(dir, if (curOption.type != BOOL) {
                curOption.updateValue(val);
                Sound.play(Path.sound('scrollMenu'), .4);
                holdTime = 0;
            });

            onHold(dir, if(curOption.type != BOOL && holdTime > .5) curOption.updateValue(val));
        }

        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        if (huh != 0) Sound.play(Path.sound('scrollMenu'), .4);

        do {
            curSelected = (curSelected + huh + options.length) % options.length;
            curOption = options[curSelected].option;
        } while (isTitle(curSelected));

        desc.text = curOption?.desc ?? '';
        desc.screenCenter(X);
        bgClipped.visible = curOption.desc != null;

        for (i => option in optionArray) if (!option.bold) option.alpha = i == curSelected ? 1 : .6;
    }

	var holdTime = .0;
    override function update(elapsed:Float) { 
        super.update(elapsed);

        FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, Math.max(0, Math.min(curSelected - 8, options.length - 12)) * 200, Util.bound(elapsed * 10, 0, 1));

        if ((curOption.type != BOOL || curOption.type != null) && (FlxG.keys.anyPressed(Key.left) || FlxG.keys.anyPressed(Key.right))) holdTime += elapsed;
    }

    inline function isTitle(num:Int) return options[num].title != null;
}