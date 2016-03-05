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

//outlet variables

%pegboard();

//peg for printing
translate([0,peg_thick,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg();

//simple slope!
!rotate([-90,0,0])
mirror([1,0,0]) slope_module();
translate([in*5,0,-in*1]) 
slope_module();

//the size is the X and Y number of holes in the peg board.
//This is meant to be used as a visual reference when designing your module.
module pegboard(size = [8,5]){
    difference(){
        cube([size[0]*in, peg_thick, size[1]*in]);
        
        translate([-.5*in,0,-.5*in]) 
        for(i=[1:size[0]])
            for(j=[1:size[1]])
                translate([i*peg_sep, 0, j*peg_sep]) rotate([90,0,0]) cylinder(r=peg_rad, h=in, center=true);
    }
}

//A sample module which uses the inlet to roll balls down a chute.
module slope_module(size = [4, -.5]){
    difference(){
        union(){
            inlet(height=3);
            hanger(solid=1, hole=[1,4], drop = in/2);
            translate([in*7/8,0,in*2]) track(rise=(size[1]*1.2)*in, run=(size[0]*1.2)*in, solid=1, hanger=0);
            hanger(solid=1, hole=[5,3], drop = in/2);
        }
        //hole in the inlet
        translate([in*7/8,0,in*2]) track(rise=size[1], run=size[0], solid=-1, hanger=0, extra=in/2);
        
        hanger(solid=-1, hole=[1,4], drop = in/2);
        hanger(solid=-1, hole=[5,3], drop = in/2);

		  //make the end flat
        translate([50+(size[0]+1)*in-1,0,50]) cube([100,100,100], center=true);
    }
}

module inlet(height = 1){
    inset = inlet_x-ball_rad*2-wall*2;
    //slope = .25*in;
    
    %translate([in,-in/2,(height-.5)*in]) translate([0,0,0]) sphere(r=ball_rad);
    
    translate([0,-inlet_y,height*in-inlet_z])
    difference(){
        union() hull(){
            cube([inlet_x-inset,inlet_y,.1]);
            translate([0,0,inlet_z-.1-4.5]) rotate([0,-10,0]) cube([inlet_x,inlet_y,.1]);
            //%translate([0,0,inlet_z-.1]) cube([inlet_x,inlet_y,.1]);
        }
        
        //hollow center
        hull(){
            intersection(){
                //ball divot
                hull(){
                    translate([in,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    translate([-in,inlet_y-in/2,in/2+5]) translate([0,0,0]) sphere(r=ball_rad);
                }
                hull(){
                    translate([wall,wall,0]) cube([inlet_x-wall*2-inset,inlet_y-wall*2,.1]);
                    translate([wall,wall,inlet_z]) cube([inlet_x-wall*2,inlet_y-wall*2,.1]);
                }
                //translate([wall,wall,wall]) cube([inlet_x-wall*2-inset,inlet_y-wall*2,inlet_z]);
            }
            translate([wall,wall,wall*2.5]) cube([inlet_x-wall*2-inset,inlet_y-wall*2,.1]);
            translate([wall,wall,inlet_z]) cube([inlet_x-wall*2,inlet_y-wall*2,.1]);
        }
        
        //scalloped entry
        for(i=[0:in:inlet_y-1]){
            translate([-in/2,inlet_y-i,inlet_z-in/2]) track(rise=-1.5, run=10, solid=-1, track_rad=track_rad+.25);
            
        }
    }
}


*translate([peg_sep/2,peg_thick/2,peg_sep*1.5])
square_peg();

//debating remaking the peg square...
module square_peg(){
    peg_sq = (peg_rad*2)/sqrt(2);
    
    angle=15;
    
    union(){
        //through the pegboard
        translate([0,-peg_sq/2,0]) cube([peg_sq, peg_thick+peg_sq, peg_sq], center=true);
        //back curve
        intersection(){
            translate([0,peg_thick/2,peg_sq/2]) rotate([0,90,0]) rotate_extrude(angle=90, $fn=30){
                translate([peg_sq/2,0,0]) square([peg_sq, peg_sq], center=true);
            }
            translate([-peg_sq/2,peg_thick/2,peg_sq/2]) rotate([-90-angle,0,0]) cube([peg_sq, peg_thick, peg_sq]);
        }
        //back peg
        translate([-peg_sq/2,peg_thick/2,peg_sq/2]) rotate([-90-angle,0,0]) hull(){
            cube([peg_sq, .1, peg_sq]);
            #translate([0,-4,1]) cube([peg_sq, .1, peg_sq-2]);
        }
        //front curve
        intersection(){
            #translate([0,-peg_thick/2-peg_sq,peg_sq/2]) rotate([0,90,0]) rotate_extrude(angle=90, $fn=30){
                translate([peg_sq/2,0,0]) square([peg_sq, peg_sq], center=true);
            }
            #translate([-peg_sq/2,-peg_thick/2-peg_sq,peg_sq/2]) rotate([-90-angle,0,0]) cube([peg_sq, peg_thick, peg_sq]);
        }
    }
}

module peg(){
    $fn=16;
    
    peg_angle = 20;
    rear_inset = peg_rad*tan(peg_angle);
    front_inset = rear_inset+slop;
    
    cutoff=1;
    
    translate([peg_sep/2,0,peg_sep*1.5]) 
    difference(){
        union(){
          //upper peg
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([90,0,0]) cylinder(r1=peg_rad*3/4-slop/2, r2=peg_rad-slop, h=peg_thick+peg_rad-rear_inset);
				
			translate([0,-wall+.1,0]) rotate([90,0,0]) cylinder(r1=peg_rad, r2=peg_rad*3/4, h=wall+peg_rad-front_inset);

            //rear hook
            translate([0,peg_thick+peg_rad-rear_inset,0]) sphere(r=peg_rad*3/4-slop/2);
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([-peg_angle,0,0]) cylinder(r1=peg_rad*3/4-slop/2, r2=peg_rad*3/4-slop, h=peg_thick);
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([-peg_angle,0,0]) translate([0,0,peg_thick]) sphere(r=peg_rad*3/4-slop);
            
            //front hook
            translate([0,-wall*2-front_inset,0]) sphere(r=peg_rad*3/4);
            translate([0,-wall*2-front_inset,0]) rotate([peg_angle,0,0]) cylinder(r1=peg_rad*3/4, r2=peg_rad*3/4-slop, h=wall*2);
            translate([0,-wall*2-front_inset,0]) rotate([peg_angle,0,0]) translate([0,0,wall*2]) sphere(r=peg_rad*3/4-slop);
            
            
            //connect 'em
            hull(){
                rotate([90,0,0]) cylinder(r=peg_rad, h=wall);
                #translate([0,0,-peg_sep*1.5]) rotate([90,0,0]) cylinder(r=peg_rad, h=wall);
            }
            
            //lower peg
            translate([0,0,-peg_sep]) rotate([90,0,0]) translate([0,0,-peg_thick]) cylinder(r2=peg_rad, r1=peg_rad-slop, h=peg_thick+wall);
            translate([0,peg_thick,-peg_sep]) sphere(r=peg_rad-slop);
        }
        
        //cut off top and bottom for easier printing
        translate([50+peg_rad-cutoff,0,0]) cube([100,100,100], center=true);
        translate([-50-peg_rad+cutoff,0,0]) cube([100,100,100], center=true);
    }
}

module outlet(height = 2){
}

module hanger(solid=0, hole=[1,4], slot_size = 0, drop = in/2){
    offset = (track_rad+wall);
    
    translate([in*hole[0]-peg_sep/2, 0, in*(hole[1]-1)]) 
    if(solid >= 0) union(){
        //right (slot) side
        hull(){
            translate([-slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_rad+wall*2, h=wall);
            translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_rad+wall*2, h=wall);
                
            translate([0,0,peg_sep/2-drop])rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=peg_rad+wall, h=wall, $fn=8);
        }
    }
    
    translate([in*hole[0]-peg_sep/2, 0, in*(hole[1]-1)]) 
    if(solid <= 0) union(){
        for(i=[0:1]) hull(){
            translate([-slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.05]) cylinder(r1=peg_rad+slop, r2=peg_rad+wall, h=wall);
            translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.05]) cylinder(r1=peg_rad+slop, r2=peg_rad+wall, h=wall);
        }
    }
}

