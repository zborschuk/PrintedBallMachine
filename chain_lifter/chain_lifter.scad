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


//drive gear mockup
%translate([length/2,0,-in+shaft+1+.5-.05]) rotate([90,0,0]) cylinder(r=face, h=in, center=true, $fn=6);

//clearance for the balls
%translate([length/2,0,-in+shaft+1+.5-.05]) rotate([90,0,0]) cylinder(r=32, h=2, center=true);

//clearance for the arms - ball loading angle
%translate([length/2,0,-in+shaft+1+.5-.05]) rotate([90,0,0]) cylinder(r=53, h=2, center=true);


angle=60;

link(ball_grabber=true);
translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=true);
translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) translate([length,0,0]) rotate([0,angle,0]) link(ball_grabber=false);

//yay
inlet();

module inlet(){
    
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

//should let balls come in both sides
module inlet(){
}

module outlet(){
}

//next section
%translate([in*5,0,in]) inlet(height=2);