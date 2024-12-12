package core;

typedef NoteData = {time:Float, index:Int, ?length:Float, ?type:String};
typedef EventData = {time:Float, data:Array<{name:String, values:Array<Dynamic>}>};

typedef ChartData = {song:String, bpm:Float, speed:Float, stage:String, characters:Array<String>, notes:Array<NoteData>, ?events:Array<EventData>}