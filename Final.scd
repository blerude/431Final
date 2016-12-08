//team Ben, Erika, Devin, Alex 11/28/16 :D

// *****Alright, some comments to hopefully clarify what's going on:


// This block of code creates the console for selecting the 4 track's cells' initial coordinates on the grid
// It should be executed first in order to get those locations, before the later actual interface code block
//   is run. Users can input the row and column of each cell by entering a number between 1 and 9. If they
//   enter anything other than that (numbers outside the range, non-numeric characters, or leave it blank),
//   a random number will be chosen for them. Once they press the 'DONE' button, the console closes and
//   the responses are assigned to variables.
(
// Create interactive console for users to select initial cell configurations
x = Window.new("Placement Selections", Rect(0, 0, 420, 370), false).front;

// These commands create the text blocks on the console that instruct users.
StaticText.new(x, Rect(85,0,250,30)).string_("MAKE CELL PLACEMENT SELECTIONS");
StaticText.new(x, Rect(135,0,150,80)).string_("To select a starting cell,");
StaticText.new(x, Rect(40,0,340,110)).string_("enter a number within the 1-9 range into the text box.");
StaticText.new(x, Rect(135,0,150,140)).string_("If the input is not valid,");
StaticText.new(x, Rect(90,0,240,170)).string_("one will be randomly selected for you.");
StaticText.new(x, Rect(80,0,260,210)).string_("NOTE: Coordinate pairs must be distinct!");

// Harmony, melody, bass, and percussion fields are below. The text fields are global variables so that the
//   values entered inside can be accessed from the interface code block below.
StaticText.new(x, Rect(20,0,180,270)).string_("Melody:");
StaticText.new(x, Rect(110,0,50,270)).string_("X Value:");
~mx = TextField(x,Rect(170,120,50,30));
StaticText.new(x, Rect(250,0,50,270)).string_("Y Value:");
~my = TextField(x,Rect(310,120,50,30));

StaticText.new(x, Rect(20,0,180,370)).string_("Harmony:");
StaticText.new(x, Rect(110,0,50,370)).string_("X Value:");
~hx = TextField(x,Rect(170,170,50,30));
StaticText.new(x, Rect(250,0,50,370)).string_("Y Value:");
~hy = TextField(x,Rect(310,170,50,30));

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

// This button locks the responses in by saving the entered text from each box to global variables
b = Button.new(x,Rect(155,320,90,30))
.states_([["DONE"]])
.action_(  {
	// Save responses to x and y variables for each track; if response is invalid, choose random entry
	if ((~mx.value.asInteger > 0) && (~mx.value.asInteger < 16),
		{ ~mxval = ~mx.value.asInteger }, { ~mxval = rrand(1, 9) } );
	if ((~my.value.asInteger > 0) && (~my.value.asInteger < 16),
		{ ~myval = ~my.value.asInteger }, { ~myval = rrand(1, 9) } );
	if ((~hx.value.asInteger > 0) && (~hx.value.asInteger < 16),
		{ ~hxval = ~hx.value.asInteger }, { ~hxval = rrand(1, 9) } );
	if ((~hy.value.asInteger > 0) && (~hy.value.asInteger < 16),
		{ ~hyval = ~hy.value.asInteger }, { ~hyval = rrand(1, 9) } );
	if ((~bx.value.asInteger > 0) && (~bx.value.asInteger < 16),
		{ ~bxval = ~bx.value.asInteger }, { ~bxval = rrand(1, 9) } );
	if ((~by.value.asInteger > 0) && (~by.value.asInteger < 16),
		{ ~byval = ~by.value.asInteger }, { ~byval = rrand(1, 9) } );
	if ((~px.value.asInteger > 0) && (~px.value.asInteger < 16),
		{ ~pxval = ~px.value.asInteger }, { ~pxval = rrand(1, 9) } );
	if ((~py.value.asInteger > 0) && (~py.value.asInteger < 16),
		{ ~pyval = ~py.value.asInteger }, { ~pyval = rrand(1, 9) } );

	// This protects against the possibility that cells are assigned the same coordinates
	while ({ (~mxval == ~hxval) && (~myval == ~hyval) }, { ~mxval = rrand(1, 9); ~myval = rrand(1, 9) });
	while ({ ((~bxval == ~hxval) && (~byval == ~hyval)) || ((~bxval == ~mxval) && (~byval == ~myval)) },
		{ ~bxval = rrand(1, 9); ~byval = rrand(1, 9) });
	while ({ ((~pxval == ~hxval) && (~pyval == ~hyval))  || ((~pxval == ~mxval) && (~pyval == ~myval)) ||
		((~pxval == ~bxval) && (~pyval == ~byval)) }, { ~pxval = rrand(1, 9); ~pyval = rrand(1, 9) });

	Window.closeAll; // Close window upon exit!
});
)

