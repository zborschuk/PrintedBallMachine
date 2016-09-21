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

angle = 45;

module assembled(){

    %pegboard([12,12]);
    %translate([peg_sep*3.8,-ball_rad,peg_sep*3.2]) sphere(r=ball_rad);
    
    screw_inlet();
    
    translate([peg_sep*2,screw_offset,0]) rotate([0,angle,0]) translate([0,0,-screw_pitch]) screw_segment();
    translate([peg_sep*2,screw_offset,0]) rotate([0,angle,0]) translate([0,0,3*screw_pitch]) screw_segment();
    translate([peg_sep*2,screw_offset,0]) rotate([0,angle,0]) translate([0,0,7*screw_pitch]) screw_segment();
    
    translate([peg_sep*9,0,peg_sep*7]) screw_outlet();
}

module screw_outlet(){
    
    difference(){
        union(){
            inlet(length=3, inset=0);
        }
        
        //angled hole for the screw
        translate([0,screw_offset, 0]) hull() {
            translate([0,0,-peg_sep/2]) cylinder(r=screw_rad+1, h=100);
            rotate([0,30,0]) translate([0,0,-peg_sep]) cylinder(r=screw_rad+1, h=100);
            rotate([0,60,0]) translate([0,0,-peg_sep]) cylinder(r=screw_rad+1, h=100);
        }
    }
}

module slide_motor_mount(angle_inset = 20, max_angle = 75, motor_width = 20){
    
    zip_width = 3;
    zip_length = 5;
    
    sweep_angle = max_angle + 5;
    rad = angle_inset + motor_width+zip_width*4;
    
    difference(){
        //body
        intersection(){
            rotate([90,0,0]) cylinder(r=rad, h=wall);
            translate([-50,0,-50]) cube([100,100,100], center=true);
            rotate([0,90-sweep_angle,0]) translate([-50,0,-50]) cube([100,100,100], center=true);
        }
        
        //slots for zip ties to attach the motor
        for(i=[5:360/100:max_angle-zip_width]) rotate([0,-i,0])  {
            translate([-angle_inset,0,0]) cube([zip_width, wall*3, zip_length], center=true);
            translate([-angle_inset-motor_width-zip_width,0,0]) cube([zip_width, wall*3, zip_length], center=true);
        }
    }
}


module screw_inlet(){
    motor_width = 20;
    
    difference(){
        union(){
            inlet(length=2.5, inset=0, outlet=NONE);
            
            //motor hangs under the inlet, with an adustable angle centered on the hole in the floor.
            %translate([peg_sep*2,screw_offset,0]) rotate([0,-90+angle,0]) rotate([0,90,0]) rotate([0,0,-90]) translate([0,0,-21]) motor_holes();
            
            //the motor mount uses a zip tie to hold the motor in, allowing it to pivot to angle the screw a bit.
            translate([peg_sep*2.5,0,-.1]) slide_motor_mount(angle_inset = 30);
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
module screw_segment(length = 4, starts = 2){  
    pitch = screw_pitch*starts;
    
    screw_inner_rad = (7.5+wall)/2;
    difference(){
        union(){        
            //main tube
            cylinder(r=screw_inner_rad, h=length*pitch);
            
            //we'll need a screw, too...
            for(i=[1:starts]) rotate([0,0,i*(360/starts)]) translate([0,0,-pitch]) screw_threads(length = (length+1)*pitch, pitch = pitch);
            
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