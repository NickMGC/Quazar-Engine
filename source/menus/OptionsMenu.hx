package menus;

class OptionsMenu extends Scene {
    static var curOption:Option;

    static var curSelected:Int = 0;
    static var curCategory:Int = 0;

    var categories:Array<OptionCategory> = [
        new OptionCategory('Gameplay Settings', [
            Option.bool('Downscroll', 'Changes your note direction from up to down.', Data.downScroll, v -> Data.downScroll = v),
            Option.bool('Middlescroll', "Puts player's notes in the centre.", Data.middleScroll, v -> Data.middleScroll = v),
            Option.bool('Ghost Tapping', "Tapping won't cause a miss when there's no notes to be hit.", Data.ghostTapping, v -> Data.ghostTapping = v),
            Option.bool('Flashing Lights', "Includes flashing lights during some in-game moments.", Data.flashingLights, v -> Data.flashingLights = v),
            Option.bool('Reset Character', "Determines whether the character should reset or not.", Data.reset, v -> Data.reset = v),
            Option.float('Safe frames', 'Adjusts how strict the timing window is for hitting notes.', Data.safeFrames, v -> Data.safeFrames = v, 0.1, 2, 2, 10),
            Option.state('Change Controls...', '', ControlsMenu.new),
            Option.state('Change Delay...', '', DelayMenu.new)
        ]),
        new OptionCategory('Graphics Settings', [
            //Option.string('Screen Resolution', "Choose a desired screen resolution.", Data.screenRes, ['1920×1080', '1600×900', '1366×768', '1280x720', '1152×648', '1024×576'], v -> Data.screenRes = v),
            //Option.string('Double Framerate', "Whether the framerate gets doubled or not. Useful for precision.", Data.doubleFPS, v -> Data.doubleFPSs = v),
            Option.bool('Anti-Aliasing', 'Anti-Aliasing is used to make graphics look less pixelated.', Data.antialiasing, v -> Data.antialiasing = v),
            Option.bool('GPU Rendering', 'Puts the workload on the GPU when rendering graphics.', Data.gpuRendering, v -> Data.gpuRendering = v),
            Option.bool('Shaders', 'Shaders are used for various visual effects.', Data.shaders, v -> Data.shaders = v),
            Option.bool('Show Debug statistics', "Shows debug statistics like Framerate and Memory.", Data.showFPS, v -> Init.fpsCounter.visible = Data.showFPS = v)
        ])
        // new OptionCategory('Visual Settings', [
        // TODO: yeah man
        // ])
    ];

    var displayOptions:Array<DisplayOption> = [];

    var categoryLengths:Array<Float> = [];
    var options:Array<Option> = [];

    var descBG:FlxSprite;
    var desc:Alphabet;

    var curY:Float = 60;

    inline function Background() return Sprite('menuDesat').setScrollFactor().setColor(0xFFea71fd);

    override function create() {
        if (!Music.playing) Music.play('freakyMenu', 0.5);

        add(Background());

        for (i => category in categories) {
            createTitles(category.name);
            createOptions(category.options, i);
        }

        add(descBG = Background().setClipRect(0, 630, 1280, 90));
        add(desc = new Alphabet(30, 650, '', 0.7, false).setScrollFactor());

        initControls();
        changeItem();

        super.create();

        FlxG.camera.scroll.y = Util.bound(displayOptions[curSelected].y - 170, 0, categoryLengths[curCategory]);
    }

    function onAccept() {
        curOption.updateValue();

        if (curOption.type != 'bool') return;

        displayOptions[curSelected].updateValue();
        Sound.play('scroll', 0.4);
    }

    function onBack() {
        Sound.play('cancel', 0.6);

        Controls.block = true;
        switchState(MainMenu.new);
    }

    private function createTitles(name:String) {
        final title = new Alphabet(90, curY, name, 0.8, true);
        add(title);

        add(Graphic(Std.int(109 + title.width), curY + 20, Std.int(1082 - title.width), 4, FlxColor.BLACK));
        curY += 60;
    }

    private function createOptions(items:Array<Option>, index:Int) {
        for (num => option in items) {
            option.categoryIndex = index;
            options.push(option);

            curY += (num > 0 && options[options.length - 2].type != option.type) ? 90 : 50;

            displayOptions.push(new DisplayOption(option, curY, displayOptions.length));
            add(displayOptions[displayOptions.length - 1]);
        }

        final lastOption = displayOptions[displayOptions.length - 1];
        categoryLengths.push(lastOption.y + lastOption.height + 186 - FlxG.height);

        curY += 120;
    }

    function valueChange(dir:Int = 0, hold:Bool = false) {
        if ((curOption.type == 'bool' || curOption.type == 'state') || hold && holdTime < 0.5) return;

        curOption.updateValue(dir);
        displayOptions[curSelected].updateValue();

        if (hold) return;

        Sound.play('scroll', 0.4);
        holdTime = 0;
    }

    function changeItem(dir:Int = 0) {
        if (dir != 0) Sound.play('scroll', 0.4);

        curSelected = (curSelected + dir + options.length) % options.length;
        curOption = options[curSelected];
        curCategory = curOption.categoryIndex;

        descBG.visible = curOption.desc != '';
        desc.text = curOption.desc;

        for (option in displayOptions) option.setSelected(option.ID == curSelected);
    }

	var holdTime:Float = 0;
    override function update(elapsed:Float) { 
        super.update(elapsed);

        FlxG.camera.scroll.y = FlxMath.roundDecimal(Util.lerp(FlxG.camera.scroll.y, Util.bound(displayOptions[curSelected].y - 170, 0, categoryLengths[curCategory]), 10), 2);

        if (curOption.type != 'bool' && curOption.type != 'state' && (FlxG.keys.anyPressed(Key.left) || FlxG.keys.anyPressed(Key.right))) holdTime += elapsed;
    }

    override function destroy() {
        super.destroy();

        Settings.save();
        Settings.load();
    }

    function initControls() {
        Key.onPress(Key.accept, onAccept);
        Key.onPress(Key.back, onBack);

        Key.onPress(Key.left, onLeft);
        Key.onPress(Key.down, onDown);
        Key.onPress(Key.up, onUp);
        Key.onPress(Key.right, onRight);

        Key.onHold(Key.left, onLeftHold);
        Key.onHold(Key.right, onRightHold);
    }

    inline function onUp() changeItem(-1);
    inline function onDown() changeItem(1);

    inline function onLeft() valueChange(-1);
    inline function onRight() valueChange(1);

    inline function onLeftHold() valueChange(-1, true);
    inline function onRightHold() valueChange(1, true);
}