module track_hangers(length=30, angle=10, solid=0, slot_size = peg_sep/2){
    offset = (track_rad+wall);
    
    if(solid >= 0) union(){
        //left (hole) side
        translate([peg_sep/2,peg_sep/2,0]){
            hull(){
                translate([0,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_rad+wall*2, h=wall);
                translate([0,0,0]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=peg_rad+wall, h=wall, $fn=8);
            }
            
            //lower support
            rotate([0,angle,0]) translate([0,0,-offset+peg_rad+wall]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=(peg_rad+wall)/cos(180/8), h=peg_sep-wall, $fn=8);
        }
        
        //right (slot) side
        translate([peg_sep/2,-peg_sep/2,0]) rotate([0,angle,0]) translate([-peg_sep/2,+peg_sep/2,0]) translate([length-peg_sep/2,peg_sep/2,0]){
            rotate([0,-angle,0]) hull(){
                translate([-slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_rad+wall*2, h=wall);
                translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_rad+wall*2, h=wall);
                
                rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=peg_rad+wall, h=wall, $fn=8);
            }
            
            //lower support
            translate([0,0,-offset+peg_rad+wall]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=(peg_rad+wall)/cos(180/8), h=peg_sep-wall, $fn=8);
        }
    }
    
    if(solid <= 0){
        //left (peg) side
        for(i=[0,1]) translate([peg_sep/2,peg_sep/2,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.05]) cylinder(r1=peg_rad+slop, r2=peg_rad+wall, h=wall);
        
        //right (slot) side
		  translate([peg_sep/2,-peg_sep/2,0]) rotate([0,angle,0]) translate([-peg_sep/2,+peg_sep/2,0]) translate([length-peg_sep/2,peg_sep/2,0]){
            rotate([0,-angle,0]) for(i=[0:1]) hull(){
                translate([-slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.05]) cylinder(r1=peg_rad+slop, r2=peg_rad+wall, h=wall);
                translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.05]) cylinder(r1=peg_rad+slop, r2=peg_rad+wall, h=wall);
            }
		}
    }
}

