package objects;

import flixel.text.FlxBitmapText;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxText;

class Alphabet extends FlxBitmapText {
	public var bold:Bool = true;

	public function new(x:Float = 0, y:Float = 0, text:String = '', scale:Float = 1, bold:Bool = true, alignment:FlxTextAlign = LEFT) {
		super(x, y, text, FlxBitmapFont.fromAngelCode(Path.image('ui/${bold ? 'bold' : 'default'}'), Path.fnt('images/ui/${bold ? 'bold' : 'default'}')));

		this.alignment = alignment;
		this.bold = bold;

		this.setScale(scale);

		if (bold) {
			autoUpperCase = true;
			letterSpacing = -5;
			lineSpacing = -15;
		} else
			letterSpacing = -2;
	}

	public function setAlign(alignment:FlxTextAlign, fieldWidth:Int):Alphabet {
		autoSize = false;
		this.alignment = alignment;
		this.fieldWidth = fieldWidth;
		return this;
	}

	public function setFieldWidth(fieldWidth:Int):Alphabet {
		autoSize = false;
		this.fieldWidth = fieldWidth;
		return this;
	}

	//flixel 5.9.0 didnt account for centered text so heres a band-aid fix for now, will make a pr later
	override function computeTextSize() {
		final finalTxtWidth = textWidth;
		final txtWidth = autoSize ? finalTxtWidth + padding * 2 : fieldWidth;
		final txtHeight = textHeight + padding * 2;
		
		frameWidth = (txtWidth == 0) ? 1 : txtWidth;
		frameHeight = (txtHeight == 0) ? 1 : txtHeight;
	}
}