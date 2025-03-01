package tools;

import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;

/**
 * Creates a sparrow animated sprite.
 * @param x       The X-coordinate of the point in space.
 * @param y       The Y-coordinate of the point in space.
 * @param path    The path to the image.
 * @param prefix  The folder the image is located at. Defaults to `"images"`.
 */
inline function Sparrow(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
	return new FlxSprite(x, y).loadSparrowFrames(path, prefix);
}


/**
 * Creates a sparrow animated sprite.
 * @param x       The X-coordinate of the point in space.
 * @param y       The Y-coordinate of the point in space.
 * @param path    The path to the image.
 * @param prefix  The folder the image is located at. Defaults to `"images"`.
 */
inline function Packer(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
	return new FlxSprite(x, y).loadPackerFrames(path, prefix);
}

/**
 * Creates a sparrow animated sprite.
 * @param x       The X-coordinate of the point in space.
 * @param y       The Y-coordinate of the point in space.
 * @param path    The path to the image.
 * @param prefix  The folder the image is located at. Defaults to `"images"`.
 */
inline function Aseprite(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
	return new FlxSprite(x, y).loadAsepriteFrames(path, prefix);
}

/**
 * Creates a sprite.
 * @param x       The X-coordinate of the point in space.
 * @param y       The Y-coordinate of the point in space.
 * @param path    The path to the image.
 * @param prefix  The folder the image is located at. Defaults to `"images"`.
 */
inline function Sprite(path:String, x:Float = 0, y:Float = 0, prefix:String = 'images'):FlxSprite {
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
inline function Graphic(x:Float = 0, y:Float = 0, width:Int, height:Int, color:FlxColor):FlxSprite {
	return new FlxSprite(x, y).createGraphic(width, height, color).setActive(false);
}

/**
 * Creates a backdrop.
 * @param x          The X-coordinate of the point in space.
 * @param y          The Y-coordinate of the point in space.
 * @param path       The path to the image.
 * @param repeatAxes The axes on which to repeat. The default, `XY` will tile the entire camera.
 * @param spacingX   Amount of spacing between tiles on the X axis.
 * @param spacingY   Amount of spacing between tiles on the Y axis.
 * @param velocityX  Amount of velocity applied on the X axis.
 * @param velocityY  Amount of velocity applied on the Y axis.
 * @param spacingY   Amount of spacing between tiles on the Y axis.
 * @param prefix     The folder the image is located at. Defaults to `"images"`.
 */
function Backdrop(x:Float = 0, y:Float = 0, path:String, repeatAxes:FlxAxes = XY, spacingX:Float = 0, spacingY:Float = 0, velocityX:Float = 0, velocityY:Float = 0, prefix:String = 'images'):FlxBackdrop {
	var sprite = new FlxBackdrop(Path.image(path, prefix), repeatAxes, spacingX, spacingY).setVelocity(velocityX, velocityY).setActive(false);
	sprite.setPosition(x, y);
	sprite.updateHitbox();
	sprite.moves = true;

	return sprite;
}