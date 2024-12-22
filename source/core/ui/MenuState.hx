package core.ui;

@:publicFields class MenuState extends FlxState {
	override function create() {
		persistentUpdate = persistentDraw = true;

		if(!skipNextTransOut) add(new Transition(false));
		skipNextTransOut = blockControls = false;

		super.create();

		Path.clearUnusedMemory();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
	}

	override function startOutro(onOutroComplete:Void -> Void) {
		if (skipNextTransIn) {
			skipNextTransIn = false;
			return super.startOutro(onOutroComplete);
		}

		add(new Transition(true, onOutroComplete));
	}
}

class Transition extends flixel.addons.display.FlxBackdrop {
	public function new(?transIn = false, ?finish:Void -> Void) {
		super(Path.image('ui/transition'), Y);

		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];

		this.setScale(scale.x / camera.zoom, scale.y / camera.zoom).setScrollFactor();

		final center = (FlxG.width - width) / 2;
		final offscreen = width / camera.zoom;

		final targetPos = transIn ? center : -offscreen;
		final ease = transIn ? FlxEase.circIn : FlxEase.circOut;

		x = transIn ? offscreen : center;

		FlxTween.num(x, targetPos, .3, {ease: ease, onComplete: (_) -> (!skipNextTransOut && finish == null) ? FlxDestroyUtil.destroy(this) : finish(), startDelay: transIn ? 0 : .15}, (v) -> x = v);
	}
}