(
//GUI STUFF
var hPitch = [ 0, 3, 6, 8, 12, 15 ]; // placeholder pitch array for the harmony line
var hCount = 0; // placeholder count variable for testing
var bPitch = [ 1, 4, 1, 5, 4, 5, 1 ];
var bCount = 0;
var pPitch = [ 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0 ];
var pCount = 0;
var mPitch = [ ];
var mCount = 0;

var height = 380; // height of the grid
var width = 380; // width of the gird
var initialSize = 20; // size of each cell (they're actually 40 across, so this is actually the radius not the diamer

var melody, harmony, bass, percussion; // tracks!

var coords = [22, 64, 106, 148, 190, 232, 274, 316, 358]; // grid points at the center of each cell

// These variables take the global variables from the user selection console as the indexes of the coords array
//    and identify the points that the cells should be placed at
var x1 = coords[~hxval - 1];
var x2 = coords[~bxval - 1];
var x3 = coords[~pxval - 1];
var x4 = coords[~mxval - 1];
var y1 = coords[~hyval - 1];
var y2 = coords[~byval - 1];
var y3 = coords[~pyval - 1];
var y4 = coords[~myval - 1];

var hx = x1;
var hy = y1;
var hxArray = [ ];
var hyArray = [ ];

var bx = x2;
var by = y2;
var bxArray = [ ];
var byArray = [ ];

var px = x3;
var py = y3;
var pxArray = [ ];
var pyArray = [ ];

var mx = x4;
var my = y4;
var mxArray = [ ];
var myArray = [ ];

var c1 = Color.rand; // each box is given a random color
var c2 = Color.rand;
var c3 = Color.rand;
var c4 = Color.blue;
var boxX = [ 4, 6, 6, 8, 4, 2, 3, 2 ]; // Barrier cell x indices
var boxY = [ 2, 5, 6, 3, 8, 5, 4, 3 ]; // Barrier cell y indices

// This function creates the cells using the coordinates and color assigned
var drawCell = { | x, y, color, ind |
	var cell = (
		x: x,
		y: y,
		size: initialSize,
		color: color
	);
	Pen.color = color;
	Pen.fillRect(Rect(cell[\x] - cell[\size], cell[\y] - cell[\size], cell[\size] * 2, cell[\size] * 2));

	// Add tab to respective cells to indicate which track it represents (harmony, melody, etc.)
	Pen.strokeColor = Color.black;
	Pen.width = 3;
	case
	{ ind == 0 } { Pen.line((cell[\x] - cell[\size]) @ (cell[\y] - 10), (cell[\x] - 10) @ (cell[\y] -  cell[\size])); } // Harmony
	{ ind == 1 } { Pen.line((cell[\x] + cell[\size]) @ (cell[\y] - 10), (cell[\x] + 10) @ (cell[\y] - cell[\size])); } // Bass
	{ ind == 2 } { Pen.line((cell[\x] + cell[\size]) @ (cell[\y] + 10), (cell[\x] + 10) @ (cell[\y] + cell[\size])); }; // Percussion
	Pen.perform([\stroke]);

	cell; // return the newly generated cell
};

// This function takes an array of x coordinates and an array of corresponding y coordinates in order to
//    trace the pathways of the given track
var tracePath = { | xArray, yArray, width, height |
	z = 1;
	while ( { z < xArray.size }, {
		case
		//x jump small to big
		{ (abs(xArray[z - 1] - xArray[z]) > 42) && (xArray[z] > xArray[z - 1]) }
		{ Pen.lineTo(2 @ yArray[z]); Pen.moveTo((width - 2) @ yArray[z]); Pen.lineTo(xArray[z] @ yArray[z]) }
		//x jump big to small
		{ (abs(xArray[z - 1] - xArray[z]) > 42) && (xArray[z] < xArray[z - 1]) }
		{ Pen.lineTo((width - 2) @ yArray[z]); Pen.moveTo(2 @ yArray[z]); Pen.lineTo(xArray[z] @ yArray[z]) }
		//y jump small to big
		{ (abs(yArray[z - 1] - yArray[z]) > 42) && (yArray[z] > yArray[z - 1]) }
		{ Pen.lineTo(xArray[z] @ 2); Pen.moveTo(xArray[z] @ (height - 2)); Pen.lineTo(xArray[z] @ yArray[z]) }
		//y jump big to small
		{ (abs(yArray[z - 1] - yArray[z]) > 42) && (yArray[z] < yArray[z - 1]) }
		{ Pen.lineTo(xArray[z] @ (height - 2)); Pen.moveTo(xArray[z] @ 2); Pen.lineTo(xArray[z] @ yArray[z]) }
		//should print
		{ (abs(xArray[z - 1] - xArray[z]) == 0) || (abs(yArray[z - 1] - yArray[z]) == 0) } { Pen.lineTo(xArray[z] @ yArray[z]) };

		z = z + 1;
	} );
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
v.frameRate = 5; // determines how many times a second the grid is rewritten; affects cell movements

v.keyDownAction = { |view, char, mod, uni, key|
	case
	{ key == 123 } { x4 = coords[ (coords.indexOf(x4) - 1) % 9 ] }
	{ key == 124 } { x4 = coords[ (coords.indexOf(x4) + 1) % 9 ] }
	{ key == 125 } { y4 = coords[ (coords.indexOf(y4) + 1) % 9 ] }
	{ key == 126 } { y4 = coords[ (coords.indexOf(y4) - 1) % 9 ] };
};


// This function is called frameRate times per second
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

		boxX.size.do( { |i| if( (mCount == 0 && coords[boxX[i]] == x4 && coords[boxY[i]] == y4),
			{ boxX.removeAt(i); boxY.removeAt(i); boxX.postln; boxY.postln } ) });

		// Creates a series of black cells to increase grid occupancy and the likelihood for collisions
		boxX.size.do( { |i| drawCell.value(coords[boxX[i]], coords[boxY[i]], Color.black, 5) }) ;


		// Add new coordinate values to arrays that track the paths of each track's cell
		hxArray = hxArray.add(x1);
		hyArray = hyArray.add(y1);
		bxArray = bxArray.add(x2);
		byArray = byArray.add(y2);
		pxArray = pxArray.add(x3);
		pyArray = pyArray.add(y3);
		mxArray = mxArray.add(x4);
		myArray = myArray.add(y4);

		// Create the pathways that show the progression of the cells
		Pen.width = 3;

		// Harmony pathway
		Pen.strokeColor = c1;
		Pen.moveTo(hx @ hy);
		tracePath.value(hxArray, hyArray, width, height);
		Pen.perform([\stroke]);

		// Bass pathway
		Pen.strokeColor = c2;
		Pen.moveTo(bx @ by);
		tracePath.value(bxArray, byArray, width, height);
		Pen.perform([\stroke]);

		// Percussion pathway
		Pen.strokeColor = c3;
		Pen.moveTo(px @ py);
		tracePath.value(pxArray, pyArray, width, height);
		Pen.perform([\stroke]);

		// Melody pathway
		Pen.strokeColor = c4;
		Pen.moveTo(mx @ my);
		// mxArray.size.do( { |i| Pen.lineTo(mxArray[i] @ myArray[i]) } );
		tracePath.value(mxArray, myArray, width, height);
		Pen.perform([\stroke]);


		// Generate the cells for each track!
		harmony = drawCell.value(x1, y1, c1, 0);
		bass = drawCell.value(x2, y2, c2, 1);
		percussion = drawCell.value(x3, y3, c3, 2);
		melody = drawCell.value(x4, y4, c4, 3);


		// Draw the Y insignia on each track's cell, for fun      -\_( '-' )_/-
		track = 0;
		while( { track < 4 }, {
			case
			{ track == 0 } { currCell = harmony }
			{ track == 1 } { currCell = bass }
			{ track == 2 } { currCell = percussion }
			{ track == 3 } { currCell = melody };

			if (track == 3, { Pen.strokeColor = Color.white }, { Pen.strokeColor = Color.black });

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


		// THESE SHOULD BE CALLED ONLY WHEN DURATION CHANGES:

		// Determine the new coordinate for the harmony cell based on pitch relationships
		case
		{ hCount == 0 }  { }
		{ (hPitch[hCount - 1] < hPitch[hCount]) && ((hPitch[hCount] - hPitch[hCount - 1]) < 3) }
			{ x1 = coords[ (coords.indexOf(x1) + 1) % 9 ] }
		{ hPitch[hCount - 1] < hPitch[hCount] }
		    { y1 = coords[ (coords.indexOf(y1) + 1) % 9 ] }
		{ hPitch[hCount - 1] > hPitch[hCount] && ((hPitch[hCount - 1] - hPitch[hCount]) < 3) }
		    { x1 = coords[ (coords.indexOf(x1) - 1) % 9 ] }
		{ hPitch[hCount - 1] > hPitch[hCount] }
		    { y1 = coords[ (coords.indexOf(y1) - 1) % 9 ] };

		hCount = (hCount + 1) % hPitch.size;


		// Determine the new coordinate for the bass cell based on pitch relationships
		case
		{ bCount == 0 }  { }
		{ (bPitch[bCount - 1] < bPitch[bCount]) && ((bPitch[bCount] - bPitch[bCount - 1]) < 3) }
			{ x2 = coords[ (coords.indexOf(x2) + 1) % 9 ] }
		{ bPitch[bCount - 1] < bPitch[bCount] }
		    { y2 = coords[ (coords.indexOf(y2) + 1) % 9 ] }
		{ bPitch[bCount - 1] > bPitch[hCount] && ((bPitch[bCount - 1] - bPitch[bCount]) < 3) }
		    { x2 = coords[ (coords.indexOf(x2) - 1) % 9 ] }
		{ bPitch[bCount - 1] > bPitch[hCount] }
		    { y2 = coords[ (coords.indexOf(y2) - 1) % 9 ] };

		bCount = (bCount + 1) % bPitch.size;


		// Determine the new coordinate for the percussion cell based on rest vs. beat
		case
		{ pCount == 0 }  { }
		{ pPitch[pCount] == 0 && pPitch[pCount - 1] == 1 }  { x3 = coords[ (coords.indexOf(x3) + 1) % 9 ] }
		{ pPitch[pCount] == 1 && pPitch[pCount - 1] == 0 }  { x3 = coords[ (coords.indexOf(x3) - 1) % 9 ] };

		pCount = (pCount + 1) % bPitch.size;


		// TODO:
		// 1. deal with frame= rate so it changes every time the note changes-  (ben)
		// 2. apply to bass, just like melody - (erika)
		// 3. percussion (just moving back and forth [0,1]), melody - (erika)
		// 3. incorporate joystick (erika) erika i have ideas for this!!!
		// 4. sustain the note
		// 5. collisions! (talk about this)
	};
};

)


(
/****************************************************** MELODY ************************************************************/
/*
L-System to determine note played when joy stick is moved one of four directions
U, D, L R : Up, down, left, right commands inputted from HID
A, B, C, D : set of L-System rules for each direction
*/

//example test input
var input = "D";

var l_sys_rule = [];
var note=[];

//rules for L-System for each direction
var nextA = { arg last_note;
	var probabilities = Dictionary.newFrom([
		60, [62],
		62, [60],
		64, [65],
		65, [67],
		67, [69],
		69, [71],
		71, [72],
		72, [72]
	]);
	probabilities.at(last_note).choose;
};

var nextB = { arg last_note;
	var probabilities = Dictionary.newFrom([
		60, [60],
		62, [60],
		64, [62],
		65, [64],
		67, [65],
		69, [67],
		71, [69],
		72, [71]
	]);
	probabilities.at(last_note).choose;
};

var nextC = { arg last_note;
	var probabilities = Dictionary.newFrom([
		60, [64, 67],
		62, [64, 60],
		64, [60, 67],
		65, [67, 64],
		67, [60, 64, 72],
		69, [71, 67],
		71, [72],
		72, [72, 60, 67]
	]);
	probabilities.at(last_note).choose;
};

var nextD = { arg last_note;
	var probabilities = Dictionary.newFrom([
		60, [62, 72],
		62, [64],
		64, [60, 65],
		65, [67, 60],
		67, [60, 64, 72],
		69, [67],
		71, [72, 60],
		72, [72, 60, 67]
	]);
	probabilities.at(last_note).choose;
};

l_sys_rule = l_sys_rule ++ input;

~lastplayed = 60;

if(l_sys_rule[0].asSymbol == 'U', {
	note = note ++ nextA.(~lastplayed);
	~lastplayed = note[0];
});

if(l_sys_rule[0].asSymbol == 'D', {
	note = note ++ nextB.(~lastplayed);
	~lastplayed = note[0];
});

if(l_sys_rule[0].asSymbol == 'L', {
	note = note ++ nextC.(~lastplayed);
	~lastplayed = note[0];
});

if(l_sys_rule[0].asSymbol == 'R', {
	note = note ++ nextD.(~lastplayed);
	~lastplayed = note[0];
});

note.postln;
)




(
//GENERATING BASS
//Dev

//variables
var durations = [0, 1, 0.5, 0.25, 0.125, 0.0625,
	0.1667, 0.08333, 0.0625,
	0.2, 0.1, 0.0625,
	0.333, 0.1667, 0.08333, 0.0625];

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

~playBass = {
	Pbind(
		\instrument, \bass,
		\dur, Pseq(durations, 2),
		\amp, 0.25).play;
};

~playBass.value;
)





Pbind( // Bass
	\instrument, \bass,
	\dur, Pseq(~bassDur,1),
	\sustain, Pseq(~bassDur,1),
	\octave, 4,
	\ctranspose,5,
	\scale, [0,2,4,5,7,9,11],
	\degree, Pseq(~bassLine,1),
	\amp, 0.1
).play;



(
//Generating Percussion Using Cellular Automata
var iterateRuleArray = 0;
var iterateRule;
var currRule = [];
var iterateDrumNotes = 0;
var generations = rrand(1, 10);
var currGen = 0;
var index = 0;
var currRule;

~drumNotes = [];
~rules = [];

//generate rules
while ({iterateRuleArray < 4}, //one rule for each of 00, 01, 10, and 11
	{iterateRule = 0;
		while ({iterateRule < 2},
			{currRule = currRule.add(rrand(0, 1));
				iterateRule = iterateRule + 1;
		});
		~rules = ~rules.add(currRule);
		iterateRuleArray = iterateRuleArray + 1;
	}
);

//generate initial state for drumNotes array

while ({iterateDrumNotes < 240}, //4 minutes of music
	{~drumNotes = ~drumNotes.add(rrand(0, 1));
		iterateDrumNotes = iterateDrumNotes + 1;
});

//do rules for random number of generations

while ({currGen < generations},
	{while ({index < 239}, //don't do it for the last one because no pair
			{if (~drumNotes[index] == 0,
				{
					//00
					if (~drumNotes[index + 1] == 0,
						{currRule = ~rules[0];});
					//01
					if (~drumNotes[index + 1] == 1,
						{currRule = ~rules[1];});
			});
			if (~drumNotes[index] == 1,
				{
					//10
					if (~drumNotes[index + 1] == 0,
						{currRule = ~rules[2];});
					//11
					if (~drumNotes[index + 1] == 1,
						{currRule = ~rules[3];});
			});
			~drumNotes.put(index, currRule[0]);
			~drumNotes.put(index + 1, currRule[1]);
			index = index + 1;
		});
		currGen = currGen + 1;
});
)

(//Drum Synthdef
SynthDef(\drums, {|out = 0, bassLevel = 0 , snareLevel = 0, hatLevel = 0, tomLevel = 0, pan1 = 0, pan2 = 0, pan3 = 0, pan4 = 0|

 var env1, env2, env3, env4, bass, snare, hat, tom, bassOut, snareOut, hatOut, tomOut, mixer;
 env1 = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);
 env2 = EnvGen.kr(Env.perc(0.001, 0.5, 1, -1), 1, doneAction:2);
 env3 = EnvGen.kr(Env.perc(0.002, 0.3, 1, -2), 1, doneAction:2);
 env4 = EnvGen.kr(Env.perc(0.001, 0.1, 1, -5), 1, doneAction:2);


bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);
bassOut = Pan2.ar(bass*env1, pan1, bassLevel);

 snare = SinOsc.ar(120) - WhiteNoise.ar(0.5, 0.5);
 snareOut = Pan2.ar(snare*env4, pan2, snareLevel);

 hat = Klank.ar(`[ [ 6563, 9875 ],
  [ 0.6, 0.5 ],
  [ 0.002, 0.003] ], PinkNoise.ar(1));
 hatOut = Pan2.ar(hat*env3, pan2, hatLevel);

 tom = SinOsc.ar(440);
 tomOut = Pan2.ar(tom*env4, pan4, tomLevel);

 mixer = Mix.new([bassOut, snareOut, hatOut, tomOut]);


 Out.ar(out, mixer);

 }).store;
)
