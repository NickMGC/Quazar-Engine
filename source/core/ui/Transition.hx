package core.ui;

class Transition extends FlxSubState {
	public static var finish:Void -> Void;

	public function new(?transIn = false) {
		super();

		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];

		final trans = new QuazarSpr('ui/transition');
		trans.scale.set(trans.scale.x / camera.zoom, trans.scale.y / camera.zoom);
		trans.updateHitbox();
		trans.scrollFactor.set();
		add(trans);

		final center = (FlxG.width - trans.width) / 2;
		final offscreen = trans.width / camera.zoom;

		trans.x = transIn ? offscreen : center;

		FlxTween.num(trans.x, transIn ? center : -offscreen, .3, {ease: transIn ? FlxEase.circIn : FlxEase.circOut, onComplete: (_) -> finish(), startDelay: transIn ? 0 : .15}, (v) -> trans.x = v);
	}
}