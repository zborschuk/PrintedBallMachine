include <../configuration.scad>;
use <../base.scad>;
use <../pins.scad>;

//motor variables
dflat=.2;
shaft=5+slop;
shaft_offset = 7;
motor_rad = 33/2;
motor_mount_rad = 38/2;
m3_rad = 1.7;
m3_nut_rad = 3.5;

//pin variables moved to configuration.scad


drive_rad = motor_rad+shaft_offset-wall-.5;
echo(drive_rad);

%pegboard([10,10]);
%cube([200,200,1],center=true);

stair_inlet();
//move to proper location
translate([peg_sep,-peg_sep,peg_sep-motor_rad-shaft_offset])
rotate([90,0,0])
drive_gear();

module stair_inlet(){
    $fn=30;
    difference(){
        union(){
            inlet(height=2, width=2, length=2, outlet=INLET_SLOT, hanger_height=1);
            
            //add a motor mount underneath the inlet
            translate([peg_sep,0,peg_sep-motor_rad]) {
                %rotate([90,0,0]) cylinder(r=motor_rad, h=in);
                for(i=[-motor_mount_rad, motor_mount_rad]){
                    translate([i,0,0]) difference(){
                        hull(){
                            rotate([90,0,0]) rotate([0,0,45]) cylinder(r=m3_rad+wall*2, h=in-wall, $fn=4);
                            translate([0,0,motor_rad-wall]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r=m3_rad+wall*2, h=in-wall, $fn=4);
                        }
                        
                        //motor mounting holes
                        translate([0,.1,0]) rotate([90,0,0]) cylinder(r=m3_rad, h=peg_sep/2);
                        translate([0,-peg_sep/2-.2,0]) rotate([90,0,0]) cylinder(r=m3_rad, h=peg_sep/2);
                        
                        //nut traps
                        translate([0,-peg_sep/2+wall,0]) hull(){
                            rotate([90,0,0]) cylinder(r=m3_nut_rad, h=wall, $fn=6);
                            translate([i,0,0]) rotate([90,0,0]) cylinder(r=m3_nut_rad, h=wall, $fn=6);
                        }
                    }
                }
            }
        }
        translate([peg_sep,0,peg_sep-motor_rad]) rotate([90,0,0]) cylinder(r=motor_rad, h=in);
    }
}

module drive_gear(){
    difference(){
        union(){
            cylinder(r=drive_rad, h=wall);
            //translate([0,rad-pin_rad,0]) cylinder(r=pin_rad, h=wall*2);
            translate([0,drive_rad-pin_rad,0]) {
                //pin(h=wall*2,r=pin_rad,lh=wall,lt=1,t=.3);
                translate([0,0,wall/2])pin_vertical(h=wall*2+wall/2,r=pin_rad,lh=wall,lt=pin_lt,t=pin_tolerance,cut=false);
            }
        }
        d_slot(shaft=shaft, height=20, dflat=dflat);
    }
}

bar();

//link stuff together
module bar(slot = peg_sep/2, length=peg_sep*2){
    $fn=30;
    difference(){
        union(){
            //body
            translate([0,0,wall/2]) cube([length, wall*2, wall], center=true);
            cylinder(r=pin_rad+wall, h=wall);
            
            //slot side
            translate([-length/2,0,0]) hull()
                for(i=[-slot/2, slot/2]){
                    translate([i,0,0]) cylinder(r=pin_rad+wall, h=wall);
                }
                
            //peg side
            translate([length/2,0,0]) {
                translate([0,0,wall/2])pin_vertical(h=wall*2+wall/2,r=pin_rad,lh=wall,lt=pin_lt,t=pin_tolerance,cut=false);
                cylinder(r=pin_rad+wall, h=wall);
            }
        }
        
        //slot
        translate([-length/2,0,0]) hull()
            for(i=[-slot/2, slot/2]){
                translate([i,0,0]) cylinder(r=pin_rad+slop, h=wall*3, center=true);
            }
        
        //pivot
        cylinder(r=pin_rad+slop, h=wall*3, center=true);
    }
}

//special peg for mounting the bars
module bar_peg(){
}

module stair_step(height=15){
}

module d_slot(shaft=6, height=10, tolerance = .2, dflat=.25, $fn=30){
    translate([0,0,-.1]){
       difference(){ 
           cylinder(r1=shaft/2+tolerance, r2=shaft/2+tolerance/2, h=height+.01);
           translate([-shaft/2,shaft/2-dflat,0]) cube([shaft, shaft, height+.01]);
           translate([-shaft/2,-shaft/2-shaft+dflat,0]) cube([shaft, shaft, height+.01]);
       }
    }
}

//next section
%translate([in*5,0,in]) inlet(height=5);