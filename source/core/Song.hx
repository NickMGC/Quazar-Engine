package core;

//temporary code, subject to change

@:structInit @:publicFields class SongInfo {
    var name = '';

    var bpm = 100.;
    var speed = 1.;

    var player1 = 'bf';
    var player2 = 'dad';
    var player3 = 'gf';

    var notes:Array<{time:Float, index:Int, ?length:Float, ?type:String}> = [];
    var events:Array<{time:Float, data:Array<{name:String, values:Array<Dynamic>}>}> = [];

    inline function new() {}
}

@:publicFields class Song {
    var song:SongInfo = new SongInfo();
}