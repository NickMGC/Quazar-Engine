package states.options;

import objects.Option;

class OptionsState extends MenuState {
    static var curSelected = 1;
    var curOption:Option = null;

    final options:Array<{?option:Option, ?title:String, ?state:NextState, ?add:Float}> = [ 
        {title: 'Gameplay Settings', add: 50},
        {option: new Option('Downscroll',            'Changes your note direction from up to down.',                    'downScroll')},
        {option: new Option('Middlescroll',          "Puts player's notes in the centre.",                              'middleScroll')},
        {option: new Option('Ghost Tapping',         "Tapping won't cause a miss when there's no notes to be hit.",     'ghostTapping')},
        {option: new Option('Flashing Lights',       "Includes flashing lights during some in-game moments.",           'flashingLights')},
        {option: new Option('Reset Character',       'Determines whether the character should reset or not.',           'reset'), add: 50},
        {option: new Option('Safe frames',           'Adjusts how strict the timing window is for hitting notes.',      'safeFrames', 'float').addProperties(.1, 2, 10, 5), add: 50},
        {option: new Option('Change Controls...',    null, null, 'state'), state: ControlsState.new},
        {option: new Option('Change Delay...',       null, null, 'state'), state: DelayState.new, add: 50},
        {title: 'Graphics Settings', add: 50},
        {option: new Option('Anti-Aliasing',         'Anti-Aliasing is used to make graphics look less pixelated.',     'antialiasing')},
        {option: new Option('GPU Rendering',         'Puts the workload on the GPU when rendering graphics.',           'gpuRendering')},
        {option: new Option('Shaders',               'Shaders are used for various visual effects.',                    'shaders')},
        {option: new Option('Show Debug statistics', "Shows debug statistics like Framerate and Memory.",               'showFPS')}
    ];

    var groups = {text: new FlxAlphabetGroup(), options: new FlxAlphabetGroup(), checkboxes: new FlxSpriteGroup(), lines: new FlxSpriteGroup()};

    var desc:Alphabet;
    var bgClipped:FlxSprite;

    inline function background() return Sprite('menuDesat').setScrollFactor().setColor(0xFFea71fd);

    override function create() {
        if (!FlxG.sound.music?.playing) playMusic('freakyMenu', .5);

        add(background());

        for (group in [groups.text, groups.options, groups.checkboxes, groups.lines]) add(group);

        add(bgClipped = background());
        bgClipped.clipRect = new flixel.math.FlxRect(0, 630, 1280, 90);

        add(desc = new Alphabet(0, 650, '', .7, false, CENTER).setScrollFactor());

        var curY = 60.;

        for (i in 0...options.length) {
            var option = new Alphabet(135, curY, isTitle(i) ? options[i].title : options[i].option.name, isTitle(i) ? .8 : .7, isTitle(i), isTitle(i) ? CENTER : LEFT);
            curY += 50 + options[i].add ?? 0;

            if (isTitle(i)) {
                option.screenCenter(X);

                groups.lines.add(Graphic(90, option.y + 20, Std.int(option.x) - 107, 4, FlxColor.BLACK));
                groups.lines.add(Graphic(Std.int(option.x + option.width + 19), option.y + 20, Std.int(1190 - (option.x + option.width + 18)), 4, FlxColor.BLACK));
            } else {
                switch(options[i].option.type) {
                    case 'bool':
                        final checkbox = Sparrow(1110, option.y - 2, 'options/checkbox').addPrefix('unchecked', 'unchecked', 0, false).addPrefix('checked', 'checked', 0, false);
                        groups.checkboxes.add(checkbox).playAnim('${options[i].option.getValue() ? '' : 'un'}checked').ID = i;
                    default:
                        var text = new Alphabet(935, option.y, options[i].option.getValue(), .7, false, RIGHT);
                        text.autoSize = false;
                        groups.options.add(text).fieldWidth = 500;
                
                        options[i].option.child = text;
                        updateText(options[i].option);
                }
            }

            groups.text.add(option);
        }

        onPress(back, () -> {
            Settings.save();
            Settings.load();

            blockControls = true;
            playSound('cancelMenu', .6);
            switchState(states.MainMenuState.new);
        });

        onPress(accept, () -> {
            if (curOption.type == 'bool') {
                playSound('scrollMenu', .4);
    
                curOption.setValue((curOption.getValue() == true) ? false : true);

                for (checkbox in groups.checkboxes.members) if (checkbox != null && checkbox.ID == curSelected)
                    checkbox.playAnim('${curOption.getValue() == true ? '' : 'un'}checked');
            }

            if (options[curSelected].state != null) {
                blockControls = true;
                switchState(options[curSelected].state);
            }
        });

        for (dir => val in [up => -1, down => 1]) onPress(dir, () -> changeItem(val));

        for (dir => val in [left => -1, right => 1]) {
            onPress(dir, () -> updateValue(val));
            onHold(dir, () -> if(holdTime > .5) updateValue(val, true));
        }

        changeItem();

        super.create();
    }

    function changeItem(huh = 0) {
        if (huh != 0) playSound('scrollMenu', .4);

        do {
            curSelected = (curSelected + huh + options.length) % options.length;
            curOption = options[curSelected].option;

            desc.text = curOption?.desc ?? '';
            desc.screenCenter(X);
        } while (isTitle(curSelected));

        bgClipped.visible = curOption.type != 'state';

        for (num => option in groups.text.members) if (!option.bold) option.alpha = num == curSelected ? 1 : .6;
    }

	var holdTime = .0;
    override function update(elapsed:Float) { 
        super.update(elapsed);

        FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, Math.max(0, Math.min(curSelected - 8, options.length - 12)) * 200, Util.bound(elapsed * 10, 0, 1));

        if ((curOption.type != 'bool' || curOption.type != 'state') && (FlxG.keys.anyPressed(Data.keyBinds['left']) || FlxG.keys.anyPressed(Data.keyBinds['right']))) holdTime += elapsed;
    }

    function updateValue(huh = 0, holding = false) {
        if (curOption.type == 'bool' || curOption.type == 'state') return;

        curOption.setValue(updateTypes(huh));
        updateText(curOption);
        curOption.change();

        if (!holding) {
            FlxG.sound.play(Path.sound('scrollMenu'), .4);
            holdTime = 0;
        }
    }

    function updateTypes(huh = 0):Dynamic {
        final holdValue = FlxMath.bound((curOption.getValue() + (huh * curOption.changeValue)), curOption.minValue, curOption.maxValue);

        return switch(curOption.type) {
            case 'int': Math.round(holdValue);
            case 'float' | 'percent': FlxMath.roundDecimal(holdValue, curOption.decimals);
            case 'string':
                curOption.curOption = (curOption.curOption + huh + curOption.options.length) % curOption.options.length;
                curOption.options[curOption.curOption];
            default: curOption.getValue();
        }
    }

    function updateText(option:Option) {
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;

		option.text = option.displayFormat.replace('%v', val).replace('%d', option.defaultValue);
	}

    inline function isTitle(num:Int) return options[num].title != null;
}