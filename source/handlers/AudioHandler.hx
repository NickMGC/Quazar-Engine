package handlers;

@:publicFields class AudioHandler {
    /**
     * Plays a sound from an embedded sound. Tries to recycle a cached sound first.
     * @param embeddedSound  The embedded sound resource you want to play.
     * @param volume         How loud to play it (0 to 1).
     * @param looped         Whether to loop this sound.
     * @param group          The group to add this sound to.
     * @param autoDestroy    Whether to destroy this sound when it finishes playing. Leave this value set to "false" if you want to re-use this FlxSound instance.
     * @param onComplete     Called when the sound finished playing
     */
    inline static function playSound(path:String, volume:Float = 1., looped:Bool = false, ?group:Null<FlxSoundGroup>, ?autoDestroy:Bool = true, ?onComplete:Null<() -> Void>)
        return FlxG.sound.play(Path.sound(path), volume, looped, group, autoDestroy, onComplete);

    /**
     * Set up and play a looping background soundtrack.
     * @param embeddedMusic The sound file you want to loop in the background.
     * @param volume        How loud the sound should be, from 0 to 1.
     * @param looped        Whether to loop this music.
     * @param group         The group to add this sound to.
     */
    inline static function playMusic(path:String, volume:Float = 1., looped:Bool = true, ?group:Null<FlxSoundGroup>) {
        FlxG.sound.playMusic(Path.music(path), volume, looped, group);
        return FlxG.sound.music;
    }

    /** Call this function to stop this sound.*/
    inline static function stopMusic() {
        FlxG.sound.music.stop();
        return FlxG.sound.music;
    }

    /** Call this function to pause this sound.*/
    inline static function pauseMusic() {
        FlxG.sound.music.pause();
        return FlxG.sound.music;
    }

    /** Call this function to resume this sound.*/
    inline static function resumeMusic() {
        FlxG.sound.music.resume();
        return FlxG.sound.music;
    }

    /** Changes the volume by a certain amount, also activating the sound tray.*/
    inline static function changeVolume(volume:Float) return FlxG.sound.changeVolume(volume);

    /**
     * Call this function if you want this sound's volume to change based on distance from a particular FlxObject.
     * @param X             The X position of the sound.
     * @param Y             The Y position of the sound.
     * @param TargetObject  The object you want to track.
     * @param Radius        The maximum distance this sound can travel.
     * @param Pan           Whether panning should be used in addition to the volume changes.
     * @return              This FlxSound instance (nice for chaining stuff together, if you're into that).
     */
    inline static function proximity(X:Float, Y:Float, TargetObject:FlxObject, Radius:Float, Pan:Bool = true) {
        FlxG.sound.music.proximity(X, Y, TargetObject, Radius, Pan);
        return FlxG.sound.music;
    }

    /**
     * Creates a new FlxSound object.
     * @param embeddedSound  The embedded sound resource you want to play. To stream, use the optional URL parameter instead.
     * @param volume         How loud to play it (0 to 1).
     * @param group          The group to add this sound to.
     * @param autoDestroy    Whether to destroy this sound when it finishes playing. Leave this value set to "false" if you want to re-use this FlxSound instance.
     * @param autoPlay       Whether to play the sound.
     * @param url            Load a sound from an external web resource instead. Only used if EmbeddedSound = null.
     * @param onComplete     Called when the sound finished playing.
     * @param onLoad         Called when the sound finished loading. Called immediately for succesfully loaded embedded sounds.
     */
    inline static function loadSound(?path:String, volume:Float = 1., ?group:Null<FlxSoundGroup>, autoDestroy:Bool = false, autoPlay:Bool = false, ?url:Null<String>, ?onComplete:Null<() -> Void>, ?onLoad:Null<() -> Void>)
        FlxG.sound.load(Path.sound(path), volume, false, group, autoDestroy, autoPlay, url, onComplete, onLoad);

    /**
     * Creates a new FlxSound object.
     * @param embeddedSound  The embedded sound resource you want to play. To stream, use the optional URL parameter instead.
     * @param volume         How loud to play it (0 to 1).
     * @param group          The group to add this sound to.
     * @param autoDestroy    Whether to destroy this sound when it finishes playing. Leave this value set to "false" if you want to re-use this FlxSound instance.
     * @param autoPlay       Whether to play the sound.
     * @param url            Load a sound from an external web resource instead. Only used if EmbeddedSound = null.
     * @param onComplete     Called when the sound finished playing.
     * @param onLoad         Called when the sound finished loading. Called immediately for succesfully loaded embedded sounds.
     */
    inline static function loadMusic(?path:String, volume:Float = 1., ?group:Null<FlxSoundGroup>, autoDestroy:Bool = false, autoPlay:Bool = false, ?url:Null<String>, ?onComplete:Null<() -> Void>, ?onLoad:Null<() -> Void>)
        FlxG.sound.load(Path.music(path), volume, true, group, autoDestroy, autoPlay, url, onComplete, onLoad);

    /**
     * Helper function that tweens this sound's volume.
     * @param Duration The amount of time the fade-in operation should take.
     * @param From     The volume to tween from, 0 by default.
     * @param To       The volume to tween to, 1 by default.
     */
    inline static function fadeIn(Duration:Float = 1, From:Float = 0, To:Float = 1, ?onComplete:Null<FlxTween -> Void>) {
        FlxG.sound.music.fadeIn(Duration, From, To, onComplete);
        return FlxG.sound.music;
    }

    /**
     * Helper function that tweens this sound's volume.
     * @param Duration The amount of time the fade-in operation should take.
     * @param To       The volume to tween to, 0 by default.
     */
    inline static function fadeOut(Duration:Float = 1, To:Float = 1, ?onComplete:Null<FlxTween -> Void>) {
        FlxG.sound.music.fadeOut(Duration, To, onComplete);
        return FlxG.sound.music;
    }

    //TODO: make a Sound function for creating FlxSounds
}