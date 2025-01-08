package objects;

class Alphabet extends flixel.text.FlxBitmapText {
	public var bold = true;

	public function new(?x = .0, ?y = .0, ?text = '', ?scale:Float, ?bold = true, ?align:FlxTextAlign) {
		super(font);

		this.x = x;
		this.y = y;
		this.bold = bold;
		this.text = text;

		font = flixel.graphics.frames.FlxBitmapFont.fromAngelCode(Path.image(bold ? 'bold' : 'default'), Path.fnt('images/${bold ? 'bold' : 'default'}'));

		if (scale != null) this.setScale(scale);

		if (bold) autoUpperCase = true;
		if (align != null) alignment = align;

		letterSpacing = bold ? -5 : -2;
		antialiasing = Data.antialiasing;
	}

	public function setAlign(align:FlxTextAlign, fieldWidth:Int):Alphabet {
		autoSize = false;
		alignment = align;
		this.fieldWidth = fieldWidth;
		return this;
	}

	//flixel 5.9.0 fucked up and didnt account for centered text so heres a band-aid fix for now, will make a pr later
	#if (flixel >= "5.9.0")
	override function computeTextSize() {
		var txtWidth = textWidth;
		final txtHeight = textHeight + 2 * padding;

		txtWidth = autoSize ? txtWidth + (padding * 2) : fieldWidth;

		frameWidth = (txtWidth == 0) ? 1 : txtWidth;
		frameHeight = (txtHeight == 0) ? 1 : txtHeight;
	}
	#end
}

typedef FlxAlphabetGroup = FlxTypedSpriteGroup<Alphabet>;