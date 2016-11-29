//team Ben, Erika, Devin, Alex 11/28/16 :D
(
//GENERATING BASS
//Dev

//Synthdef:
SynthDef(\bass, { |freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(0, sig ! 2)
}).add;

/*Changing tempo of bass based on the bifurcations of the logistic map.
Speeds up every time the number of attracting points doubles

0-1: none
1-3: 1
3-3.44 (1 + sqrt(6)): 2
3.44-3.544: 4
3.544-3.596: 8
3.596-3.626: chaos
3.626-3.63: 6
3.63-3.633:12
3.633-3.738: chaos
3.738-3.741: 5
3.741-3.744:10
3.744-3.828: chaos
3.828-3.841: 3
3.841-3.848: 6
3.848-3.857: 12/devolve into chaos
3.857-4: chaos
*/



//GUI STUFF
var height = 632;
var width = 632;
var height = 380;
var width = 380;
var initialSize = 20;
var placements = [22, 64, 106, 148, 190, 232, 274, 316, 358];
var harmony, melody, bass, percussion;
var x1 = placements[~hxval - 1];
var x2 = placements[~mxval - 1];
var x3 = placements[~bxval - 1];
var x4 = placements[~pxval - 1];
var y1 = placements[~hyval - 1];
var y2 = placements[~myval - 1];
var y3 = placements[~byval - 1];
var y4 = placements[~pyval - 1];
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
			Pen.moveTo((currCell[\x] - 9) @ (currCell[\y] - 13));
			Pen.lineTo((currCell[\x] - 1) @ currCell[\y]);
			Pen.lineTo((currCell[\x] - 1) @ (currCell[\y] + 12));
			Pen.perform([\stroke]);

			Pen.width = 2;
			Pen.moveTo(currCell[\x] @ currCell[\y]);
			Pen.lineTo((currCell[\x] + 9) @ (currCell[\y] - 13));
			Pen.moveTo((currCell[\x] - 6) @ (currCell[\y] + 12));
			Pen.lineTo((currCell[\x] + 4) @ (currCell[\y] + 12));
			Pen.moveTo((currCell[\x] + 3) @ (currCell[\y] - 13));
			Pen.lineTo((currCell[\x] + 13) @ (currCell[\y] - 13));
			Pen.moveTo((currCell[\x] - 3) @ (currCell[\y] - 13));
			Pen.lineTo((currCell[\x] - 13) @ (currCell[\y] - 13));
			Pen.perform([\stroke]);

			track = track + 1;
		});
	};
};

)



(
// Create interactive console for users to select initial cell configurations
x = Window.new("Placement Selections", Rect(0, 0, 420, 370), false).front;

StaticText.new(x, Rect(85,0,250,30)).string_("MAKE CELL PLACEMENT SELECTIONS");
StaticText.new(x, Rect(135,0,150,80)).string_("To select a starting cell,");
StaticText.new(x, Rect(40,0,340,110)).string_("enter a number within the 1-9 range into the text box.");
StaticText.new(x, Rect(135,0,150,140)).string_("If the input is not valid,");
StaticText.new(x, Rect(90,0,240,170)).string_("one will be randomly selected for you.");
StaticText.new(x, Rect(80,0,260,210)).string_("NOTE: Coordinate pairs must be distinct!");

StaticText.new(x, Rect(20,0,180,270)).string_("Harmony:");
StaticText.new(x, Rect(110,0,50,270)).string_("X Value:");
~hx = TextField(x,Rect(170,120,50,30));
StaticText.new(x, Rect(250,0,50,270)).string_("Y Value:");
~hy = TextField(x,Rect(310,120,50,30));

StaticText.new(x, Rect(20,0,180,370)).string_("Melody:");
StaticText.new(x, Rect(110,0,50,370)).string_("X Value:");
~mx = TextField(x,Rect(170,170,50,30));
StaticText.new(x, Rect(250,0,50,370)).string_("Y Value:");
~my = TextField(x,Rect(310,170,50,30));

StaticText.new(x, Rect(20,0,180,470)).string_("Bass:");
StaticText.new(x, Rect(110,0,50,470)).string_("X Value:");
~bx = TextField(x,Rect(170,220,50,30));
StaticText.new(x, Rect(250,0,50,470)).string_("Y Value:");
~by = TextField(x,Rect(310,220,50,30));

StaticText.new(x, Rect(20,0,180,570)).string_("Percussion:");
StaticText.new(x, Rect(110,0,50,570)).string_("X Value:");
~px = TextField(x,Rect(170,270,50,30));
StaticText.new(x, Rect(250,0,50,570)).string_("Y Value:");
~py = TextField(x,Rect(310,270,50,30));

b = Button.new(x,Rect(155,320,90,30))
.states_([["DONE"]])
.action_(  {
	if ((~hx.value.asInteger > 0) && (~hx.value.asInteger < 16), { ~hxval = ~hx.value.asInteger }, { ~hxval = rrand(1, 9) } );
	if ((~hy.value.asInteger > 0) && (~hy.value.asInteger < 16), { ~hyval = ~hy.value.asInteger }, { ~hyval = rrand(1, 9) } );
	if ((~mx.value.asInteger > 0) && (~mx.value.asInteger < 16), { ~mxval = ~mx.value.asInteger }, { ~mxval = rrand(1, 9) } );
	if ((~my.value.asInteger > 0) && (~my.value.asInteger < 16), { ~myval = ~my.value.asInteger }, { ~myval = rrand(1, 9) } );
	if ((~bx.value.asInteger > 0) && (~bx.value.asInteger < 16), { ~bxval = ~bx.value.asInteger }, { ~bxval = rrand(1, 9) } );
	if ((~by.value.asInteger > 0) && (~by.value.asInteger < 16), { ~byval = ~by.value.asInteger }, { ~byval = rrand(1, 9) } );
	if ((~px.value.asInteger > 0) && (~px.value.asInteger < 16), { ~pxval = ~px.value.asInteger }, { ~pxval = rrand(1, 9) } );
	if ((~py.value.asInteger > 0) && (~py.value.asInteger < 16), { ~pyval = ~py.value.asInteger }, { ~pyval = rrand(1, 9) } );

	while ({ (~mxval == ~hxval) && (~myval == ~hyval) }, { ~mxval = rrand(1, 9); ~myval = rrand(1, 9) });
	while ({ ((~bxval == ~hxval) && (~byval == ~hyval)) || ((~bxval == ~mxval) && (~byval == ~myval)) },
		{ ~bxval = rrand(1, 9); ~byval = rrand(1, 9) });
	while ({ ((~pxval == ~hxval) && (~pyval == ~hyval))  || ((~pxval == ~mxval) && (~pyval == ~myval)) ||
		((~pxval == ~bxval) && (~pyval == ~byval)) }, { ~pxval = rrand(1, 9); ~pyval = rrand(1, 9) });

	Window.closeAll;
});
)

/*StaticText.new(x, Rect(120,0,180,30)).string_("Make Placement Selections");
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
Button.new(x,Rect(320,260,90,30)).states_([["Randomize Y"]]);*/

