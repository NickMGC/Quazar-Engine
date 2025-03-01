package;

class Scene extends FlxState {
	override function create():Void {
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

	override function startOutro(onOutroComplete:Void -> Void):Void {
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
		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];

		super(Path.image('ui/transition'), Y);

		this.setScale(scale.x / camera.zoom, scale.y / camera.zoom).setScrollFactor();

		final center:Float = (FlxG.width - width) / 2;
		final offscreen:Float = width / camera.zoom;

		var target:TargetInfo;
		target = transIn ? {from: offscreen, to: center, ease: FlxEase.circIn, delay: 0} : {from: center, to: -offscreen, ease: FlxEase.circOut, delay: 0.15};

		FlxTween.num(target.from, target.to, 0.3, {ease: target.ease, onComplete: onFinish, startDelay: target.delay}, move);
	}

	inline function move(value:Float):Void {
		x = value;
	}

	inline function onFinish(_:FlxTween):Void {
		finish();
	}
}

typedef TargetInfo = {from:Float, to:Float, ease:Float -> Float, delay:Float};