package objects;

@:publicFields class QuazarSpr extends FlxSprite {
	static var noAntialiasing = false;

	function new(?image:String, ?x = .0, ?y = .0, ?scrollX = 1., ?scrollY = 1., ?anims:Array<{name:String, prefix:String, fps:Int, ?loop:Bool}>, ?prefix:String) {
		super(x, y);

		if(image != null) {
			if (anims != null && anims.length > 0) {
				frames = Path.sparrowAtlas('${prefix != null ? '$prefix' : 'images'}/$image');
				for (anim in anims) animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.loop != null ? anim.loop : false);
			} else {
				loadGraphic(Path.image('${prefix != null ? '$prefix' : 'images'}/$image'));
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