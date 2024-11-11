package objects;

@:publicFields class QuazarSpr extends FlxSprite {
	static var noAntialiasing = false;
	static var animInfo:Array<{name:String, prefix:String, fps:Int, ?loop:Bool}>;

	function new(?image:String, ?x = .0, ?y = .0, ?scrollX = 1., ?scrollY = 1., ?anims:Array<{name:String, prefix:String, fps:Int, ?loop:Bool}>) {
		super(x, y);

		animInfo = anims;

		if(image != null) {
			if (animInfo != null && animInfo.length > 0) {
				frames = Path.sparrowAtlas('images/$image');
				for (anim in animInfo) animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.loop != null ? anim.loop : false);
			} else {
				loadGraphic(Path.image('images/$image'));
				active = false;
			}
		}

		noAntialiasing = !Data.antialiasing;
		antialiasing = !noAntialiasing;

		scrollFactor.set(scrollX, scrollY);
		updateHitbox();
	}

	inline function precache():QuazarSpr {
		final og = alpha;
		alpha = .00001;
		draw();
		alpha = og;

		return this;
	}
}