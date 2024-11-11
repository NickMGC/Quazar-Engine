package states.options;

import objects.Checkbox;
import objects.Option;

class OptionsState extends MenuState {
    static var curSelected = 1;
    private var curOption:Option = null;

    final options:Array<{?option:Option, ?title:String, ?state:Class<FlxState>, ?add:Float}> = [ 
        {title: 'Gameplay Settings', add: 50},
        {option: new Option('Downscroll',            'Changes your note direction from up to down.',                    'downScroll')},
        {option: new Option('Middlescroll',          "Puts player's notes in the centre.",                              'middleScroll')},
        {option: new Option('Ghost Tapping',         "Tapping won't cause a miss when there's no notes to be hit.",     'ghostTapping')},
        {option: new Option('Flashing Lights',       "Includes flashing lights during some in-game moments.",           'flashingLights')},
        {option: new Option('Reset Character',       'Determines whether the character should reset or not.',           'reset'), add: 50},
        {option: new Option('Safe frames',           'Adjusts how strict the timing window is for hitting notes.',      'safeFrames', 'float').addProperties(.1, 2, 10, 5), add: 50},
        {option: new Option('Change Controls...',    null, null, 'state'), state: ControlsState},
        {option: new Option('Change Delay...',       null, null, 'state'), state: DelayState, add: 50},
        {title: 'Graphics Settings', add: 50},
        {option: new Option('Anti-Aliasing',         'Anti-Aliasing is used to make graphics look less pixelated.',     'antialiasing')},
        {option: new Option('GPU Rendering',         'Puts the workload on the GPU when rendering graphics.',           'gpuRendering')},
        {option: new Option('Shaders',               'Shaders are used for various visual effects.',                    'shaders')},
        {option: new Option('Show Debug statistics', "Shows debug stats, there's not much else that can be said.",      'showFPS')}
    ];

    var groups = {text: new FlxTypedSpriteGroup<Alphabet>(), options: new FlxTypedSpriteGroup<Alphabet>(), checkboxes: new FlxTypedSpriteGroup<Checkbox>(), lines: new FlxTypedSpriteGroup<FlxSprite>()};

    var curY = 60.;

    var desc:Alphabet;
    var bgClipped:QuazarSpr;

    function leBG() { //im very good at naming functions trust trust
        var bg = new QuazarSpr('menuDesat');
        bg.color = 0xFFea71fd;
        bg.scrollFactor.set();
        return bg;
    }

    override function create() {
        if (!FlxG.sound.music?.playing) FlxG.sound.playMusic(Path.music('freakyMenu'), .5);

        add(leBG());

        for (group in [groups.text, groups.options, groups.checkboxes, groups.lines]) add(group);

        add(bgClipped = leBG());
        bgClipped.clipRect = new flixel.math.FlxRect(0, 630, 1280, 90);

        add(desc = new Alphabet(0, 650, '', .7, false, CENTER));
        desc.scrollFactor.set();

        for (i in 0...options.length) {
            var option = new Alphabet(135, curY, isTitle(i) ? options[i].title : options[i].option.name, isTitle(i) ? .8 : .7, isTitle(i), isTitle(i) ? CENTER : LEFT);
            curY += 50 + options[i].add ?? 0;

            if (isTitle(i)) {
                option.screenCenter(X);

                groups.lines.add(new FlxSprite(90, option.y + 20).makeGraphic(Std.int(option.x) - 107, 4, FlxColor.BLACK));
                groups.lines.add(new FlxSprite(Std.int(option.x + option.width + 19), option.y + 20).makeGraphic(Std.int(1190 - (option.x + option.width + 18)), 4, FlxColor.BLACK));
            } else {
                if (options[i].option.type == 'bool')
                    groups.checkboxes.add(new Checkbox(1110, option.y - 2, options[i].option.getValue())).ID = i;
                else {
                    var text = new Alphabet(935, option.y, options[i].option.getValue(), .7, false, RIGHT);
                    text.autoSize = false;
                    groups.options.add(text).fieldWidth = 300;
            
                    options[i].option.child = text;
                    updateText(options[i].option);
                }
            }

            groups.text.add(option);
        }

        Key.onPress(Data.keyBinds['back'], () -> {
            Settings.save();
            Settings.load();

            Key.blockControls = true;
            FlxG.sound.play(Path.sound('cancelMenu'), .6);
            MenuState.switchState(new states.MainMenuState());
        });

        Key.onPress(Data.keyBinds['accept'], () -> {
            if (curOption.type == 'bool') {
                FlxG.sound.play(Path.sound('scrollMenu'), .4);

                curOption.setValue((curOption.getValue() == true) ? false : true);
                updateCheckbox();
            }

            if (options[curSelected].state != null) {
                Key.blockControls = true;
                MenuState.switchState(Type.createInstance(options[curSelected].state, []));
            }
        });

        //wish there was a less eye-sorey way of doing this...
        Key.onPress(Data.keyBinds['up'],    () -> changeItem(-1));
        Key.onPress(Data.keyBinds['down'],  () -> changeItem(1));
        Key.onPress(Data.keyBinds['left'],  () -> updateValue(-1));
        Key.onPress(Data.keyBinds['right'], () -> updateValue(1));
        Key.onHold (Data.keyBinds['left'],  () -> if(holdTime > 0.5) updateValue(-1, true));
        Key.onHold (Data.keyBinds['right'], () -> if(holdTime > 0.5) updateValue(1,  true));
        changeItem();

        super.create();
    }

    inline function updateCheckbox() for (checkbox in groups.checkboxes.members) if (checkbox != null && checkbox.ID == curSelected) checkbox.animation.play('${curOption.getValue() == true ? '' : 'un'}checked');

    function changeItem(huh = 0) {
        if (huh != 0) FlxG.sound.play(Path.sound('scrollMenu'), .4);

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

        if (curOption.type == 'bool' || curOption.type == 'state') return;
        if (FlxG.keys.anyPressed(Data.keyBinds['left']) || FlxG.keys.anyPressed(Data.keyBinds['right'])) holdTime += elapsed;
    }

    function updateValue(huh = 0, holding = false) {
        if (curOption.type == 'bool' || curOption.type == 'state') return;

        if (huh != 0) {
            if (curOption.type == 'string') curOption.curOption = ((curOption.curOption + (huh == -1 ? -1 : 1)) + curOption.options.length) % curOption.options.length;
            curOption.setValue(curOption.type == 'string' ? curOption.options[curOption.curOption] : updateTypes(huh));
            updateText(curOption);
            curOption.change();

            if (!holding) {
                FlxG.sound.play(Path.sound('scrollMenu'), .4);
                holdTime = 0;
            }
        }
    }

    function updateTypes(huh = 0) {
        var holdValue = FlxMath.bound((curOption.getValue() + (huh == -1 ? -curOption.changeValue : curOption.changeValue)), curOption.minValue, curOption.maxValue);

        return switch(curOption.type) {
            case 'int': holdValue = Math.round(holdValue);
            case 'float' | 'percent': holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
            default: holdValue;
        }
    }

    function updateText(option:Option) {
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;

		option.text = option.displayFormat.replace('%v', val).replace('%d', option.defaultValue);
	}

    inline function isTitle(num:Int) return options[num].title != null;
}