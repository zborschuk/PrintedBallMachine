include<configuration.scad>
include<pins.scad>

%translate([0,0,-in*4]) pegboard([12,12]);

//peg for printing
translate([0,peg_thick,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg(pin=true);

//simple slope!
//rotate([-90,0,0])
translate([in*10,0,-in*4]) 
mirror([1,0,0])
slope_module();
translate([in*5,0,-in*1]) 
slope_module();

translate([in*5,0,-in*5]) 
mirror([1,0,0])
slope_module();

//this module angles to the other side, acts as a brake to slow down long runs.
//rotate([-90,0,0])
offset_slope_module();

translate([in*10,0,-in*2]) 
rotate([-90,0,0])
reverse_module();

!intersection(){
    rotate([-90,0,0]) inlet(length=4, outlet=NONE);
    rotate([-90,0,0]) translate([in*4,0,0]) mirror([i,0,0]) inlet(length=4, outlet=NONE);
}


//the size is the X and Y number of holes in the peg board.
//This is meant to be used as a visual reference when designing your module.
module pegboard(size = [12,6]){
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
            
            translate([in,0,in*2]) track(rise=(size[1]*1.1)*in, run=(size[0]*1.1)*in, solid=1, end_angle=0);
            hanger(solid=1, hole=[5,3], drop = in/2);
        }
        //hole in the inlet
        *translate([in,0,in*2]) track(rise=size[1], run=size[0], solid=-1, hanger=0, extra_len=in-wall*1.5);

		  //cut the end flat
		  translate([50+in*size[0]+in-1,0,in*2]) cube([100,100,100], center=true);
        
         hanger(solid=-1, hole=[5,3], drop = in/2);
    }
}

//A sample module which uses the inlet to roll balls down a chute.
module offset_slope_module(size = [4, -.5]){
    inset = wall;
    difference(){
        union(){
            inlet(height=3);
            
            translate([in-inset,0,in*2])  difference(){
                track(rise=(size[1]*1.1)*in, run=(size[0]*1.1)*in, z_out=track_rad*2+wall*3, solid=1, end_angle=0);
                //flatten the front
                translate([-25+inset,-25,0]) cube([50,50,50], center=true);
            }
            hanger(solid=1, hole=[5,3], drop = in*.75);
            
            //lower end support
            hull(){
                translate([in*4.5,0,in*2.5-in*.75]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=wall*2, h=in*1.5, $fn=8);
                translate([in*4.5,0,in*2.5-in*.55]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=wall*2, h=in*1.5, $fn=8);
            }
            
        }
        
        translate([in-inset,0,in*2]) difference(){
            track(rise=(size[1]*1.1)*in, run=(size[0]*1.1)*in, z_out=track_rad*2+wall*3, solid=-1, end_angle=0);
            //flatten the front
            translate([0,-25,track_rad+wall]) cube([50,50,50], center=true);
        }

		 //cut the end flat
		 translate([50+in*size[0]+in-1,0,in*2]) cube([100,200,200], center=true);
        
         hanger(solid=-1, hole=[5,3], drop = in*.75);
    }
}

//a module to turn the marbles around.
module reverse_module(size = [4, -.5]){
    difference(){
        union(){
            inlet(height=3, hanger_height=1);
            
            translate([in,0,in*2]) track(rise=(size[1]*1)*in, run=(size[0]*1)*in, solid=1, end_angle=90);
            difference(){
                translate([-.25*in,-in*2,in*.5]) mirror([0,1,0]) track(rise=(size[1]*-1+.5)*in, run=(size[0]+1.25)*in, solid=1, end_angle=90);
                //gotta cut the end flat
                translate([-49,0,in*2]) cube([100,200,100], center=true);
            }
            
            //support
            translate([peg_sep/2,-peg_sep,peg_sep*1.5]) cube([peg_sep-2,wall/2,peg_sep], center=true);
            
            hanger(solid=1, hole=[4,4], drop = in*1.33);
        }
        //hole in the inlet
        //translate([in,0,in*2]) track(rise=size[1], run=size[0], solid=-1, hanger=0, extra_len=in-wall*1.5);

		  //cut the end flat
		  translate([50+in*size[0]+in,0,in*2]) cube([100,100,100], center=true);
        
        hanger(solid=-1, hole=[4,4], drop = in*1.33);
    }
}

