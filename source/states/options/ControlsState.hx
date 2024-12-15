package states.options;

import flixel.input.keyboard.FlxKey;
import core.controls.KeyFormat;

typedef MenuItem = {name:String, ?varName:String, ?type:String, ?add:Float, ?scale:Float, ?callback:() -> Void}

class ControlsState extends MenuState {
    var keyGroup:FlxAlphabetGroup;
    var optionGroup:FlxAlphabetGroup;

    var curSelected = 2;

    var binding = false;
    var firstBind = true;

    var waitTimer = .1;
    var holdTime = .0;

    var defaultBinds:Array<Int> = [];
    var tempBind1:Int;

    final options:Array<MenuItem> = [
        {name: 'Controls', type: 'title', scale: .8, add: 80},
        {name: 'Gameplay', type: 'title', scale: .5, add: 30},

        {name: 'Left',  varName: 'left_note',  type: 'keybind'},
        {name: 'Down',  varName: 'down_note',  type: 'keybind'},
        {name: 'Up',    varName: 'up_note',    type: 'keybind'},
        {name: 'Right', varName: 'right_note', type: 'keybind', add: 40},

        {name: 'Menu Navigation', type: 'title', scale: .5, add: 30},

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

        add(keyGroup = new FlxAlphabetGroup());
        add(optionGroup = new FlxAlphabetGroup());

        options[12].callback = resetControls;

        var curY = 60.;
        for (i in 0...options.length) {
            var option = new Alphabet(options[i].type == 'title' ? 100 : 135, curY, options[i].name, options[i].scale ?? .5, options[i].type == 'title');
            curY += 30 + options[i].add ?? 0;

            if (options[i].type == 'keybind') {
                var binds = Data.keyBinds[options[i].varName];
                final key = new Alphabet(0, option.y, '[${KeyFormat.display(binds[0])}, ${KeyFormat.display(binds[1])}]', .5, false).setAlign(RIGHT, 1280);
                key.alpha = .6;
                keyGroup.add(key).ID = i;
            }

            optionGroup.add(option).ID = i;
        }

        optionGroup.members[0].screenCenter(X);
        for(i in [11, 12]) optionGroup.members[i].x = 100;

        onPress(accept, () -> {
            if (!binding && options[curSelected].type != 'title') {
                var option = options[curSelected];

                playSound('scrollMenu', .4);
        
                if (option.type == 'keybind') {
                    binding = firstBind = true;
                    waitTimer = .1;
                    holdTime = 0;
        
                    defaultBinds = Data.keyBinds[option.varName];
                    updateBind('_', defaultBinds[1]);

                    optionGroup.members[curSelected].alpha = .6;
                    for (key in keyGroup.members) if (key?.ID == curSelected) key.alpha = 1;
        
                } else if (option.type == 'action' && option.callback != null) option.callback();
            }
        });

        onPress(back, () -> {
            if (!binding) {
                blockControls = true;
                Settings.save();
                Settings.load();
                switchState(OptionsState.new);
                playSound('cancelMenu', .6);
            }
        });

        for (dir => val in [up => -1, down => 1]) onPress(dir, () -> if (!binding) changeItem(val));

        changeItem();

        super.create();
    }

    function updateBind(bind1:FlxKey, bind2:FlxKey) for (key in keyGroup.members) if (key?.ID == curSelected) key.text = '[${KeyFormat.display(bind1)}, ${KeyFormat.display(bind2)}]';

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
        if (holdTime < .5) return;

        binding = false;

        updateBind(defaultBinds[0], defaultBinds[1]);
        optionGroup.members[curSelected].alpha = 1;
        playSound('cancelMenu', .6);
    }

    function bind(key:Int) {
        if (firstBind) {
            tempBind1 = key;
            firstBind = false;
            updateBind(key, '_');
        } else {
            binding = false;

            final binds = Data.keyBinds[options[curSelected].varName] = [tempBind1, key];
            updateBind(binds[0], binds[1]);
            optionGroup.members[curSelected].alpha = 1;
            for (key in keyGroup.members) if (key?.ID == curSelected) key.alpha = .6;
        }
    }

    function resetControls() {
        Settings.resetKeys();

        for (key in keyGroup.members) if (key != null) {
            final newBinds = Data.keyBinds[options[key.ID].varName];
            key.text = '[${KeyFormat.display(newBinds[0])}, ${KeyFormat.display(newBinds[1])}]';
        }
    }

    function changeItem(change:Int = 0) {
        if (change != 0) playSound('scrollMenu', .4);
        do (curSelected = (curSelected + change + options.length) % options.length) while (options[curSelected].type == 'title');

        for (option in optionGroup.members) if (options[option?.ID].type != 'title') option.alpha = option.ID == curSelected ? 1 : .6;
    }
}