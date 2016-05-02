include <../configuration.scad>;
use <../base.scad>;

//chain variables
width = in-1;
length = in;
hook_width = wall;
core = width-wall-wall-1;
shaft=2;
thickness = wall-1;


//ball grabber


stab_rad=4; //radius of stabilizer triangle

%pegboard([10,10]);
%cube([200,200,1],center=true);



link();


module link(){
    $fn=30;
    translate([0,0,thickness/2]) 
    difference(){
        union(){
            translate([-shaft/2,0,0]) cube([length+shaft,core,thickness], center=true);
            
            //hook interface rod
            translate([-length/2,0,thickness+shaft/2]) rotate([90,0,0]) difference(){
                union(){
                    cylinder(r=shaft, h=width, center=true);
                    translate([0,-shaft/2,0]) scale([1,1.5,1]) cylinder(r=shaft, h=core, center=true);
                }
                hull(){
                    translate([5,ball_rad-shaft,0]) sphere(ball_rad+.2);
                    translate([-5,ball_rad-shaft,0]) sphere(ball_rad+.2);
                }
            }
            
            
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
            translate([-shaft*2-1,0,0]) difference(){
                %translate([0,0,ball_rad+thickness]) sphere(r=ball_rad);
                hull(){
                    translate([0,0,ball_rad]) rotate([90,0,0]) cylinder(r=ball_rad+wall, h=ball_rad+wall, center=true);
                    translate([0,0,ball_rad+wall]) rotate([90,0,0]) cylinder(r=ball_rad+wall, h=ball_rad+wall, center=true);
                }
                
                //cutout
                hull(){
                    translate([0,0,ball_rad+wall/2]) rotate([90,0,0]) sphere(r=ball_rad+slop);
                    translate([-15,0,ball_rad*2]) rotate([90,0,0]) sphere(r=ball_rad*2);
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