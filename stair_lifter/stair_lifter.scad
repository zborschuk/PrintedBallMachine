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

stab_rad=4; //radius of stabilizer triangle

%pegboard([10,10]);
%cube([200,200,1],center=true);

//rotate([-90,0,0])
stair_inlet();

cam_length = ball_rad*2+2;

translate([peg_sep,-peg_sep,peg_sep-motor_rad-shaft_offset]) rotate([0,90,0]) difference(){
    drive_shaft(length=in+.5, solid=1);
    drive_shaft(length=in+.5, solid=0, dslot=true);
}

cam_angle = 180;



cam_lift = max(0,ball_rad*1.5*cos(cam_angle-90));
cam_lift_2 = max(0,ball_rad*1.5*cos(cam_angle+0));

echo(cam_lift);
echo(cam_lift_2);


step_height = 10;

translate([peg_sep*2+1,-peg_sep,peg_sep-motor_rad-shaft_offset]){
    rotate([0,90,0]) rotate([0,0,cam_angle]) cam_shaft(width = peg_sep*2, length = cam_length, max_rad = ball_rad*2.5);
    translate([cam_length,0,0]) rotate([0,90,0]) rotate([0,0,cam_angle+90]) cam_shaft(width = peg_sep*2, length = cam_length, max_rad = ball_rad*2.5);
}

translate([peg_sep*2+1,-wall,peg_sep/2-3]){
    translate([0,0,cam_lift]) stair_step(cam_height=14, length=cam_length);
    translate([cam_length,0,cam_lift_2]) stair_step(cam_height=14+step_height, length=cam_length);
}

translate([peg_sep*2+1,0,peg_sep]) guide_rail(cam_length=cam_length, step_height=step_height, num_cams=4);


module stair_inlet(){
    $fn=30;
    difference(){
        union(){
            inlet(height=2, width=2, length=2, outlet=INLET_SLOT, hanger_height=1, inset=0);
            
            //add a motor mount underneath the inlet
            rotate([0,0,-90]) translate([peg_sep,peg_sep,peg_sep-motor_rad]) {
                %rotate([90,0,0]) cylinder(r=motor_rad, h=in);
                for(i=[-motor_mount_rad, motor_mount_rad]){
                    translate([i,0,0]) difference(){
                        hull(){
                            rotate([90,0,0]) rotate([0,0,45]) cylinder(r=m3_rad+wall*2, h=in/2, $fn=4);
                            translate([0,0,motor_rad-wall]) rotate([90,0,0]) rotate([0,0,45]) cylinder(r=m3_rad+wall*2, h=in/2, $fn=4);
                        }
                        
                        //motor mounting holes
                        translate([0,.1,0]) rotate([90,0,0]) cylinder(r=m3_rad, h=peg_sep/2);
                        translate([0,-peg_sep/2-.2,0]) rotate([90,0,0]) cylinder(r=m3_rad, h=peg_sep/2);
                        
                        //nut traps
                        translate([0,-peg_sep/2+wall,0]) hull(){
                            rotate([90,0,0]) cylinder(r1=m3_nut_rad, r2=m3_nut_rad+slop, h=wall+1, $fn=6);
                            //translate([i,0,0]) rotate([90,0,0]) cylinder(r=m3_nut_rad, h=wall, $fn=6);
                        }
                    }
                }
            }
        }
        rotate([0,0,-90]) translate([peg_sep,peg_sep+.1,peg_sep-motor_rad]) rotate([90,0,0]) cylinder(r=motor_rad, h=in);
    }
}

module cam_shaft(width = peg_sep*2, length = ball_rad*2, max_rad = ball_rad*2.5){
    $fn=60;
    base_rad = ball_rad;
    end_rad = wall;
    
    difference(){
        union(){
            drive_shaft(length=length, solid=1);
            //the cam
            hull(){
                cylinder(r=base_rad, h=length);
                translate([0,max_rad-end_rad,length/3]) cylinder(r=end_rad, h=length/3);
            }
        }
        
        //thread path
        drive_shaft(length=length, solid=-1);
    }
}

