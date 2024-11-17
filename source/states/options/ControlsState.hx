package states.options;

import flixel.input.keyboard.FlxKey;
import backend.KeyFormat;

class ControlsState extends MenuState {
    var keyGroup:FlxTypedSpriteGroup<Alphabet>;
    var optionGroup:FlxTypedSpriteGroup<Alphabet>;

    var curSelected = 2;

    var state = {binding: false, firstBind: true, waitTimer: 0.1, holdTime: 0.0, defaultBinds: null, tempBind1: null}; //sexy state array (im addicted to condensed code help)

    static final options:Array<{name:String, type:String, ?varName:String, ?add:Float, ?scale:Float, ?callback:Void -> Void}> = [
        {name: 'Controls',        add: 80,      type: 'title',   scale: .8},
        {name: 'Gameplay',        add: 30,      type: 'title',   scale: .5},

        {name: 'Left',   varName: 'note_left',  type: 'keybind'},
        {name: 'Down',   varName: 'note_down',  type: 'keybind'}, 
        {name: 'Up',     varName: 'note_up',    type: 'keybind'},
        {name: 'Right',  varName: 'note_right', type: 'keybind', add: 40},

        {name: 'Menu Navigation', add: 30,      type: 'title',   scale: .5},

        {name: 'Accept', varName: 'accept',     type: 'keybind'},
        {name: 'Back',   varName: 'back',       type: 'keybind'},
        {name: 'Pause',  varName: 'pause',      type: 'keybind'},
        {name: 'Reset',  varName: 'reset',      type: 'keybind', add: 50},

        {name: 'Test Inputs',    callback: null,                  type: 'action'},
        {name: 'Reset Controls', callback: resetControls,         type: 'action'}
    ];

    override function create() {
        final bg = new QuazarSpr('menuDesat');
        bg.color = 0xFFea71fd;
        for (obj in [bg, keyGroup = new FlxTypedSpriteGroup(), optionGroup = new FlxTypedSpriteGroup()]) add(obj);

        add(new FlxSprite(90, 120).makeGraphic(1100, 4, FlxColor.BLACK));

        var curY = 60.;
        for (i in 0...options.length) {
            var option = new Alphabet(options[i].type == 'title' ? 100 : 135, curY, options[i].name, options[i].scale ?? .5, options[i].type == 'title');
            curY += 30 + options[i].add ?? 0;

            if (options[i].type == 'keybind') {
                var binds = Data.keyBinds[options[i].varName];
                final key = new Alphabet(0, option.y, formatBindText(binds[1], binds[0]), .5, false, RIGHT);
                key.autoSize = false;
                key.fieldWidth = 1280;
                key.alpha = .6;
                keyGroup.add(key).ID = i;
            }

            optionGroup.add(option).ID = i;
        }

        optionGroup.members[0].screenCenter(X);
        optionGroup.members[11].x = optionGroup.members[12].x = 100;

        Key.onPress(Data.keyBinds['accept'], onAccept);
        Key.onPress(Data.keyBinds['back'],   onBack);
        Key.onPress(Data.keyBinds['up'],     onUp);
        Key.onPress(Data.keyBinds['down'],   onUp);
        changeItem();

        super.create();
    }

    inline function onUp()   if (!state.binding) changeItem(-1);
    inline function onDown() if (!state.binding) changeItem(1);

    function onBack() {
        if (state.binding) return;

        Key.blockControls = true;
        Settings.save();
        MenuState.switchState(new OptionsState());
        FlxG.sound.play(Path.sound('cancelMenu'), .6);
    }

    function onAccept() {
        if (state.binding || options[curSelected].type == 'title') return;

        var option = options[curSelected];

        FlxG.sound.play(Path.sound('scrollMenu'), .4);

        if (option.type == 'keybind') {
            state.binding = state.firstBind = true;
            state.waitTimer = .1;
            state.holdTime = 0;

            state.defaultBinds = [Data.keyBinds[option.varName][1], Data.keyBinds[option.varName][0]];

            updateBind('_', KeyFormat.display(state.defaultBinds[0]));
            optionGroup.members[curSelected].alpha = .6;

        } else if (option.type == 'action' && option.callback != null) option.callback();
    }

    function formatBindText(bind1:FlxKey, bind2:FlxKey):String return '[${formatBinds(bind1 != NONE ? bind1.toString() : null, bind2.toString())}]';
    function updateBind(bind1:Dynamic, bind2:Dynamic) for (key in keyGroup.members) if (key != null && key.ID == curSelected) key.text = formatBindText(bind1, bind2);

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!state.binding) return;

        state.waitTimer -= elapsed;

        if (state.waitTimer <= 0) {
            if (FlxG.keys.justPressed.ANY && FlxG.keys.firstJustPressed() > -1) {
                bind(FlxG.keys.firstJustPressed());
                return;
            }

            if (FlxG.keys.pressed.ESCAPE || FlxG.keys.pressed.BACKSPACE) {
                state.holdTime += elapsed;
                if (state.holdTime > .5) {
                    state.binding = false;

                    updateBind(state.defaultBinds[0], state.defaultBinds[1]);
                    optionGroup.members[curSelected].alpha = 1;
                    FlxG.sound.play(Path.sound('cancelMenu'), .6);
                }
            } else state.holdTime = 0;
        }
    }

    function bind(key:Int) {
        if (state.firstBind) {
            state.tempBind1 = key;
            state.firstBind = false;
            updateBind(key, '_');
            state.waitTimer = .1;
        } else {
            state.binding = false;
            state.firstBind = true;
            Data.keyBinds[options[curSelected].varName] = [key, state.tempBind1];
            updateBind(state.tempBind1, key);
            optionGroup.members[curSelected].alpha = 1;
        }
    }

    static function resetControls() {
        Settings.resetKeys();
        FlxG.resetState();
        FlxTransitionableState.skipNextTransOut = true;
    }

    function changeItem(change:Int = 0) {
        if (change != 0) FlxG.sound.play(Path.sound('scrollMenu'), .4);
        do (curSelected = (curSelected + change + options.length) % options.length) while (options[curSelected].type == 'title');

        for (option in optionGroup.members) if (option != null && options[option.ID].type != 'title') option.alpha = option.ID == curSelected ? 1 : .6;
    }

    function formatBinds(bind1:String, bind2:String):String return '${bind1 != null ? '${KeyFormat.display(bind1.toLowerCase())}, ' : ''}${KeyFormat.display(bind2.toLowerCase())}';
}