include <../configuration.scad>;
use <../base.scad>;

//chain variables
width = in-1;
length = in;
hook_width = wall;
core = width-wall-wall-1;
shaft=wall/2;
thickness = wall-1;

//ball grabber


stab_rad=4; //radius of stabilizer triangle

%pegboard([10,10]);
%cube([200,200,1],center=true);

%translate([0,0,ball_rad+thickness]) sphere(r=ball_rad);

link();


module link(){
    $fn=30;
    translate([0,0,thickness/2]) 
    difference(){
        union(){
            cube([length,core,thickness], center=true);
            
            //hook interface
            translate([-length/2,0,0]) rotate([90,0,0]) cylinder(r=shaft, h=width, center=true);
            
            //hooks
            //cube([hook]);
            translate([length/2,0,thickness/2]) difference(){
                translate([0,0,shaft]) rotate([90,0,0]) cylinder(r=shaft*3, h=width, center=true);
                //cut out the middle
                translate([0,0,10]) cube([length,width-hook_width*2, 20], center=true);
                
                //room for the next link, and opening
                hull(){
                    translate([0,0,shaft+slop]) rotate([90,0,0]) cylinder(r=shaft+slop, h=width+1, center=true);
                    translate([-shaft*3,0,shaft*2]) rotate([90,0,0]) cylinder(r=shaft*2, h=width+1, center=true);
                }
            }
            
            //ball grabber
            difference(){
                translate([0,0,ball_rad]) rotate([90,0,0]) cylinder(r=ball_rad+wall, h=ball_rad, center=true);
                
                hull(){
                    translate([0,0,ball_rad+wall/2]) rotate([90,0,0]) sphere(r=ball_rad+slop);
                    translate([-10,0,ball_rad+wall]) rotate([90,0,0]) sphere(r=ball_rad*2);
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