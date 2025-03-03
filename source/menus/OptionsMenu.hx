package menus;

class OptionsMenu extends Scene {
	static var curOption:Option;
	static var curSelected:Int = 0;

	var categories:Array<OptionCategory> = [
		new OptionCategory('Gameplay Settings', [
			Option.bool('Downscroll', 'Changes your note direction from up to down.', Data.downScroll, v -> Data.downScroll = v),
			Option.bool('Middlescroll', "Puts player's notes in the centre.", Data.middleScroll, v -> Data.middleScroll = v),
			Option.bool('Ghost Tapping', "Tapping won't cause a miss when there's no notes to be hit.", Data.ghostTapping, v -> Data.ghostTapping = v),
			Option.bool('Flashing Lights', "Includes flashing lights during some in-game moments.", Data.flashingLights, v -> Data.flashingLights = v),
			Option.bool('Reset Character', "Determines whether the character should reset or not.", Data.reset, v -> Data.reset = v),
			Option.float('Safe frames', 'Adjusts how strict the timing window is for hitting notes.', Data.safeFrames, v -> Data.safeFrames = v).bound(2, 10),
			Option.state('Change Controls...', '', ControlsMenu.new),
			Option.state('Change Delay...', '', DelayMenu.new)
		]),
		new OptionCategory('Graphics Settings', [
			//Option.add('Screen Resolution', "Choose a desired screen resolution.", Data.screenRes, ['1920×1080', '1600×900', '1366×768', '1280x720', '1152×648', '1024×576'], v -> Data.screenRes = v),
			Option.int('Framerate', "Choose the desired framerate. It's best if you set it to your monitor's refresh rate.", Data.framerate, v -> {
				if(v > FlxG.drawFramerate) {
					FlxG.updateFramerate = v;
					FlxG.drawFramerate = v;
				} else {
					FlxG.drawFramerate = v;
					FlxG.updateFramerate = v;
				}

				Data.framerate = v;
			}).bound(30, 500),
			Option.bool('Anti-Aliasing', 'Anti-Aliasing is used to make graphics look less pixelated.', Data.antialiasing, v -> Data.antialiasing = v),
			Option.bool('GPU Rendering', 'Puts the workload on the GPU when rendering graphics.', Data.gpuRendering, v -> Data.gpuRendering = v),
			Option.bool('Shaders', 'Shaders are used for various visual effects.', Data.shaders, v -> Data.shaders = v),
			Option.bool('Show Debug statistics', "Shows debug statistics like Framerate and Memory.", Data.showFPS, v -> Init.fpsCounter.visible = Data.showFPS = v)
		])
		// new OptionCategory('Visual Settings', [
		// TODO: yeah man
		// ])
	];

	var options:Array<DisplayOption> = [];

	var descBG:FlxSprite;
	var desc:Alphabet;

	var curY:Float = 60;

	inline function Background() return Sprite('ui/menuDesat').setScrollFactor().setColor(0xFFea71fd);

	override function create() {
		if (!Music.playing) Music.play('freakyMenu', 0.5);

		add(Background());

		for (i => category in categories) createCategory(category, i);

		add(descBG = Background().setClipRect(0, 630, 1280, 90));
		add(desc = new Alphabet(30, 650, '', 0.7, false).setScrollFactor());

		initControls();
		changeItem();

		FlxG.camera.scroll.y = Util.bound(options[curSelected].y - 170, 0, categories[options[curSelected].index].length);

		super.create();
	}

	function onAccept() {
		curOption.updateValue();

		if (curOption.type != 'bool') return;

		options[curSelected].updateValue();
		Sound.play('scroll', 0.4);
	}

	function onBack() {
		Controls.block = true;

		Settings.save();
		switchState(MainMenu.new);

		Sound.play('cancel', 0.6);
	}

	private function createCategory(category:OptionCategory, index:Int) {
		final title = new Alphabet(90, curY, category.name, 0.8, true);
		add(title);
		add(Graphic(Std.int(109 + title.width), curY + 20, Std.int(1190 - (108 + title.width)), 4, FlxColor.BLACK));

		curY += 60;

		for (num => option in category.options) {
			curY += (num > 0 && options[options.length - 1].option.type != option.type) ? 90 : 50;

			final displayOption = new DisplayOption(option, curY, options.length, index);
			add(displayOption);
			options.push(displayOption);
		}

		final lastOption = options[options.length - 1];
		categories[index].length = lastOption.y + lastOption.height + 186 - FlxG.height;

		curY += 120;
	}

	function valueChange(dir:Int = 0, hold:Bool = false) {
		if ((curOption.type == 'bool' || curOption.type == 'state') || hold && holdTime < 0.5) return;

		curOption.updateValue(dir);
		options[curSelected].updateValue();

		if (hold) return;

		Sound.play('scroll', 0.4);
		holdTime = 0;
	}

	function changeItem(dir:Int = 0) {
		if (dir != 0) Sound.play('scroll', 0.4);

		curSelected = (curSelected + dir + options.length) % options.length;

		curOption = options[curSelected].option;

		descBG.visible = curOption.desc != '';
		desc.text = curOption.desc;

		for (i => option in options) option.label.alpha = i == curSelected ? 1 : 0.6;
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float) { 
		super.update(elapsed);

		FlxG.camera.scroll.y = FlxMath.roundDecimal(Util.lerp(FlxG.camera.scroll.y, Util.bound(options[curSelected].y - 170, 0, categories[options[curSelected].index].length), 10), 2);

		if (curOption.type != 'bool' && curOption.type != 'state' && (FlxG.keys.anyPressed(Key.left) || FlxG.keys.anyPressed(Key.right))) holdTime += elapsed;
	}

	override function destroy() {
		super.destroy();
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