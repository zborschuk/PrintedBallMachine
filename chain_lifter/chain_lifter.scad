include <../configuration.scad>;
use <../base.scad>;

//chain variables
width = in-1;
length = in;
hook_width = wall;
core = width-wall-wall-1;
shaft=3;
thickness = wall;
groove_rad = 2;

idler_shaft=6;

jut = 11;


$fn=60;

stab_rad=4; //radius of stabilizer triangle

//this is the face of the driving gear - it should be related to the length a bit better.
face = in-shaft*2-1;

//render everything
part=6;

//parts for laser cutting
if(part == 0)
    link(ball_grabber=true);
if(part == 1)
    link(ball_grabber=false);
if(part == 2)
    drive_gear();
if(part == 3)
    idler_gear();
if(part == 4)
    cl_inlet();
if(part == 5)
    cl_outlet();
if(part == 6){
    link(ball_grabber=true);
    translate([length,0,0]) link(ball_grabber=false);
    translate([length,0,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
}

clearance_rad = 55;
angle = 60;
if(part==10){
    
    //do a full loop of links
    link(ball_grabber=true);
    translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
    translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
    
    //todo: place these correctly
    cl_inlet();
    
    //drive gear
    translate([length/2,0,-in*3-thickness-.5]) rotate([90,0,0]) drive_gear();
    
    cl_outlet();
}

module drive_gear(){
    translate([0,clearance_rad+wall,0]) difference(){
        union(){
            cylinder(r=face, h=in, center=true, $fn=6);
            
            //alignment groove
            hull() for(i=[0:60:359]) rotate([0,0,i]) {
                translate([0,face*cos(180/6),0]) rotate([0,90,0]) cylinder(r=groove_rad-slop/2, h=face-thickness, center=true, $fn=6);
            }
        
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

module idler_gear(){
    translate([0,clearance_rad+wall,0]) difference(){
        union(){
            cylinder(r=face, h=in, center=true, $fn=6);
            
            //alignment groove
            hull() for(i=[0:60:359]) rotate([0,0,i]) {
                translate([0,face*cos(180/6),0]) rotate([0,90,0]) cylinder(r=groove_rad-slop/2, h=face-thickness, center=true, $fn=6);
            }
        
            //clearance for the balls
            %cylinder(r=32, h=2, center=true);

            //clearance for the arms - ball loading
            %cylinder(r=clearance_rad, h=1, center=true);
        }
        
        //shaft
        cylinder(r1=idler_shaft+1, r2=idler_shaft, h=50, center=true);
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
                    hanger(solid=1, hole=[1,1+hanger_h], drop =hanger_h);
                    hanger(solid=-1, hole=[1,1+hanger_h], drop =hanger_h);
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
    
    translate([length/2,0,-(shaft+thickness/2)]) 
    difference(){
        union(){
            //straight bit
            translate([-core_shorten/2+2,0,0]) cube([length-core_shorten-4,core,thickness], center=true);
            hull(){
                #translate([-core_shorten+shaft*1.5+4,0,0]) cube([length-core_shorten-shaft*3,core,thickness], center=true);
                #translate([length/2-core_shorten/2-3,0,0]) cube([core_shorten/2,width,thickness], center=true);
            }
            
            //hook interface rod
            translate([-length/2,0,shaft+thickness/2]) rotate([90,0,0]) difference(){
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
                    translate([0,0,shaft])
                    rotate([90,0,0]) cylinder(r=shaft+slop, h=width+1, center=true);
                    translate([-shaft*4,0,shaft*3]) rotate([90,0,0]) cylinder(r=shaft*3, h=width+1, center=true);
                }
            }
            
            //ball grabber
            if(ball_grabber == true){
                translate([-shaft*2-1,0,jut]) difference(){
                    %translate([0,0,ball_rad+thickness]) sphere(r=ball_rad);
                    intersection(){
                        hull(){
                            translate([0,0,ball_rad-jut]) rotate([90,0,0]) cylinder(r=ball_rad+wall, h=ball_rad+wall, center=true);
                            translate([0,0,ball_rad+wall]) rotate([90,0,0]) cylinder(r=ball_rad+wall+jut/4, h=ball_rad+wall, center=true);
                        }
                        translate([shaft*2+1,0,-jut]) translate([length/2-core_shorten*1.5,0,0]) cube([core_shorten*3,core,thickness*50], center=true);
                        
                    }
                
                    //cutout
                    hull(){
                        translate([0,0,ball_rad+wall/2]) rotate([90,0,0]) sphere(r=ball_rad+slop);
                        translate([-15,0,ball_rad*2]) rotate([90,0,0]) sphere(r=ball_rad*2);
                        translate([-15,0,ball_rad*2-jut]) rotate([90,0,0]) sphere(r=ball_rad*2);
                    }
                }
            }
            
            //alignment groove beefinator
            *translate([0,0,-thickness/2]) rotate([0,90,0]) rotate([0,0,30])           
               cylinder(r=groove_rad+thickness, h=core, center=true, $fn=6);
        }
        
        //flatten the bottom
        translate([0,0,-25-thickness/2]) cube([50,50,50], center=true);
        
        //alignment groove
        translate([0,0,-thickness/2]) rotate([0,90,0]) rotate([0,0,30]) cylinder(r=groove_rad+slop/2, h=100, center=true, $fn=6);
    }
}

//next section
%translate([in*5,0,in]) inlet(height=2);