package tools;

import openfl.display.BlendMode;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;

//TODO: write description for this
class SpriteHandler {
    public static function loadImage<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
        sprite.loadGraphic(Path.image(path, prefix));
        sprite.updateHitbox();
        return sprite;
    }

    public static function createGraphic<T:FlxSprite>(sprite:T, width:Int, height:Int, color:FlxColor):T {
        sprite.makeGraphic(width, height, color);
        sprite.updateHitbox();
        return sprite;
    }

    public static function loadSparrowFrames<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
        sprite.frames = Path.sparrow(path, prefix);
        sprite.updateHitbox();
        return sprite;
    }

    public static function loadPackerFrames<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
        sprite.frames = Path.packer(path, prefix);
        sprite.updateHitbox();
        return sprite;
    }

    public static function loadAsepriteFrames<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
        sprite.frames = Path.aseprite(path, prefix);
        sprite.updateHitbox();
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.addByPrefix)
    inline public static function addPrefix<T:FlxSprite>(sprite:T, name:String, prefix:String, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
        sprite.animation.addByPrefix(name, prefix, fps, loop, flipX, flipY);
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.addByIndices)
    inline public static function addIndices<T:FlxSprite>(sprite:T, name:String, prefix:String, indices:Array<Int>, postfix:String, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
        sprite.animation.addByIndices(name, prefix, indices, postfix, fps, loop, flipX, flipY);
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.play)
	inline public static function playAnim<T:FlxSprite>(sprite:T, name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):T {
        sprite.animation.play(name, force, reversed, frame);
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.pause)
    inline public static function pauseAnim<T:FlxSprite>(sprite:T):T {
        sprite.animation.pause();
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.resume)
    inline public static function resumeAnim<T:FlxSprite>(sprite:T):T {
        sprite.animation.resume();
        return sprite;
    }

	inline public static function onAnimFinish<T:FlxSprite>(sprite:T, callback:(animName:String) -> Void):T {
        sprite.animation.onFinish.add(callback);
        return sprite;
    }

    @:inheritDoc(flixel.animation.FlxAnimationController.finish)
	inline public static function finishAnim<T:FlxSprite>(sprite:T):T {
        sprite.animation.finish();
        return sprite;
    }

    /** Forces the sprite to draw to the graphics buffer. Useful for preloading assets.*/
    inline public static function precache<T:FlxSprite>(sprite:T):T {
		if (sprite != null) {
            final ogAlpha = sprite.alpha;
            sprite.setAlpha(0.00001).draw();
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
    inline public static function setScale<T:FlxSprite>(sprite:T, ?x:Float, ?y:Float):T {
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
    inline public static function setOrigin<T:FlxSprite>(sprite:T, x:Float = 0, y:Float = 0):T {
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
    inline public static function setOffset<T:FlxSprite>(sprite:T, x:Float = 0, y:Float = 0):T {
        sprite.offset.set(x, y);
        return sprite;
    }

    /**
     * Sets the desired scroll factor.
     *
     * @param x  The X-coordinate of the point in space.
     * @param y  The Y-coordinate of the point in space.
     *
     */
    inline public static function setScrollFactor<T:FlxObject>(object:T, x:Float = 0, y:Float = 0):T {
        object.scrollFactor.set(x, y);
        return object;
    }

    /**
     * Sets the desired velocity.
     *
     * @param x  The X-coordinate of the point in space.
     * @param y  The Y-coordinate of the point in space.
     *
     */
    inline public static function setVelocity<T:FlxObject>(object:T, x:Float = 0, y:Float = 0):T {
        object.velocity.set(x, y);
        return object;
    }

    /** Sets the desired alpha.*/
    inline public static function setAlpha<T:FlxSprite>(sprite:T, alpha:Float):T {
        sprite.alpha = alpha;
        return sprite;
    }

    /** Sets the visibility on an object.*/
    inline public static function setVisible<T:FlxBasic>(basic:T, visible:Bool):T {
        basic.visible = visible;
        return basic;
    }

    /** Controls whether `update()` is automatically called by `FlxState/FlxGroup`.*/
    inline public static function setActive<T:FlxBasic>(basic:T, active:Bool):T {
        basic.active = active;
        return basic;
    }

    /** Sets the antialiasing.*/
    inline public static function setAntialiasing<T:FlxSprite>(sprite:T, antialiasing:Bool):T {
        sprite.antialiasing = antialiasing;
        return sprite;
    }

    /** Blending modes, just like Photoshop or whatever, e.g. `"multiply"`, `"screen"`, etc.*/
    inline public static function setBlendMode<T:FlxSprite>(sprite:T, blend:BlendMode):T {
        sprite.blend = blend;
        return sprite;
    }

    /** Sets the desired color.*/
    inline public static function setColor<T:FlxSprite>(sprite:T, color:Int):T {
        sprite.color = color;
        return sprite;
    }

    /** Sets the desired id.*/
    inline public static function setID<T:FlxBasic>(basic:T, id:Int):T {
        basic.ID = id;
        return basic;
    }

    @:inheritDoc(flixel.FlxSprite.centerOrigin)
    inline public static function centerOrigins<T:FlxSprite>(sprite:T):T {
        sprite.centerOrigin();
        return sprite;
    }

    @:inheritDoc(flixel.FlxSprite.centerOffsets)
    inline public static function centerOffset<T:FlxSprite>(sprite:T, AdjustPosition:Bool = false):T {
        sprite.centerOffsets(AdjustPosition);
        return sprite;
    }

    /**
     * Creates a clip rect for the sprite.
     * @param x       The X-coordinate of the clip rect.
     * @param y       The Y-coordinate of the clip rect.
     * @param width   The width of the clip rect.
     * @param height  The height of the clip rect.
     */
    inline public static function setClipRect<T:FlxSprite>(sprite:T, X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0):T {
        sprite.clipRect = new flixel.math.FlxRect(X, Y, Width, Height);
        return sprite;
    }

    /**
     * Creates a sparrow animated sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
    static public function Sparrow(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
        return new FlxSprite(x, y).loadSparrowFrames(path, prefix);
    }


    /**
     * Creates a sparrow animated sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
    static public function Packer(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
        return new FlxSprite(x, y).loadPackerFrames(path, prefix);
    }

    /**
     * Creates a sparrow animated sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
    static public function Aseprite(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
        return new FlxSprite(x, y).loadAsepriteFrames(path, prefix);
    }

    /**
     * Creates a sprite.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
	static public function Sprite(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
        return new FlxSprite(x, y).loadImage(path, prefix).setActive(false);
    }

    /**
     * Creates a graphic.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param width   The width of the rectangle.
     * @param height  The height of the rectangle.
     * @param color   The color of the rectangle.
     */
	static public function Graphic(x:Float = 0, y:Float = 0, width:Int, height:Int, color:FlxColor):FlxSprite {
        return new FlxSprite(x, y).createGraphic(width, height, color).setActive(false);
    }

    //TODO: document backdrop
    /**
     * Creates a backdrop.
     * @param x       The X-coordinate of the point in space.
     * @param y       The Y-coordinate of the point in space.
     * @param path    The path to the image.
     * @param prefix  The folder the image is located at. Defaults to `"images"`.
     */
	static public function Backdrop(x:Float = 0, y:Float = 0, path:String, repeatAxes:FlxAxes = XY, spacingX:Float = 0, spacingY:Float = 0, velocityX:Float = 0, velocityY:Float = 0, prefix:String = 'images'):FlxBackdrop {
        var sprite = new FlxBackdrop(Path.image(path, prefix), repeatAxes, spacingX, spacingY).setVelocity(velocityX, velocityY).setActive(false);
        sprite.setPosition(x, y);
        sprite.updateHitbox();
        sprite.moves = true;

        return sprite;
    }
}