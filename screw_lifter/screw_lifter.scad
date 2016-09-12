include <../configuration.scad>;
use <../base.scad>;

part = 10;

screw_rad = ball_rad+wall*2;
screw_pitch = ball_rad*2+wall;
screw_offset = -wall-screw_rad-.9;

//next section
%translate([in*12,0,in*10]) inlet();

//laid out for printing
if(part == 0)
    screw_inlet();
if(part == 1)
    screw_segment();
if(part == 2)
    screw_outlet();
if(part == 3)
    screw_guide();


if(part==10){
    assembled();
}

angle = 55;

module assembled(){

    %pegboard([12,12]);
    %translate([peg_sep*3.8,-ball_rad,peg_sep*3.2]) sphere(r=ball_rad);
    
    screw_inlet();
    
    translate([peg_sep*2,screw_offset,0]) rotate([0,angle,0]) translate([0,0,-screw_pitch]) screw_segment();
    translate([peg_sep*2,screw_offset,0]) rotate([0,angle,0]) translate([0,0,3*screw_pitch]) screw_segment();
}

module screw_inlet(){
    difference(){
        union(){
            inlet(length=2.5, inset=0, outlet=NONE);
            
            //motor mount
            //motor hangs under the inlet, with an adustable angle centered on the hole in the floor.
            translate([peg_sep*2,screw_offset,0]) rotate([0,-90+angle,0]) rotate([0,90,0]) rotate([0,0,-90]) translate([0,0,-21]) motor_holes();
        }
        
        //angled hole for the screw
        translate([in*2.5,screw_offset, 0]) hull() {
            translate([0,0,-peg_sep/2]) cylinder(r=screw_rad+1, h=100);
            rotate([0,30,0]) translate([0,0,-peg_sep]) cylinder(r=screw_rad+1, h=100);
            rotate([0,60,0]) translate([0,0,-peg_sep]) cylinder(r=screw_rad+1, h=100);
        }
        
        
    }
}

//length is measured in revolutions!
module screw_segment(length = 4){  
    pitch = screw_pitch;
    
    screw_inner_rad = (7.5+wall)/2;
    difference(){
        union(){        
            //main tube
            cylinder(r=screw_inner_rad, h=length*pitch);
            
            //we'll need a screw, too...
            translate([0,0,-pitch]) screw_threads(length = (length+1)*pitch, pitch = pitch);
            
            //and we should connect to the next screw along
            translate([0,0,length*pitch-.1]) d_slot(shaft=7.5-slop*2, height=10-slop*2, dflat=.4+.3-slop, double_d=true);
        }
        
        //d slot for the connection
        translate([0,0,-.1]) d_slot(shaft=7.5, height=10, dflat=.4+.3, double_d=true);
        
        //flatten the base
        translate([0,0,-50]) cube([50,50,100], center=true);
    }
}

module screw_threads(length = 30, pitch = 5){
    facets = 30;
    
    inner_rad = 7;
    
    stretch = 1.1;
    
    intersection(){
        cylinder(r=screw_rad-slop, h=length);
        
        for(turn=[0:pitch:length]) translate([0,0,turn]) {
            //single ring
            for(i=[0:facets]) {
                hull(){
                    rotate([0,0,i*(360/facets)]) translate([inner_rad,0,i*pitch/facets]) scale([stretch,1,1]) rotate([90,0,0]) cylinder(r=screw_rad-slop-inner_rad, h=.1, center=true, $fn=3);
                    
                    rotate([0,0,(i+1)*360/facets]) translate([inner_rad,0,(i+1)*pitch/facets]) scale([stretch,1,1]) rotate([90,0,0]) cylinder(r=screw_rad-slop-inner_rad, h=.1, center=true, $fn=3);
                }
            }
        }
        
    }
}

module motor_holes(){
    translate([0,37/2-12+.1,-20.8/2-5]) cube([22.3+1,37+1,20.8+10], center=true);
    hull(){
        translate([0,37-12,-20.8/2]) rotate([-90,0,0]) cylinder(r=22/2, h=28);
        translate([0,37-12,-20.8/2-10]) rotate([-90,0,0]) cylinder(r=24/2, h=28);
    }
   translate([0,0,-1]){
       //center hole is overwritten by the sprocket hole, but it's good to have
       cylinder(r=5.2, h=25);
       
       //bump - straight up
       translate([0,12,0]) cylinder(r=2.6, h=3.1);
       
       //mounting holes
       for(j=[1,1]) mirror([0,0,j]) translate([0,0,(20.8-2)*j]) for(i=[0,1]) mirror([i,0,0]) translate([17.5/2,20,0]) {
           cylinder(r=2.9/2, h=80, center=true, $fn=12);
           //translate([0,0,2.6]) cylinder(r1=3.3/2, r2=3.1, h=1.5);
           //translate([0,0,wall+1]) cylinder(r=3.3, h=300);
       }
   }       
}