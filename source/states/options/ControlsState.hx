package states.options;

import flixel.input.keyboard.FlxKey;
import backend.KeyFormat;

//it works but jesus christ its messy.,././,.,.///,./,. i dont even understand my own code
//reminder to refactor when my lazy bum gets to do so
class ControlsState extends MenuState {
    var curSelected = 2;

    var keyGroup:FlxTypedSpriteGroup<Alphabet>;
    var optionGroup:FlxTypedSpriteGroup<Alphabet>;

    var curY = 60.;

    var binding = false;
    var bindingSecondKey = false;
    var changed = false;

    var defaultBind1:String;
    var defaultBind2:String;

    final options:Array<{?title:Title, ?keyBind:KeyBind}> = [ 
        {title:   {name: 'Controls', center: true, add: 80}},
        {title:   {name: 'GAMEPLAY', add: 30, scale: .5}},

        {keyBind: {name: 'Left',   variable: Data.keyBinds['note_left'], varName: 'note_left'}},
        {keyBind: {name: 'Down',   variable: Data.keyBinds['note_down'], varName: 'note_down'}},
        {keyBind: {name: 'Up',     variable: Data.keyBinds['note_up'], varName: 'note_up'}},
        {keyBind: {name: 'Right',  variable: Data.keyBinds['note_right'], varName: 'note_right', add: 40}},

        {title:   {name: 'MENU NAVIGATION', add: 30, scale: .5}},

        {keyBind: {name: 'Accept', variable: Data.keyBinds['accept'], varName: 'accept'}},
        {keyBind: {name: 'Back',   variable: Data.keyBinds['back'], varName: 'back'}},
        {keyBind: {name: 'Pause',  variable: Data.keyBinds['pause'], varName: 'pause'}},
        {keyBind: {name: 'Reset',  variable: Data.keyBinds['reset'], varName: 'reset', add: 50}},
        {keyBind: {name: 'Test Inputs'}},
        {keyBind: {name: 'Reset Controls'}}
    ];

    override function create() {
        final bg = new QuazarSpr('menuDesat');
        bg.color = 0xFFea71fd;
        add(bg);

        add(keyGroup = new FlxTypedSpriteGroup());
        add(optionGroup = new FlxTypedSpriteGroup());
        
        add(new FlxSprite(90, 120).makeGraphic(1100, 4, FlxColor.BLACK));

        options[12].keyBind.callback = () -> resetControls();
        
        for (i in 0...options.length) {
            var option = new Alphabet(isTitle(i) ? 100 : 135, curY, isTitle(i) ? options[i].title.name : options[i].keyBind.name, isTitle(i) ? (options[i].title.scale ?? .8) : .5, isTitle(i));
            curY += 30 + (isTitle(i) ? options[i].title.add : options[i].keyBind.add) ?? 0;

            if (!isTitle(i) && options[i].keyBind.variable != null) {
                final firstBind:String = options[i].keyBind.variable[1];
                final secondBind:String = options[i].keyBind.variable[0];

                var bind = new Alphabet(0, option.y, '[${firstBind != null ? KeyFormat.display(firstBind.toLowerCase()) + ', ' : ''}${KeyFormat.display(secondBind.toLowerCase())}]', .5, false, RIGHT);
                bind.autoSize = false;
                bind.alpha = .6;
                bind.fieldWidth = 1280;
                keyGroup.add(bind).ID = i;
            }

            optionGroup.add(option).ID = i;
        }

        optionGroup.members[0].screenCenter(X);
        optionGroup.members[11].x = optionGroup.members[12].x = 100;

        Key.onPress(Data.keyBinds['up'], () -> changeItem(-1));
        Key.onPress(Data.keyBinds['down'], () -> changeItem(1));
        changeItem();

        Key.onPress(Data.keyBinds['accept'], () -> {
            if (!isTitle(curSelected) && !binding && !bindingSecondKey) {
                FlxG.sound.play(Path.sound('scrollMenu'), .4);
                if (options[curSelected].keyBind.variable != null) {
                    allowed = binding = true;
                    waitTimer = .1;

                    defaultBind1 = options[curSelected].keyBind.variable[1];
                    defaultBind2 = options[curSelected].keyBind.variable[0];

                    for (key in keyGroup.members) if (key != null && key.ID == curSelected) {
                        key.alpha = 1;
                        key.text = '[_, ${Util.capitalize(defaultBind2)}]';
                    }

                    for (option in optionGroup.members) if (option != null && option.ID == curSelected) option.alpha = .6;

                } else if (options[curSelected].keyBind.callback != null) options[curSelected].keyBind.callback();
            }
        });

        Key.onHold(Data.keyBinds['back'], () -> {
            if (binding || bindingSecondKey) {
                binding = bindingSecondKey = false;

                for (key in keyGroup.members) if (key != null && key.ID == curSelected) {
                    key.alpha = .6;
                    key.text = '[${defaultBind1 != null ? KeyFormat.display(defaultBind1) + ', ' : ''}${KeyFormat.display(defaultBind2)}]';
                }

                optionGroup.members[curSelected].alpha = 1;
                changed = false;
            } else {
                Key.blockControls = true;
                Settings.save();
                MenuState.switchState(new OptionsState());
            }

            FlxG.sound.play(Path.sound('cancelMenu'), .6);
        });

        super.create();
    }

