package objects;

@:publicFields class QuazarSpr extends FlxSprite {
	function new(?image:String, ?x = .0, ?y = .0, ?anims:Array<{name:String, prefix:String, fps:Int, ?loop:Bool}>, ?prefix:String) {
		super(x, y);

		if(image != null) {
			if (anims != null && anims.length > 0) {
				frames = Path.sparrow('${prefix != null ? '$prefix' : 'images'}/$image');
				for (anim in anims) animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.loop != null ? anim.loop : false);
			} else {
				loadGraphic(Path.image('${prefix != null ? '$prefix' : 'images'}/$image'));
				active = false;
			}
		}

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