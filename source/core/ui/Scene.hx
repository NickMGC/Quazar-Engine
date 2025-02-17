package core.ui;

class Scene extends FlxState {
	override function create() {
		persistentUpdate = persistentDraw = true;

		super.create();

		if (!skipNextTransOut) {
			var trans = new Transition();

			function destroyTrans() trans = FlxDestroyUtil.destroy(trans);

			trans.finish = destroyTrans;
			add(trans);
		}

		skipNextTransOut = Controls.block = false;

		Path.clearUnusedMemory();
	}

	override function startOutro(onOutroComplete:Void -> Void) {
		if (skipNextTransIn) {
			skipNextTransIn = false;
			return super.startOutro(onOutroComplete);
		}

		var trans = new Transition(true);
		trans.finish = onOutroComplete;
		add(trans);
	}
}

//TODO: figure out how to make this on top of everything
class Transition extends FlxBackdrop {
	public var finish:Void -> Void;

	public function new(?transIn:Bool = false) {
		super(Path.image('ui/transition'), Y);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		this.setScale(scale.x / camera.zoom, scale.y / camera.zoom).setScrollFactor();

		final center:Float = (FlxG.width - width) / 2;
		final offscreen:Float = width / camera.zoom;

		FlxTween.num(transIn ? offscreen : center, transIn ? center : -offscreen, 0.3, {
			ease: transIn ? FlxEase.circIn : FlxEase.circOut,
			onComplete: onFinish,
			startDelay: transIn ? 0 : 0.15
		}, move);
	}

	inline function move(value:Float) x = value;
	inline function onFinish(_:FlxTween) finish();
}