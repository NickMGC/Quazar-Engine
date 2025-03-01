package core;

typedef NoteData = {
	time:Float,
	index:Int,
	?length:Float,
	?type:String
}

typedef EventData = {
	time:Float,
	data:Array<{name:String, values:Array<Dynamic>}>
}

typedef Chart = {
	song:String,
	bpm:Float,

	speed:Float,
	stage:String,
	characters:Array<String>,

	notes:Array<NoteData>,
	?events:Array<EventData>
}

typedef Event = {events:Array<EventData>}