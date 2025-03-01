package tools;

import openfl.display.BlendMode;

inline function loadImage<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
	sprite.loadGraphic(Path.image(path, prefix));
	sprite.updateHitbox();
	return sprite;
}

inline function createGraphic<T:FlxSprite>(sprite:T, width:Int, height:Int, color:FlxColor):T {
	sprite.makeGraphic(width, height, color);
	sprite.updateHitbox();
	return sprite;
}

inline function loadSparrowFrames<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
	sprite.frames = Path.sparrow(path, prefix);
	sprite.updateHitbox();
	return sprite;
}

inline function loadPackerFrames<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
	sprite.frames = Path.packer(path, prefix);
	sprite.updateHitbox();
	return sprite;
}

inline function loadAsepriteFrames<T:FlxSprite>(sprite:T, path:String, prefix:String = 'images'):T {
	sprite.frames = Path.aseprite(path, prefix);
	sprite.updateHitbox();
	return sprite;
}

@:inheritDoc(flixel.animation.FlxAnimationController.addByPrefix)
inline function addPrefix<T:FlxSprite>(sprite:T, name:String, prefix:String, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
	sprite.animation.addByPrefix(name, prefix, fps, loop, flipX, flipY);
	return sprite;
}

@:inheritDoc(flixel.animation.FlxAnimationController.addByIndices)
inline function addIndices<T:FlxSprite>(sprite:T, name:String, prefix:String, indices:Array<Int>, postfix:String, fps:Float = 24, loop:Bool = true, flipX:Bool = false, flipY:Bool = false):T {
	sprite.animation.addByIndices(name, prefix, indices, postfix, fps, loop, flipX, flipY);
	return sprite;
}

@:inheritDoc(flixel.animation.FlxAnimationController.play)
inline function playAnim<T:FlxSprite>(sprite:T, name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):T {
	sprite.animation.play(name, force, reversed, frame);
	return sprite;
}

@:inheritDoc(flixel.animation.FlxAnimationController.pause)
inline function pauseAnim<T:FlxSprite>(sprite:T):T {
	sprite.animation.pause();
	return sprite;
}

@:inheritDoc(flixel.animation.FlxAnimationController.resume)
inline function resumeAnim<T:FlxSprite>(sprite:T):T {
	sprite.animation.resume();
	return sprite;
}

inline function onAnimFinish<T:FlxSprite>(sprite:T, callback:(animName:String) -> Void):T {
	sprite.animation.onFinish.add(callback);
	return sprite;
}

@:inheritDoc(flixel.animation.FlxAnimationController.finish)
inline function finishAnim<T:FlxSprite>(sprite:T):T {
	sprite.animation.finish();
	return sprite;
}

/** Forces the sprite to draw to the graphics buffer. Useful for preloading assets.*/
inline function precache<T:FlxSprite>(sprite:T):T {
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
inline function setScale<T:FlxSprite>(sprite:T, ?x:Float, ?y:Float):T {
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
inline function setOrigin<T:FlxSprite>(sprite:T, x:Float = 0, y:Float = 0):T {
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
inline function setOffset<T:FlxSprite>(sprite:T, x:Float = 0, y:Float = 0):T {
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
inline function setScrollFactor<T:FlxObject>(object:T, x:Float = 0, y:Float = 0):T {
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
inline function setVelocity<T:FlxObject>(object:T, x:Float = 0, y:Float = 0):T {
	object.velocity.set(x, y);
	return object;
}

/** Sets the desired alpha.*/
inline function setAlpha<T:FlxSprite>(sprite:T, alpha:Float):T {
	sprite.alpha = alpha;
	return sprite;
}

/** Sets the visibility on an object.*/
inline function setVisible<T:FlxBasic>(basic:T, visible:Bool):T {
	basic.visible = visible;
	return basic;
}

/** Controls whether `update()` is automatically called by `FlxState/FlxGroup`.*/
inline function setActive<T:FlxBasic>(basic:T, active:Bool):T {
	basic.active = active;
	return basic;
}

/** Sets the antialiasing.*/
inline function setAntialiasing<T:FlxSprite>(sprite:T, antialiasing:Bool):T {
	sprite.antialiasing = antialiasing;
	return sprite;
}

/** Blending modes, just like Photoshop or whatever, e.g. `"multiply"`, `"screen"`, etc.*/
inline function setBlendMode<T:FlxSprite>(sprite:T, blend:BlendMode):T {
	sprite.blend = blend;
	return sprite;
}

/** Sets the desired color.*/
inline function setColor<T:FlxSprite>(sprite:T, color:Int):T {
	sprite.color = color;
	return sprite;
}

/** Sets the desired id.*/
inline function setID<T:FlxBasic>(basic:T, id:Int):T {
	basic.ID = id;
	return basic;
}

@:inheritDoc(flixel.FlxSprite.centerOrigin)
inline function centerOrigins<T:FlxSprite>(sprite:T):T {
	sprite.centerOrigin();
	return sprite;
}

@:inheritDoc(flixel.FlxSprite.centerOffsets)
inline function centerOffset<T:FlxSprite>(sprite:T, AdjustPosition:Bool = false):T {
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
inline function setClipRect<T:FlxSprite>(sprite:T, X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0):T {
	sprite.clipRect = new flixel.math.FlxRect(X, Y, Width, Height);
	return sprite;
}