module drive_shaft(length=peg_sep*2, dslot = false, solid=1){
    $fn=30;
    rad = (shaft/2+wall)/cos(180/6);
    con_rad = rad/2+.8;
    if(solid>=1){
        union(){
            cylinder(r=rad, h=length, $fn=6);
            translate([0,0,length-.1]) cylinder(r=con_rad, h=wall+.1, $fn=6);
        }
    }
    if(solid <=1){
        translate([0,0,-.1]) cylinder(r=m3_rad+slop, h=length+wall+.2);
        if(dslot==true){
            d_slot(shaft=shaft, height=wall+.1, tolerance = slop, dflat=dflat, $fn=30);
        }else{
            translate([0,0,-.1]) cylinder(r1=con_rad+slop*2, r2=con_rad+slop, h=wall+.2, $fn=6);
            translate([0,0,-.1]) cylinder(r1=con_rad+slop*4, r2=con_rad+slop*2, h=.5, $fn=6);
        }
    }
}

module stair_step(cam_height=0, length = ball_rad*2-1){
    height = ball_rad*2;
    inheight = ball_rad*2+wall;
    width = peg_sep*2-wall;
    
    difference(){
        union(){
            %translate([length/2,-ball_rad-wall*2,cam_height+wall+ball_rad]) sphere(r=ball_rad);
            translate([0,0,cam_height]) hull(){
                translate([0,-width,wall*.5]) cube([.1,width,height]);
                translate([length,-width,0]) cube([.1,width,height]);
            }
            
            //cam engagement
            difference(){
                translate([length/3,-width,-peg_sep]) cube([length/3, width-wall,cam_height+peg_sep+wall]);
                translate([length/3,-width/2,-cam_height-peg_sep]) scale([1,1.5,1]) rotate([0,90,0]) cylinder(r=cam_height+peg_sep,h=length, center=true, $fn=90);
            }
        }
        translate([0,0,cam_height]) difference(){
            hull(){
                translate([-.1,-width+wall,wall*1.5]) cube([.1,width-wall*2,inheight]);
                translate([length+.1,-width+wall,wall*.75]) cube([.1,width-wall*2,height]);
            }
            //leave a bump so we have room for the stabilizer
            translate([length/2,0,0]) scale([2.25,1,1]) rotate([0,0,22.5]) cylinder(r=stab_rad+slop, h=height*2, $fn=8);
        }
        
        //cutout for the slot
        translate([length/2,0,0]) rotate([0,0,90]) cylinder(r=stab_rad, h=height*3, $fn=3);
    }
}

module d_slot(shaft=6, height=10, tolerance = .2, dflat=.25, $fn=30){
    translate([0,0,-.1]){
       difference(){ 
           cylinder(r1=shaft/2+tolerance, r2=shaft/2+tolerance/2, h=height+.1);
           translate([-shaft/2,shaft/2-dflat,0]) cube([shaft, shaft, height+.1]);
           translate([-shaft/2,-shaft/2-shaft+dflat,0]) cube([shaft, shaft, height+.1]);
       }
    }
}

module guide_rail(cam_length=cam_length, step_height=step_height, num_cams=3){
    
    length = cam_length*num_cams;
    num_hangers = ceil(length/in);
    height1 = step_height*num_cams+in/2;
	
	 echo(height1);

	 height_halves = ceil(height1/(in/2));
	 echo(height_halves);
	
	 height = height_halves*25.4/2;

	 hanger_height = ceil(height_halves/2);
	 echo(height);    
	 echo(hanger_height);

    difference(){
        union(){
            for(i=[1:num_hangers]){
                hanger(solid=1, hole=[i,hanger_height], drop=in);
            }
            
            //body
            translate([0,-wall,0]) cube([length, wall, height]);
            
            //rails
            translate([0,-wall-.5,0]) for(i=[0:num_cams-1]){
                translate([cam_length/2+cam_length*i,0,0]) rotate([0,0,90]) cylinder(r=stab_rad-slop*2, h=height, $fn=3);
            }
            
        }
        for(i=[1:num_hangers]){
            hanger(solid=-1, hole=[i,hanger_height], drop=in);
        }
        
        //clear the back
        translate([0,100,0]) cube([200,200,200], center=true);
    }
}


//next section
%translate([in*5,0,in]) inlet(height=2);