package handlers;

import flixel.system.FlxAssets.FlxGraphicAsset;

@:publicFields class SpriteHandler {
    static function loadFrames<T:FlxSprite>(sprite:T, path:FlxGraphicAsset, ?prefix:String = 'images'):T {
        sprite.frames = Path.sparrow(path, prefix);
        sprite.updateHitbox();
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.addByPrefix)
    inline static function addPrefix<T:FlxSprite>(sprite:T, name:String, prefix:String, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
        sprite.animation.addByPrefix(name, prefix, fps, loop, flipX, flipY);
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.addByIndices)
    inline static function addIndices<T:FlxSprite>(sprite:T, name:String, prefix:String, indices:Array<Int>, postfix:String, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
        sprite.animation.addByIndices(name, prefix, indices, postfix, fps, loop, flipX, flipY);
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.play)
	inline static function playAnim<T:FlxSprite>(sprite:T, name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):T {
        sprite.animation.play(name, force, reversed, frame);
        return sprite;
    }

	inline static function onAnimFinish<T:FlxSprite>(sprite:T, callback:(animName:String) -> Void):T {
        #if (flixel >= "5.9.0")
        sprite.animation.onFinish.add(callback);
        #else
        sprite.animation.finishCallback = callback;
        #end
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.finish)
	inline static function finishAnim<T:FlxSprite>(sprite:T):T {
        sprite.animation.finish();
        return sprite;
    }

    /** Forces the sprite to draw to the graphics buffer. Useful for preloading assets.*/
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

    /** Sets the desired color.*/
    inline static function setColor<T:FlxSprite>(sprite:T, color:Int):T {
        sprite.color = color;
        return sprite;
    }

    @:inheritDoc(flixel.FlxSprite.centerOrigin)
    inline static function centerOrigins<T:FlxSprite>(sprite:T):T {
        sprite.centerOrigin();
        return sprite;
    }

    @:inheritDoc(flixel.FlxSprite.centerOffsets)
    inline static function centerOffset<T:FlxSprite>(sprite:T, AdjustPosition:Bool = false):T {
        sprite.centerOffsets(AdjustPosition);
        return sprite;
    }

    /**
     * Creates a sparrow animated sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
    static function Sparrow(?x:Float = 0, ?y:Float = 0, path:FlxGraphicAsset, ?prefix:String = 'images'):FlxSprite {
        var sprite = new FlxSprite(x, y);
        sprite.frames = Path.sparrow(path, prefix);
        sprite.updateHitbox();
        return sprite;
    }


    /**
     * Creates a sparrow animated sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
    static function Packer(?x:Float = 0, ?y:Float = 0, path:FlxGraphicAsset, ?prefix:String = 'images'):FlxSprite {
        var sprite = new FlxSprite(x, y);
        sprite.frames = Path.packer(path, prefix);
        sprite.updateHitbox();
        return sprite;
    }

    /**
     * Creates a sparrow animated sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
    static function Aseprite(?x:Float = 0, ?y:Float = 0, path:FlxGraphicAsset, ?prefix:String = 'images'):FlxSprite {
        var sprite = new FlxSprite(x, y);
        sprite.frames = Path.aseprite(path, prefix);
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
     * Creates a graphic.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param width   The width of the rectangle.
     * @param height  The height of the rectangle.
     * @param color   The color of the rectangle.
     */
	static function Graphic(x:Float, y:Float, width:Int, height:Int, color:FlxColor):FlxSprite {
        var sprite = new FlxSprite(x, y);
        sprite.makeGraphic(width, height, color);
        sprite.updateHitbox();
        sprite.active = false;
        return sprite;
    }
}