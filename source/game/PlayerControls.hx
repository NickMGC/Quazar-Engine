package game;

import game.PlayScene.self as game;

class PlayerControls {
	public static function init(playField:PlayField):Void {
		for (i => direction in Note.notes) {
			final note:StrumNote = playField.playerStrums.strums[i];

			final key:Array<Int> = Data.keyBinds['${direction}_note'];

			Key.onPress(key, onKeyPress.bind(note));
			Key.onRelease(key, onKeyRelease.bind(note));
		}
	}

	static function onKeyPress(note:StrumNote):Void {
		if (note?.animation.curAnim.name != 'confirm') {
			note.playAnim('press');
		} else {
			Splash.spawn(note);
		}
	}

	inline static function onKeyRelease(note:StrumNote):Void {
		note.playAnim('static');
	}
}