/* The inlet module.
 * ABSOLUTELY REQUIRED: two (2) scalloped entryu points, 1" and 1" from the hook.  The height and radius are not to deviate.
 *
 * Variables:
 * height: Given in units of pegboard; raises or lowers your inlet, for convenience.  Must be a whole number.
 *
 * width: MINIMUM 2, I think max 3 by convention... not set in stone.
 * ***TODO: this parameter does not yet affect the width of the inlet.
 *
 * length: Given in units of pegboard; 1 or more.  Each extra unit adds its own hanger, if applicable.
 *
 * outlet: how the ball gets out; options are INLET_HOLE, INLET_SLOT, and INLET_NONE.  Hole is a single exit point; slot opens the entire side, and none does nothing.  All three still move the balls to the pegboard/outlet corner, however.
 * 
 * hanger_height: Given in units of pegboard, how tall your hanger should be.  Set to 0 for no hanger.
 */
module inlet(height = 1, width = 2, length = 1, hanger_height=1, lift=5, outlet=INLET_HOLE, inset = inlet_x-ball_rad*2-wall*2){
    //slope = .25*in;
    
    side_supports = length-1;
    
    inlet_x = inlet_x*length;
    
    lift_angle = atan(lift/inlet_x);
    drop_top = 4.6;
    
    %translate([in,-in/2,(height-.5)*in]) translate([0,0,0]) sphere(r=ball_rad);
    
