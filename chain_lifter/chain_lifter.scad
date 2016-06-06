include <../configuration.scad>;
use <../base.scad>;

//chain variables
width = in-1;
length = in;
hook_width = wall;
core = width-wall-wall-1;
shaft=2;
thickness = wall-1;

jut = 11;


$fn=60;
    
//ball grabber


stab_rad=4; //radius of stabilizer triangle


//this is the face of the driving gear - it should be related to the length a bit better.
face = in-shaft*2-1;

//%pegboard([10,10]);
//%cube([200,200,1],center=true);


clearance_rad = 55;

//drive gear mockup
%translate([length/2,0,-in+shaft+1+.5-.05]) rotate([90,0,0]) cylinder(r=face, h=in, center=true, $fn=6);

//clearance for the balls
%translate([length/2,0,-in+shaft+1+.5-.05]) rotate([90,0,0]) cylinder(r=32, h=2, center=true);

//clearance for the arms - ball loading angle
%translate([length/2,0,-in+shaft+1+.5-.05]) rotate([90,0,0]) cylinder(r=clearance_rad, h=2, center=true);


angle=60;

link(ball_grabber=true);
translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);

//yay
cl_inlet();

drive_gear();

module drive_gear(){
    translate([0,clearance_rad+wall,0]) difference(){
        union(){
            cylinder(r=face, h=in, center=true, $fn=6);
        
            //clearance for the balls
            %cylinder(r=32, h=2, center=true);

            //clearance for the arms - ball loading
            %cylinder(r=clearance_rad, h=1, center=true);
            
            //extra bump for the motor
            translate([0,0,motor_bump/2]) cylinder(r=motor_shaft, h=in+motor_bump, center=true);
        }
        
        //d shaft
        translate([0,0,-30]) d_slot(shaft=motor_shaft, height=60, dflat=motor_dflat);
    }
}

module guide_moon(){
    hull(){
        translate([inlet_width/2*in, wall*2.5, in*1.5]) cylinder(r=clearance_rad, h=in, center=true);
        translate([inlet_width/2*in, wall*2.5, in*1.5]) cylinder(r=clearance_rad+wall*2, h=.1, center=true);
    }
}

module cl_inlet(){
    inlet_width = 6;
    %translate([inlet_width/2*in,0,in*1.5]) drive_gear();
    
    hanger_h = 3*in;
    
    difference(){
        union(){
            //tray
            intersection(){
                rotate([-90,0,0]) inlet(length=inlet_width, outlet=NONE, hanger_height=0, hanger_vert=true);
                rotate([-90,0,0]) translate([inlet_width*in,0,0]) mirror([1,0,0]) inlet(length=inlet_width, outlet=NONE, hanger_height=0);
            }
            
            //hangers
                #translate([in,hanger_h,-in+inlet_z]) rotate([-90,0,0]) difference(){
                    hanger(solid=1, hole=[1,1+hanger_height], drop =hanger_h);
                    hanger(solid=-1, hole=[1,1+hanger_height], drop =hanger_h);
                }
            
            //flat floor - will cut into it later, to slope the marbles in.
            cube([inlet_width*in,wall*4,in*3]);
            
            //guide moon, and blocker
            intersection(){
                guide_moon(inlet_width=inlet_width);
                cube([inlet_width*in,in*2,in*3]);
            }
            
            //motor mount
            translate([inlet_width/2*in,clearance_rad+wall,in]) hull(){
                motorHoles(1, support=true);
                translate([0,-clearance_rad+wall,-in]) cylinder(r=wall, h=wall*2);
            }
        }
        
        //bed hollow
        translate([inlet_width/2*in, clearance_rad+wall, in*1.5]) hull(){
            cylinder(r=clearance_rad, h=in+.1, center=true);
            cylinder(r=clearance_rad+wall/2, h=.1, center=true);
        }
        
        //motor mount
        translate([inlet_width/2*in,clearance_rad+wall,in]) motorHoles(0);
        
        //bed slope
        difference(){
            hull(){
                translate([inlet_width/2*in, clearance_rad+wall, in*1.5]) cylinder(r=clearance_rad, h=in, center=true);
                translate([wall,wall*4,wall]) cube([inlet_width*in-wall*2,.1,in*3-wall*2]);
            }
            //guide moon, and blocker
            guide_moon(inlet_width=inlet_width);
        }
    }
}

module link(ball_grabber=true){
    core_shorten = shaft*3;
    
    translate([length/2,0,thickness/2-shaft*2]) 
    difference(){
        union(){
            translate([0,0,0]) cube([length-core_shorten,core,thickness], center=true);
            hull(){
                translate([length/2-core_shorten*2,0,0]) cube([core_shorten*2,core,thickness], center=true);
                translate([length/2-core_shorten,0,0]) cube([core_shorten,width,thickness], center=true);
            }
            
            //hook interface rod
            translate([-length/2,0,thickness+shaft/2]) rotate([90,0,0]) difference(){
                union(){
                    cylinder(r=shaft, h=width, center=true);
                    hull(){
                        cylinder(r=shaft, h=core, center=true);
                        translate([shaft,-shaft,0]) cylinder(r=shaft, h=core, center=true);
                        translate([shaft*2,-shaft,0]) cylinder(r=shaft, h=core, center=true);
                    }
                }
                hull(){
                    translate([5,ball_rad-shaft,0]) sphere(ball_rad+.2);
                    translate([-5,ball_rad-shaft,0]) sphere(ball_rad+.2);
                }
            }
            
            
            //hooks
            translate([length/2,0,thickness/2]) difference(){
                translate([0,0,shaft]) rotate([90,0,0]) cylinder(r=shaft*3, h=width, center=true);
                //cut out the middle
                translate([0,0,0]) cube([length,width-hook_width*2, 20], center=true);
                translate([0,0,10]) cube([length,width-hook_width*2, 20], center=true);
                
                //room for the next link, and opening
                hull(){
                    translate([0,0,shaft+slop]) rotate([90,0,0]) cylinder(r=shaft+slop, h=width+1, center=true);
                    translate([-shaft*4,0,shaft*3]) rotate([90,0,0]) cylinder(r=shaft*3, h=width+1, center=true);
                }
            }
            
            //ball grabber
            if(ball_grabber == true){
                translate([-shaft*2-1,0,jut]) difference(){
                    %translate([0,0,ball_rad+thickness]) sphere(r=ball_rad);
                    hull(){
                        translate([0,0,ball_rad-jut]) rotate([90,0,0]) cylinder(r=ball_rad+wall, h=ball_rad+wall, center=true);
                        translate([0,0,ball_rad+wall]) rotate([90,0,0]) cylinder(r=ball_rad+wall+jut/4, h=ball_rad+wall, center=true);
                    }
                
                    //cutout
                    hull(){
                        translate([0,0,ball_rad+wall/2]) rotate([90,0,0]) sphere(r=ball_rad+slop);
                        translate([-15,0,ball_rad*2]) rotate([90,0,0]) sphere(r=ball_rad*2);
                        translate([-15,0,ball_rad*2-jut]) rotate([90,0,0]) sphere(r=ball_rad*2);
                    }
                }
            }
        }
        
        //flatten the bottom
        translate([0,0,-25-thickness/2]) cube([50,50,50], center=true);
    }
}

//next section
%translate([in*5,0,in]) inlet(height=2);