    function resetControls() {
        Settings.resetKeys();
        FlxG.resetState(); //too lazy to update the text lol
        FlxTransitionableState.skipNextTransOut = true;
    }

    function changeItem(huh = 0) {
        if (!binding && !bindingSecondKey) {
            if (huh != 0) FlxG.sound.play(Path.sound('scrollMenu'), .4);

            do curSelected = (curSelected + huh + options.length) % options.length while (isTitle(curSelected));

            for (num => option in optionGroup.members) if (!option.bold) option.alpha = num == curSelected ? 1 : .6;
        }
    }

    //HORRIBLE CODE AHEAD!!!!1

    var waitTimer = .1;
    var allowed = false;

    var tempBind1:String;
    var realBind1:Int;
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (allowed) waitTimer -= elapsed;

        if ((binding || bindingSecondKey) && waitTimer <= 0) {
            allowed = false;

            if(FlxG.keys.justPressed.ANY) {
                if (FlxG.keys.firstJustPressed() > -1) {
                    if (binding) {
                        realBind1 = FlxG.keys.firstJustPressed();
                        tempBind1 = KeyFormat.display(FlxG.keys.firstJustPressed());
                        binding = false;
                        bindingSecondKey = allowed = true;

                        waitTimer = .1;

                        for (key in keyGroup.members) if (key != null && key.ID == curSelected) key.text = '[${tempBind1}, _]';
                    } else if (bindingSecondKey) {
                        final newBind2 = KeyFormat.display(FlxG.keys.firstJustPressed());
                        bindingSecondKey = false;
                            
                        for (key in keyGroup.members) if (key != null && key.ID == curSelected) {
                            key.text = '[${tempBind1}, ${newBind2}]';
                            key.alpha = .6;
                        }

                        if (options[curSelected].keyBind.variable != null) options[curSelected].keyBind.variable = [newBind2, tempBind1];

                        optionGroup.members[curSelected].alpha = 1;
                        changed = true;

                        for (name => value in Data.keyBinds) if (name == options[curSelected].keyBind.varName) Data.keyBinds[name] = [FlxG.keys.firstJustPressed(), realBind1];
                    }
                }
            }
        }
    }

    inline function isTitle(num:Int):Bool return options[num].title != null;
}
typedef Title = {name:String, ?center:Bool, ?add:Float, ?scale:Float}
typedef KeyBind = {name:String, ?variable:Array<FlxKey>, ?varName:String, ?add:Float, ?callback:Void -> Void}