    translate([0,-inlet_y,height*in-inlet_z])
    difference(){
        union() {
            hull(){
                cube([inlet_x,inlet_y,.1]);
                translate([0,0,inlet_z-drop_top]) rotate([0,-lift_angle,0]) cube([inlet_x+inset,inlet_y,.1]);
                //%translate([0,0,inlet_z-.1]) cube([inlet_x,inlet_y,.1]);
            }
            for(i=[0:length-1]){
                translate([i*inlet_x/length,inlet_y,-in+inlet_z]) difference(){
                    hanger(solid=1, hole=[1,1+hanger_height], drop = (hanger_height)*in);
                    hanger(solid=-1, hole=[1,1+hanger_height], drop =(hanger_height)*in);
                }
            }
        }
        
        //hollow center
        difference(){
            hull(){
                intersection(){
                    //ball divot
                    hull(){
                        translate([inlet_x,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                        translate([-inlet_x,inlet_y-in/2,in/2+5*length]) translate([0,0,0]) sphere(r=ball_rad);
                    }
                    hull(){
                        translate([wall,wall,0]) cube([inlet_x-wall*2,inlet_y-wall*2,.1]);
                        translate([wall,wall,inlet_z+lift]) cube([inlet_x-wall*2+inset,inlet_y-wall*2,.1]);
                    } 
                    //translate([wall,wall,wall]) cube([inlet_x-wall*2-inset,inlet_y-wall*2,inlet_z]);
                }
                translate([wall,wall,wall*2.5]) cube([inlet_x-wall*2,inlet_y-wall*2,.1]);
                translate([0,wall,inlet_z-drop_top+.1]) rotate([0,-lift_angle,0])  translate([wall,0,0]) cube([inlet_x+inset-wall*2,inlet_y-wall*2,.1]);
            }
            
            //wall supports
            for(i=[1:length-1]){
                translate([i*in,0,0]) rotate([30,0,0]) translate([0,0,in/4]) cube([wall/2, in+2*i,in+2*i], center=true);
            }
        }

		  //ball exit
		  if(outlet == INLET_HOLE){
              hull(){
                    translate([inlet_x,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    translate([inlet_x-in/2,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=ball_rad);
                }
            }
            
            if(outlet == INLET_SLOT){
              hull(){
                    translate([inlet_x,inlet_y-in/2,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    translate([inlet_x-in/2,inlet_y-in/2,in/2+5]) translate([0,0,0]) sphere(r=ball_rad);
                    translate([inlet_x,inlet_y-in/2-in,in/2]) translate([0,0,0]) sphere(r=in/2-wall);
                    translate([inlet_x-in/2,inlet_y-in/2-in,in/2+5]) translate([0,0,0]) sphere(r=ball_rad);
                }
            }
        
        //scalloped entry
        for(i=[0:in:inlet_y-1]){
            translate([-in/2,inlet_y-i,inlet_z-in/2]) track(rise=-1.5, run=17, solid=-1, track_rad=track_rad+.25);
            
        }
    }
}

//debating remaking the peg square...
//this is unfinished.  The round peg works.
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
            translate([0,-peg_thick/2-peg_sq,peg_sq/2]) rotate([0,90,0]) rotate_extrude(angle=90, $fn=30){
                translate([peg_sq/2,0,0]) square([peg_sq, peg_sq], center=true);
            }
            translate([-peg_sq/2,-peg_thick/2-peg_sq,peg_sq/2]) rotate([-90-angle,0,0]) cube([peg_sq, peg_thick, peg_sq]);
        }
    }
}

//added the option to make the peg have a locking pin, instead of a hook.
//todo: add an option for a long pin with a screwhole in it
module peg(pin=false){
    $fn=16;
    
    extra_inset = 2;
    
    peg_angle = 20;
    rear_inset = peg_rad*tan(peg_angle)+extra_inset;
    front_inset = rear_inset+slop-extra_inset;
    
    cutoff=1;
    
    translate([peg_sep/2,0,peg_sep*1.5]) 
    difference(){
        union(){
          //top rear
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([90,0,0]) cylinder(r1=peg_rad*3/4-slop/2, r2=peg_rad-slop, h=peg_thick+peg_rad-rear_inset);
            translate([0,peg_thick+peg_rad-rear_inset,0]) sphere(r=peg_rad*3/4-slop/2);
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([-peg_angle,0,0]) cylinder(r1=peg_rad*3/4-slop/2, r2=peg_rad*3/4-slop, h=peg_thick);
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([-peg_angle,0,0]) translate([0,0,peg_thick]) sphere(r=peg_rad*3/4-slop);
            
			
            //top front
            if(pin==false){
                translate([0,-wall+.1,0]) rotate([90,0,0]) cylinder(r1=peg_rad, r2=peg_rad*3/4, h=wall+peg_rad-front_inset);
                translate([0,-wall*2-front_inset,0]) sphere(r=peg_rad*3/4);
                translate([0,-wall*2-front_inset,0]) rotate([peg_angle,0,0]) cylinder(r1=peg_rad*3/4, r2=peg_rad*3/4-slop, h=wall*2);
                translate([0,-wall*2-front_inset,0]) rotate([peg_angle,0,0]) translate([0,0,wall*2]) sphere(r=peg_rad*3/4-slop);
            }else{
                //draw a pin connector instead
                rotate([90,0,0]) rotate([0,0,90]) translate([0,0,wall/2])pin_vertical(h=wall*2+wall/2,r=pin_rad,lh=wall,lt=pin_lt,t=pin_tolerance,cut=false);
            }
            
            //connect 'em
            hull(){
                rotate([90,0,0]) cylinder(r=peg_rad, h=wall);
                translate([0,0,-peg_sep*1.5]) rotate([90,0,0]) cylinder(r=peg_rad, h=wall);
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

module hanger(solid=0, hole=[1,4], slot_size = 0, drop = in/2, rot = 0){
    offset = (track_rad+wall);
    
    translate([in*hole[0]-peg_sep/2, 0, in*(hole[1]-1)]) 
    if(solid >= 0) union(){
        hull(){
            translate([-slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_rad+wall*2, h=wall);
            translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) cylinder(r=peg_rad+wall*2, h=wall);
                
            rotate([0,rot,0]) translate([0,0,peg_sep/2-drop])rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=peg_rad+wall, h=wall, $fn=8);
        }
    }
    
    translate([in*hole[0]-peg_sep/2, 0, in*(hole[1]-1)]) 
    if(solid <= 0) union(){
        for(i=[0:1]) hull(){
            translate([-slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.05]) cylinder(r1=peg_rad+slop, r2=peg_rad+wall+wall, h=wall*2);
            translate([slot_size/2,0,peg_sep/2]) rotate([90,0,0]) translate([0,0,wall/2]) mirror([0,0,i]) translate([0,0,-.05]) cylinder(r1=peg_rad+slop, r2=peg_rad+wall+wall, h=wall*2);
        }
    }
}

//track trough
module track_trough(angle=0, length=1, ta=240, z_angle = 0){
    difference(){
            union(){
                rotate([0,0,z_angle])
                rotate([0,angle,0]) difference(){
                    //%translate([length,0,0]) translate([0,0,ball_rad-track_rad]) sphere(r=ball_rad);
                    
                    rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=(track_rad+wall)/cos(180/8), h=length, $fn=8);
                    translate([-.5,0,0]) {
                        rotate([45,0,0]) cube([length+1, track_rad+wall*2, ball_rad+wall*2]);
                        for(i=[0,1]) mirror([0,i,0]) {
                            rotate([ta/2,0,0])  translate([0,0,-wall*2]) cube([length+1, track_rad+wall*2, track_rad+wall*2]);
                            translate([0,0,wall/2]) cube([length+1, track_rad+wall*2, track_rad+wall*2]);
                        }
                    }
                }
            }
        
            //ball path
            translate([-.5,0,0]) rotate([0,0,z_angle]) rotate([0,angle,0]) rotate([0,90,0]) cylinder(r=track_rad, h=length+2);
        }
}

module track_hollow(angle=0, length=1, ta=240, z_angle = 0){
    difference(){
        rotate([0,0,z_angle]) rotate([0,angle,0]) rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=(track_rad+wall)/cos(180/8)-.1, h=length, $fn=8);
        track_trough(angle=angle, length=length, ta=ta, z_angle = z_angle);
    }
}

//a 2d cross section of the track.  Used to make curves.
module track_slice(){
    projection() translate([0,0,1]) rotate([0,90,0]) track_trough(length=2);
}

module track_slice_2(){
    translate([0,0,-.01]) rotate([0,90,0]) track_trough(length=.02);
}

module track_hollow_slice_2(){
    difference(){
        intersection(){
            translate([wall,0,0]) cube([peg_sep,peg_sep-wall/2,.2], center=true);
            sphere(r=track_rad+wall);
        }
        translate([0,0,1]) rotate([0,90,0]) track_trough(length=2);
    }
}

module track_curve(angle=45){
    intersection(){
        translate([0,0,-peg_sep/2-.5]) cube([peg_sep+1, peg_sep+1, peg_sep+1]);
        translate([0,0,-peg_sep/2-.5]) rotate([0,0,angle]) cube([peg_sep, peg_sep, peg_sep]);
        rotate_extrude(convexity=10){
            rotate([0,0,90]) translate([0,in/2+.1,0]) track_slice();
        }
    }
}


module track_curve_2(angle=90, drop=-10, track_angle = -80){
    num_steps = 5;
    //translate([0,0,-peg_sep/2-.5]) cube([peg_sep+1, peg_sep+1, peg_sep+1]);
    //translate([0,0,-peg_sep/2-.5]) rotate([0,0,angle]) cube([peg_sep, peg_sep, peg_sep]);
    
    
    extra_drop = drop/(num_steps+1)*tan(90-track_angle);
    mirror([1,1,0])
    rotate([90,0,0]) 
    difference(){
        union(){
            //the inlet is extra-long, to meet the slope this attaches to.
            hull(){
                rotate([0,0,90]) translate([0*drop/(num_steps+1),in/2+.1,extra_drop]) track_slice_2();
                rotate([0,0,90]) translate([1*drop/(num_steps+1),in/2+.1,0]) track_slice_2();
            }
                
            //the curved angle
            for(i=[0:num_steps-1]){
                hull(){
                    rotate([0,i*angle/num_steps,0]) rotate([0,0,90]) translate([(i+1)*drop/(num_steps+1),in/2+.1,0]) track_slice_2();
                    rotate([0,(i+1)*angle/num_steps,0]) rotate([0,0,90]) translate([(i+2)*drop/(num_steps+1),in/2+.1,0]) track_slice_2();
                }
            }
        }
        //inlet
        hull(){
            rotate([0,0,90]) translate([0*drop/(num_steps+1),in/2+.1,extra_drop]) track_hollow_slice_2();
            rotate([0,0,90]) translate([1*drop/(num_steps+1),in/2+.1,0]) track_hollow_slice_2();
        }
        
        //curved part
        for(i=[0:num_steps-1]){
            hull(){
                rotate([0,i*angle/num_steps,0]) rotate([0,0,90]) translate([(i+1)*drop/(num_steps+1),in/2+.1,0]) track_hollow_slice_2();
                rotate([0,(i+1)*angle/num_steps,0]) rotate([0,0,90]) translate([(i+2)*drop/(num_steps+1),in/2+.1,0]) track_hollow_slice_2();
            }
        }
    }
}


//section of track.
//Length is in mm.
//Start is at 0 (move it where you want it) end is length units away horizontally, at the specified angle.
//rise and run are both inches - length and angle are calculated from them.
//solid = 1: draw the track
//solid = 0: draw both track and path
//solid = -1: draw the marble path - useful for making holes in things.
//
//start/end dictate the angle at the end of the track.  This is a 1" radius, period - defaults to 0, which is straight; angles over 90 or under -90 result in +/-90.
module track(rise=-in, run=in*5, z_out=0, solid=1, track_angle=120, start=0, end_angle=0, extra_len = in, end_scale=[1,1,1]){

	 angle = -atan(rise/run);
     z_angle = -atan(z_out/run);

    ta = 360-track_angle;
    
    //track_rad+wall
    //extra = abs(cos(90-angle)*(track_rad+wall)); //how much longer to make track due to its thickness
    extra = 0;
    length = sqrt(rise*rise+run*run);
    
    //
    end_subtract = sin(end_angle)*(track_rad+wall)*2;
    
    translate([0,0,track_rad+wall])
    if(solid>=0){
        difference(){
            union(){
                %translate([0,-peg_sep/2,0]) translate([0,0,ball_rad-track_rad]) sphere(r=ball_rad);
                translate([0,-peg_sep*.5,0]) track_trough(angle, length+extra-end_subtract, ta, z_angle=z_angle);
            
                //#rotate([0,angle,0]) translate([length+extra,0,0]) translate([-peg_sep,-peg_sep, -peg_sep/2]) cube([peg_sep, peg_sep, peg_sep]);
            
                echo("track end echoes");
                echo(rise-in*rise/run);
                echo(length);
                echo(extra);
                echo(end_subtract);
                //curve the end, as needed
                translate([0,-peg_sep,0]) 
                rotate([0,angle,0]) translate([length+extra-end_subtract,0,0])
                //translate([0,0,rise-in*rise/run]) 
                rotate([0,-angle,0]) translate([0,0,-4*rise/run]) scale(end_scale) track_curve_2(angle=end_angle, drop=in*rise/run*1.125, track_angle=angle);
            }
            //make the ends flat
            translate([50+run+extra+(end_scale[0]-1)*end_subtract,0,0]) cube([100,200,200], center=true);
            translate([-50,0,0]) cube([100,200,200], center=true);
        }
    }
    
	 //this is used to hollow out things that the track is supposed to connect to, and to make sure that the ball path is clear.
    translate([0,0,track_rad+wall])
    if(solid<=0){
        *translate([-.5,0,0]) translate([0,-peg_sep*.5,track_rad+wall]) rotate([0,angle,0]) *rotate([0,90,0]) cylinder(r=track_rad, h=extra_len*2, center=true);
        
        translate([0,-peg_sep*.5,0]) track_hollow(angle, length+extra-end_subtract, ta, z_angle=z_angle);
    }
}