//straight section of track.
//Length is in mm.
//Start is at 0 (move it where you want it) end is length units away horizontally, at the specified angle.
//rise and run are both inches - length and angle are calculated from them.
//solid = 1: draw the track
//solid = 0: draw both track and path
//solid = -1: draw the marble path - useful for making holes in things.
//
//start/end dictate the angle at the end of the track.  This is a 1" radius, period - defaults to 0, which is straight; angles over 90 or under -90 result in +/-90.
module track(rise=-in, run=in*5, hanger=1, solid=1, track_angle=120, start=0, end=90, extra = in){

	 angle = -atan(rise/run);

    ta = 360-track_angle;
    
    

    length = sqrt(rise*rise+run*run);
    
    translate([0,0,track_rad+wall])
    if(solid>=0){
        %translate([0,-peg_sep/2,0]) translate([0,0,ball_rad-track_rad]) sphere(r=ball_rad);
        translate([0,-peg_sep*.5,0]) difference(){
            union(){
                rotate([0,angle,0]) difference(){
                    %translate([length,0,0]) translate([0,0,ball_rad-track_rad]) sphere(r=ball_rad);
                    
                    rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=(track_rad+wall)/cos(180/8), h=length, $fn=8);
                    translate([-.5,0,0]) {
                        rotate([45,0,0]) cube([length+1, track_rad+wall*2, ball_rad+wall*2]);
                        for(i=[0,1]) mirror([0,i,0]) rotate([ta/2,0,0]) translate([0,0,-wall*2]) cube([length+1, track_rad+wall*2, track_rad+wall*2]);
                    }
                }
                if(hanger==1)
                    track_hangers(length=length, angle=angle, solid=1);
            }
        
            //ball path
            translate([-.5,0,0]) rotate([0,angle,0]) rotate([0,90,0]) cylinder(r=track_rad, h=length+2);
            
            if(hanger==1){
                track_hangers(length=length, angle=angle, solid=-1);
            }
        }
        
    }
    
	 //this is used to hollow out things that the track is supposed to connect to, and to make sure that the ball path is clear.
    if(solid<=0){
        translate([-.5,0,0]) translate([0,-peg_sep*.5,track_rad+wall]) rotate([0,angle,0]) rotate([0,90,0]) cylinder(r=track_rad, h=extra*2, center=true);
    }
}