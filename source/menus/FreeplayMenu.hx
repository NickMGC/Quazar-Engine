package menus;

class FreeplayMenu extends Scene {
	override function create() {
		Key.onPress(Key.back, onBack);

		super.create();
	}

	inline function onBack() switchState(MainMenu.new);
}