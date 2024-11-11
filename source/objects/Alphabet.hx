package objects;

class Alphabet extends flixel.text.FlxBitmapText {
	public var bold = true;

	public function new(?x = .0, ?y = .0, ?text = '', ?scale, ?bold = true, ?align) {
		super(font);

		this.x = x;
		this.y = y;
		this.bold = bold;
		this.text = text;

		font = flixel.graphics.frames.FlxBitmapFont.fromAngelCode(Path.image(bold ? 'images/bold' : 'images/default'), Path.fnt('images/${bold ? 'bold' : 'default'}'));

		if (scale != null) {
			this.scale.set(scale, scale);
			this.updateHitbox();
		}

		if (bold) autoUpperCase = true;
		if (align != null) alignment = align;

		letterSpacing = bold ? -5 : -2;
		antialiasing = Data.antialiasing;
	}
}