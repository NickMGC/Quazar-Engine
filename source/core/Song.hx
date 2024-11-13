package core;

//temporary code, subject to change

typedef NoteData = Array<{time:Float, index:Int, ?length:Float, ?type:String}>;
typedef EventData = Array<{time:Float, data:Array<{name:String, values:Array<Dynamic>}>}>;

typedef Chart = {name:String, bpm:Float, speed:Float, player1:String, player2:String, player3:String, notes:NoteData, events:EventData}

@:publicFields class Song {
    var song:Chart;
}