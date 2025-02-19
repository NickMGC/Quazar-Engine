package menus;

import flixel.input.keyboard.FlxKey;
import tools.KeyFormat;

typedef KeyItem = {name:String, ?varName:String, ?type:String, ?add:Float, ?scale:Float, ?callback:Void -> Void}

//TODO: recode controls cuz holy shit this code is bad
class ControlsMenu extends Scene {
    var keyGroup:Array<Alphabet> = [];
    var optionGroup:Array<Alphabet> = [];

    var curSelected:Int = 2;
    var curOption:KeyItem;

    var binding:Bool = false;
    var firstBind:Bool = true;

    var waitTimer:Float = 0.1;
    var holdTime:Float = 0;

    var defaultBinds:Array<Int> = [];
    var tempBind1:Int;

    final options:Array<KeyItem> = [
        {name: 'Controls', type: 'title', scale: 0.8, add: 80},
        {name: 'Gameplay', type: 'title', scale: 0.5, add: 30},

        {name: 'Left',  varName: 'left_note',  type: 'keybind'},
        {name: 'Down',  varName: 'down_note',  type: 'keybind'},
        {name: 'Up',    varName: 'up_note',    type: 'keybind'},
        {name: 'Right', varName: 'right_note', type: 'keybind', add: 40},

        {name: 'Menu Navigation', type: 'title', scale: 0.5, add: 30},

        {name: 'Accept', varName: 'accept', type: 'keybind'},
        {name: 'Back',   varName: 'back',   type: 'keybind'},
        {name: 'Pause',  varName: 'pause',  type: 'keybind'},
        {name: 'Reset',  varName: 'reset',  type: 'keybind', add: 50},

        {name: 'Test Inputs', type: 'action'},
        {name: 'Reset Controls', type: 'action'}
    ];

    override function create() {
        add(Sprite('menuDesat').setColor(0xFFea71fd));
        add(Graphic(90, 120, 1100, 4, FlxColor.BLACK));

        for (i in 0...options.length) {
            var option = new Alphabet(options[i].type == 'title' ? 100 : 135, 60, options[i].name, options[i].scale ?? 0.5, options[i].type == 'title').setID(i);
            for (j in 0...i) option.y += 30 + options[j].add ?? 0;
            add(option);
            optionGroup.push(option);

            if (options[i].type == 'keybind') {
                var binds:Array<Int> = Data.keyBinds[options[i].varName];
                keyGroup.push(new Alphabet(0, optionGroup[i].y, '[${KeyFormat.display(binds[0])}, ${KeyFormat.display(binds[1])}]', 0.5, false).setAlign(RIGHT, 1280).setID(i).setAlpha(0.6));
                add(keyGroup[keyGroup.length - 1]);
            }
        }

        options[12].callback = resetControls;

        optionGroup[0].screenCenter(X);
        for (i in [11, 12]) optionGroup[i].x = 100;

        initControls();
        changeItem();

        super.create();
    }

    function onAccept() {
        if (binding || curOption.type == 'title') return;

        Sound.play('scroll', .4);

        if (curOption.type == 'keybind') {
            binding = firstBind = true;
            waitTimer = 0.1;
            holdTime = 0;

            defaultBinds = Data.keyBinds[curOption.varName];
            updateBind('_', defaultBinds[1]);

            optionGroup[curSelected].alpha = 0.6;
            for (key in keyGroup) if (key?.ID == curSelected) key.alpha = 1;

        } else if (curOption.type == 'action' && curOption.callback != null) curOption.callback();
    }

    function onBack() {
        if (binding) return;

        Controls.block = true;
        Settings.save();
        Settings.load();
        switchState(OptionsMenu.new);
        Sound.play('cancel', 0.6);
    }

    inline function onUp() changeItem(-1);
    inline function onDown() changeItem(1);

    function updateBind(bind1:FlxKey, bind2:FlxKey) for (key in keyGroup) if (key?.ID == curSelected) key.text = '[${KeyFormat.display(bind1)}, ${KeyFormat.display(bind2)}]';

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!binding) return;

        waitTimer -= elapsed;
        if (waitTimer > 0) return;

        if (FlxG.keys.justPressed.ANY && FlxG.keys.firstJustPressed() > -1) {
            bind(FlxG.keys.firstJustPressed());
            return;
        }

        FlxG.keys.pressed.ESCAPE || FlxG.keys.pressed.BACKSPACE ? cancelBind(elapsed) : holdTime = 0;
    }

    function cancelBind(elapsed:Float) {
        holdTime += elapsed;
        if (holdTime < 0.5) return;

        binding = false;

        updateBind(defaultBinds[0], defaultBinds[1]);
        optionGroup[curSelected].alpha = 1;

        for (key in keyGroup) if (key?.ID == curSelected) key.alpha = 0.6;
        Sound.play('cancel', 0.6);
    }

    function bind(key:Int) {
        if (firstBind) {
            tempBind1 = key;
            firstBind = false;
            updateBind(key, '_');

            return;
        }

        binding = false;

        final binds:Array<Int> = Data.keyBinds[curOption.varName] = [tempBind1, key];
        updateBind(binds[0], binds[1]);
        optionGroup[curSelected].alpha = 1;
        for (key in keyGroup) if (key?.ID == curSelected) key.alpha = 0.6;
    }

    function resetControls() {
        Settings.resetKeys();

        for (key in keyGroup) {
            if (key == null) return;

            final newBinds:Array<Int> = Data.keyBinds[options[key.ID].varName];
            key.text = '[${KeyFormat.display(newBinds[0])}, ${KeyFormat.display(newBinds[1])}]';
        }
    }

    function changeItem(change:Int = 0) {
        if (binding) return;

        if (change != 0) Sound.play('scroll', 0.4);

        do {
            curSelected = (curSelected + change + options.length) % options.length;
            curOption = options[curSelected];
        } while (curOption.type == 'title');

        for (option in optionGroup) if (options[option?.ID].type != 'title') option.alpha = option.ID == curSelected ? 1 : 0.6;
    }

    function initControls() {
        Key.onPress(Key.accept, onAccept);
        Key.onPress(Key.back, onBack);
        Key.onPress(Key.up, onUp);
        Key.onPress(Key.down, onDown);
    }
}