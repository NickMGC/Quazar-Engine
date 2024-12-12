package core;

@:publicFields class SpriteHandler {
    /**
     * Adds a new animation to the sprite.
     * 
     * @param Name 	  What this animation should be called (e.g. `"run"`).
     * @param Prefix  Common beginning of image names in atlas (e.g. `"tiles-"`).
     * @param FPS     The animation speed in frames per second. Note: individual frames have their own duration, which overrides this value.
     * @param Loop    Whether or not the animation is looped or just plays once.
     * @param FlipX   Whether the frames should be flipped horizontally.
     * @param FlipY   Whether the frames should be flipped vertically.
     */
    inline static function addPrefix<T:FlxSprite>(sprite:T, name:String, prefix:String, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
        sprite.animation.addByPrefix(name, prefix, fps, loop, flipX, flipY);
        return sprite;
    }

    /**
     * Adds a new animation to the sprite.
     * 
     * @param Name 	  What this animation should be called (e.g. `"run"`).
     * @param Prefix  Common beginning of image names in atlas (e.g. `"tiles-"`).
     * @param Indices An array of numbers indicating what frames to play in what order (e.g. `[0, 1, 2]`).
     * @param FPS     The speed in frames per second that the animation should play at (e.g. `40` fps).
     * @param Loop    Whether or not the animation is looped or just plays once.
     * @param FlipX   Whether the frames should be flipped horizontally.
     * @param FlipY   Whether the frames should be flipped vertically.
     */
    inline static function addIndices<T:FlxSprite>(sprite:T, name:String, prefix:String, indices:Array<Int>, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
        sprite.animation.addByIndices(name, prefix, indices, '', fps, loop, flipX, flipY);
        return sprite;
    }

    /**
     * Forces the sprite to draw to the graphics buffer. Useful for preloading assets.
     */
    inline static function precache<T:FlxSprite>(sprite:T):T {
		if (sprite != null) {
            final ogAlpha = sprite.alpha;
            sprite.alpha = .00001;
            sprite.draw();
            sprite.alpha = ogAlpha;
        }
        return sprite;
    }

    /**
     * Plays an existing animation (e.g. `"run"`). If you call an animation that is already playing, it will be ignored.
     *
     * @param name      The string name of the animation you want to play.
     * @param force     Whether to force the animation to restart.
     * @param reversed  Whether to play animation backwards or not.
     * @param frame     The frame number in the animation you want to start from. If a negative value is passed, a random frame is used.
     *
     */
	inline static function playAnim<T:FlxSprite>(sprite:T, name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):T {
        sprite.animation.play(name, force, reversed, frame);
        return sprite;
    }

    /**
     * Stops current animation and sets its frame to the last one.
     */
	inline static function finishAnim<T:FlxSprite>(sprite:T):T {
        sprite.animation.finish();
        return sprite;
    }

    /**
     * Sets the desired scale along with automatically adjusting the hitbox.
     *
     * @param x  The X-coordinate of the point in space.
     * @param y  The Y-coordinate of the point in space.
     *
     */
    inline static function setScale<T:FlxSprite>(sprite:T, ?x:Float, ?y:Float):T {
        sprite.scale.set(x, y ?? x);
        sprite.updateHitbox();
        return sprite;
    }

    /**
     * Sets the desired origin.
     *
     * @param x  The X-coordinate of the point in space.
     * @param y  The Y-coordinate of the point in space.
     *
     */
    inline static function setOrigin<T:FlxSprite>(sprite:T, ?x:Float, ?y:Float):T {
        sprite.origin.set(x, y);
        return sprite;
    }

    /**
     * Sets the desired offset.
     *
     * @param x  The X-coordinate of the point in space.
     * @param y  The Y-coordinate of the point in space.
     *
     */
    inline static function setOffset<T:FlxSprite>(sprite:T, ?x:Float, ?y:Float):T {
        sprite.origin.set(x, y);
        return sprite;
    }

    /**
     * Sets the desired scroll factor.
     *
     * @param x  The X-coordinate of the point in space.
     * @param y  The Y-coordinate of the point in space.
     *
     */
    inline static function setScrollFactor<T:FlxSprite>(sprite:T, ?x:Float, ?y:Float):T {
        sprite.scrollFactor.set(x, y);
        return sprite;
    }

    /**
     * Sets the desired color.
     *
     * @param color  The X-coordinate of the point in space.
     *
     */
    inline static function setColor<T:FlxSprite>(sprite:T, color:Int):T {
        sprite.color = color;
        return sprite;
    }

    /**
     * Creates a sparrow animated sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
    static function Sparrow(?x:Float = 0, ?y:Float = 0, path:String, ?prefix:String = 'images'):FlxSprite {
        var sprite = new FlxSprite(x, y);
        sprite.frames = Path.sparrow(path, prefix);
        sprite.updateHitbox();
        return sprite;
    }

    /**
     * Creates a sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
	static function Sprite(?x:Float = 0, ?y:Float = 0, path:String, ?prefix:String = 'images'):FlxSprite {
        var sprite = new FlxSprite(x, y);
        sprite.loadGraphic(Path.image(path, prefix));
        sprite.updateHitbox();
        sprite.active = false;

        return sprite;
    }

    /**
     * Creates a square.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param width   The width of the rectangle.
     * @param height  The height of the rectangle.
     * @param color   The color of the rectangle.
     */
	static function Square(x:Float, y:Float, width:Int, height:Int, color:FlxColor):FlxSprite {
        var sprite = new FlxSprite(x, y);
        sprite.makeGraphic(width, height, color);
        sprite.updateHitbox();
        sprite.active = false;
        return sprite;
    }
}