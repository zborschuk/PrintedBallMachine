in = 25.4;

slop = .2;

//pegboard variables
peg_rad = 1/4*in/2;
peg_sep = 1*in;
peg_thick = 1/4*in;

wall=3;

//ball variables
ball_rad = 5/8*in/2;

//track_rad = ball_rad+1+.5;  //this is the minimum size, I think
track_rad = in/2-wall; //this makes the track an inch wide

//inlet variables
inlet_x = in;
inlet_y = in*2;
inlet_z = in*1;
INLET_HOLE = 1;
INLET_SLOT = 2;
INLET_NONE = 0;

//pin variables
pin_tolerance = .3;
pin_rad = 3;
pin_lt = .8;