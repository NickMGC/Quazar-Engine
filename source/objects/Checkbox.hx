package objects;

class Checkbox extends FlxSprite {
    public function new(x = 0., y = 0., ?check = false) {
        super(x, y);

        frames = Path.sparrow('images/options/checkbox');
		animation.addByPrefix('unchecked', 'unchecked', 0, false);
		animation.addByPrefix('checked', "checked0", 0, false);

        animation.play('${check ? '' : 'un'}checked');

        antialiasing = Data.antialiasing;
    }
}