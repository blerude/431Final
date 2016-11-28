//team Ben, Erika Devin, Alex
(
var height = 632;
var width = 632;
var initialSize = 20;
var placements = [22, 64, 106, 148, 190, 232, 274, 316, 358, 400, 442, 484, 526, 568, 610];
var harmony, melody, bass, percussion;
var x1 = placements.choose;
var x2 = placements.choose;
var x3 = placements.choose;
var x4 = placements.choose;
var y1 = placements.choose;
var y2 = placements.choose;
var y3 = placements.choose;
var y4 = placements.choose;
var c1 = Color.rand;
var c2 = Color.rand;
var c3 = Color.rand;
var c4 = Color.rand;

var drawCell = { | x, y, color, ind |
	var cell = (
		x: x,
		y: y,
		xSpd: 0,
		ySpd: 0,
		size: initialSize,
		color: Color.rand,
		points: 0,
		ate: List[]
	);
	Pen.color = color;
	Pen.fillRect(Rect(cell[\x] - cell[\size], cell[\y] - cell[\size], cell[\size] * 2, cell[\size] * 2));

	// Add tab to respective cells to indicate which track it represents (harmony, melody, etc.)
	Pen.strokeColor = Color.black;
	Pen.width = 3;
	case
	{ ind == 0 } { Pen.line((cell[\x] - cell[\size]) @ (cell[\y] - 10), (cell[\x] - 10) @ (cell[\y] -  cell[\size])); }
	{ ind == 1 } { Pen.line((cell[\x] + cell[\size]) @ (cell[\y] - 10), (cell[\x] + 10) @ (cell[\y] - cell[\size])); }
	{ ind == 2 } { Pen.line((cell[\x] + cell[\size]) @ (cell[\y] + 10), (cell[\x] + 10) @ (cell[\y] + cell[\size])); }
	{ ind == 3 } { Pen.line((cell[\x] - cell[\size]) @ (cell[\y] + 10), (cell[\x] - 10) @ (cell[\y] + cell[\size])); };
	Pen.perform([\stroke]);

	cell;
	};

// Create Grid
w = Window("Grid", Rect(
	(Window.screenBounds.width/2)-(width/2),
	(Window.screenBounds.height/2),
	width,
	height), false).front;

v = UserView(w, Rect(0, 0, width, height));
v.background = Color.grey;
v.animate = true;
v.frameRate = 60;

v.drawFunc = {

	// Do drawing
	Pen.use {
		var loc, track, currCell;

		// Draw the grid
		Pen.strokeColor = Color.black;
		Pen.width = 2;
		loc = 1;
		while( { loc < height }, {
			Pen.moveTo(0 @ loc);
			Pen.lineTo(width @ loc);
			loc = loc + 42;
			Pen.perform([\stroke]);
		});
		loc = 1;
		while( { loc < width }, {
			Pen.moveTo(loc @ 0);
			Pen.lineTo(loc @ height);
			loc = loc + 42;
			Pen.perform([\stroke]);
		});

		harmony = drawCell.value(x1, y1, c1, 0);
		melody = drawCell.value(x2, y2 ,c2, 1);
		bass = drawCell.value(x3, y3, c3, 2);
		percussion = drawCell.value(x4, y4, c4, 3);

		// Draw the Y insignia
		track = 0;
		while( { track < 4 }, {
			case
			{ track == 0 } { currCell = harmony }
			{ track == 1 } { currCell = melody }
			{ track == 2 } { currCell = bass }
			{ track == 3 } { currCell = percussion };

			Pen.strokeColor = Color.white;
			Pen.width = 4;
			Pen.moveTo(currCell[\x] @ currCell[\y] - 10);
			Pen.lineTo(currCell[\x] @ currCell[\y]);
			Pen.lineTo(currCell[\x] @ (currCell[\y] + 12));
			Pen.moveTo(currCell[\x] @ currCell[\y]);
			Pen.lineTo((currCell[\x] + 10) @ (currCell[\y] - 10));
			Pen.moveTo((currCell[\x] + 7) @ (currCell[\y] - 13));
			Pen.lineTo((currCell[\x] + 13) @ (currCell[\y] - 7));
			Pen.moveTo((currCell[\x] - 5) @ (currCell[\y] + 12));
			Pen.lineTo((currCell[\x] + 5) @ (currCell[\y] + 12));
			Pen.moveTo((currCell[\x] - 7) @ (currCell[\y] - 13));
			Pen.lineTo((currCell[\x] - 13) @ (currCell[\y] - 7));
			Pen.perform([\stroke]);

			track = track + 1;
		});
	};
};

)



(
// Create interactive console for users to select initial cell configurations
x = Window("Placement Selections", Rect(0, 0, 420, 320), false).front;

StaticText.new(x, Rect(120,0,180,30)).string_("Make Placement Selections");
StaticText.new(x, Rect(135,0,150,80)).string_("To select a starting cell, ");
StaticText.new(x, Rect(65,0,290,110)).string_("enter a within the 1-15 range into the text box");
StaticText.new(x, Rect(200,0,20,140)).string_("OR");
StaticText.new(x, Rect(35,0,350,170)).string_("select 'Randomize' to let the computer decide the value.");

h = StaticText.new(x, Rect(20,0,180,250));
h.string = "Harmony:";
TextField(x,Rect(100,110,50,30));
Button.new(x,Rect(160,110,90,30)).states_([["Randomize X"]]);
TextField(x,Rect(260,110,50,30));
Button.new(x,Rect(320,110,90,30)).states_([["Randomize Y"]]);

m = StaticText.new(x, Rect(20,0,180,350));
m.string = "Melody:";
TextField(x,Rect(100,160,50,30));
Button.new(x,Rect(160,160,90,30)).states_([["Randomize X"]]);
TextField(x,Rect(260,160,50,30));
Button.new(x,Rect(320,160,90,30)).states_([["Randomize Y"]]);

h = StaticText.new(x, Rect(20,0,180,450));
h.string = "Bass:";
TextField(x,Rect(100,210,50,30));
Button.new(x,Rect(160,210,90,30)).states_([["Randomize X"]]);
TextField(x,Rect(260,210,50,30));
Button.new(x,Rect(320,210,90,30)).states_([["Randomize Y"]]);

h = StaticText.new(x, Rect(20,0,180,550));
h.string = "Percussion:";
TextField(x,Rect(100,260,50,30));
Button.new(x,Rect(160,260,90,30)).states_([["Randomize X"]]);
TextField(x,Rect(260,260,50,30));
Button.new(x,Rect(320,260,90,30)).states_([["Randomize Y"]]);

)
