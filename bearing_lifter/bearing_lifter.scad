include <../configuration.scad>;
use <../base.scad>;
use <bearing.scad>;

peg_sep = 25.4;

gear_rad = in*3.9;
hole_rad = 5;

lift_rad = in*3;
num_balls = 19;

dflat=.85;
shaft=7+slop/2;

//%pegboard([10,10]);
//%gear_mockup();

//have to print all three parts, and mount them as shown.
union(){
    rotate([-90,0,0])
mirror([1,0,0]) translate([-in*2.5,0,-in*2.5]) 
bearing_inlet();
    
bearing(bearing=false, drive_gear=true);
}
!mirror([1,0,0]) bearing_outlet();

//!rotate([-90,0,0])
union(){
    //bearing_outlet();
    translate([in*4.5,-in*1-1-ball_rad*2-wall,in*4]) rotate([90,0,0]) mirror([0,0,1])
    bearing();

    *translate([in*4.5+in*5.25,-in*1-1-ball_rad*2-wall,in*8.75]) rotate([-90,0,0]) mirror([0,0,0])
    bearing();
}

%cube([200,200,1],center=true);


//this is a mockup so I could size it quickly :-)
module gear_mockup(){
    translate([in*4.5,0,in*4]) rotate([90,0,0]){
        //the giant bearing
        %translate([0,0,in+1]) cylinder(r=gear_rad, h=in/2);
        for(i=[0:360/10:360]){
            %rotate([0,0,i]) translate([0,lift_rad,in+1]) hull(){
                sphere(r=ball_rad+wall);
                translate([0,0,in/2]) sphere(r=ball_rad+wall);
            }
        }
    }
}

//inlet ramp
module bearing_inlet(){
    translate([0,0,in])
    difference(){
    union(){
            inlet(height=1, hanger_height=2.5);
            
            //inlet ramp
            translate([peg_sep,0,0]) track(rise=-.25*in, run=4*in, solid=1, end_angle=90);
            
            //bearing mount
            translate([in*4.5,0,in*3]) rotate([90,0,0]){
                translate([0,-10,0]) scale([2.7,2,1]) cylinder(r1=hole_rad*2, r2=hole_rad*2-slop*4, h = in+1, $fn=6);
                translate([0,0,in-1]) cylinder(r1=hole_rad-slop*2, r2=hole_rad-slop*4, h = in*3/4-1, $fn=6);
            }
            
            //motot mount
            //new motor mount - right angled beastie
           translate([in/2, -in, in*2+6]) rotate([90,0,0])  rotate([0,0,90]){
            
              %translate([0,0,1+ball_rad*2+wall/2+2]) rotate([0,0,8]) rotate([180,0,0]) bearing(bearing=false, drive_gear=true);
              translate([0,0,-.1]) hull() rotate([0,0,-90]) motorHoles(1);
           }
                  
            hanger(solid=1, hole=[5,4], drop=in*3.4, rot=5);
            hanger(solid=1, hole=[4,4], drop=in*3.5, rot =-15);
            hanger(solid=1, hole=[6,4], drop=in*3.7, rot = 25);
           
            hanger(solid=1, hole=[0,4], drop=in*3.5, rot =-20);
            hanger(solid=1, hole=[2,4], drop=in*3.5, rot = 20);
            
        }
        
        translate([in*4.5,0,in*3]) rotate([90,0,0]){
                translate([0,0,in*1.5+.1]) cylinder(r=1.45, r2=1.6, h = in*1.25, $fn=30, center=true);
            }
            
                        //new motor mount - right angled beastie
           translate([in/2, -in, in*2+6]) rotate([90,0,0])  rotate([0,0,90]){
              rotate([0,0,-90]) motorHoles(0);
           }
        
        hanger(solid=-1, hole=[5,4], drop=in*6.5);
        hanger(solid=-1, hole=[4,4], drop=in*3.5, rot =-20);
        hanger(solid=-1, hole=[6,4], drop=in*3.5, rot = 20);
           
        //hanger(solid=-1, hole=[1,2], drop=in*6.5);
           
        hanger(solid=-1, hole=[0,4], drop=in*3.5, rot =-20);
        hanger(solid=-1, hole=[2,4], drop=in*3.5, rot = 20);
    }
}



//outlet ramp
module bearing_outlet(){
	$fn=30;

	motor_rad = 33/2;
	motor_mount_rad = 38/2;
	m3_rad = 1.7;
    
    motor_bump=3.5;
    
    support_step=8;
    
    translate([0,0,in])
    difference(){
        union(){
            //outlet ramp
            translate([in*8,0,in*4.5])
            translate([peg_sep,0,0]) mirror([i,0,0]) track(rise=.75*in-2, run=5*in, solid=1, end_angle=90, end_scale=[1.33,1,1]);
            
            //prevents the balls from rolling out prematurely
            for(i=[1:8]){
                translate([in*4.5,0,in*3]) hull(){
                    rotate([0,35-i*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i)/4, r2=2+(i)/2, h=in);
                    rotate([0,35-(i+1)*support_step,0]) translate([lift_rad-in*3/16,0,0]) rotate([90,0,0]) cylinder(r1=1+(i+1)/4, r2=2+(i+1)/2, h=in);
                }
            }

				//motor mounting lugs
				*translate([in*7, 0, in*6.5]) rotate([90,0,0]){
					difference(){
						union(){
							translate([-motor_mount_rad,0,0]) cylinder(r1=in/2, r2=m3_rad+wall, h=in-wall);

							//the right mount is curvy
							for(i=[-15:5:15]) translate([-motor_mount_rad,0,0]) rotate([0,0,i]) translate([motor_mount_rad*2,0,0]) hull(){
								cylinder(r1=in/2, r2=m3_rad+wall, h=in-wall);
							}
						}
						translate([-motor_mount_rad,0,in/2]) cylinder(r=m3_rad, h=in+wall);
						translate([-motor_mount_rad,0,-.2]) cylinder(r=m3_rad, h=in/2);
						translate([-motor_mount_rad,0,in/2-3.2]) cylinder(r=7/2, h=3, $fn=6);
						
						//the right mount is curvy
						for(i=[-15:1:15]) translate([-motor_mount_rad,0,-.1]) rotate([0,0,i]) translate([motor_mount_rad*2,0,0]) {
							translate([0,0,in/2]) cylinder(r=m3_rad, h=in+wall);
							translate([0,0,-.2]) cylinder(r=m3_rad, h=in/2);
							translate([0,0,in/2-3.2]) cylinder(r=7/2, h=3, $fn=6);
						}
						
						//motor clearance
						*translate([-motor_mount_rad,0,0]) rotate_extrude(){
							translate([motor_mount_rad,0,-.1]) square([motor_rad*2, in*2], center=true);
						}

						//motor clearance
						for(i=[-30:15:90]) translate([-motor_mount_rad,0,-.1]) rotate([0,0,i]) translate([motor_mount_rad,0,0]) hull(){
							cylinder(r=motor_rad, h=in*2);
							//translate([50,0,0]) cylinder(r=motor_rad, h=in*2);
						}
					}
        		}
                
            //new motor mount - right angled beastie
           *translate([in*6.5, -in+2-motor_bump, in*6.8+2.5]) rotate([90,0,0])  rotate([0,0,0]){
            
              %translate([0,0,1]) rotate([0,0,7]) bearing(bearing=false, drive_gear=true);
              hull() rotate([0,0,-90]) motorHoles(1);
           }

            //hull(){
                hanger(solid=1, hole=[6,7], drop=in);
                hanger(solid=1, hole=[8,7], drop=in*1.5, rot=-30);
            //}
        }
        
        *translate([in*6.5, -in+2-motor_bump, in*6.8+2.5]) rotate([90,0,0])  rotate([0,0,0]){
            //bearing(bearing=false, drive_gear=true);
            rotate([0,0,-90]) motorHoles(0);
        }
        
        hanger(solid=-1, hole=[6,7], drop=in);
        hanger(solid=-1, hole=[8,7], drop=in*1.5, rot=-30);
    }
}

module motorHoles(solid=1, motor_bump=3){
    %translate([0,37/2-12,-20.8/2]) cube([22.3,37,20.8], center=true);
    %translate([0,37-12,-20.8/2]) rotate([-90,0,0]) cylinder(r=22/2, h=28);
    
    if(solid==1) translate([0,0,0]) {
        //mounting holes
            mirror([0,0,1]) translate([0,0,(20.8)*1]) for(i=[0,1]) mirror([i,0,0]) translate([17.5/2,20,0]) {
                //cylinder(r=3.3/2+wall, h=motor_bump);
                translate([0,0,0]) cylinder(r1=3.1, r2=3.1+wall, h=motor_bump+.1);
                translate([0,0,motor_bump]) cylinder(r=3.1+wall, h=wall/2);
            }
    }
    
    if(solid==0){
        translate([0,0,-1]){
            //center hole is overwritten by the sprocket hole, but it's good to have
            //cylinder(r=5.2, h=30);
       
            //bump - straight up
            //translate([0,12,0]) cylinder(r=2.6, h=3.1);
       
            //mounting holes
            for(j=[0,1]) mirror([0,0,1]) translate([0,0,(20.8-2)*1]) for(i=[0,1]) mirror([i,0,0]) translate([17.5/2,20,0]) {
                cylinder(r=3.3/2, h=30);
                translate([0,0,2.6]) cylinder(r1=3.3/2, r2=3.1, h=1.5);
                translate([0,0,wall+1]) cylinder(r=3.1, h=20);
            }
       }
   }       
}

module bearing(bearing=true, drive_gear=false){
    //set variables
    // bearing diameter of ring
    D=in*5.25;
    // thickness
    T=ball_rad*2+wall;
    // clearance
    tol=.3;
    number_of_planets=5;
    number_of_teeth_on_planets=11;
    approximate_number_of_teeth_on_sun=21;
    ring_outer_teeth = 71;
    // pressure angle
    P=45;//[30:60]
    // number of teeth to twist across
    nTwist=1;
    // width of hexagonal hole
    w=hole_rad*2;

    DR=0.5*1;// maximum depth ratio of teeth
    
    //derived variables
    m=round(number_of_planets);
    np=round(number_of_teeth_on_planets);
    ns1=approximate_number_of_teeth_on_sun;
    k1=round(2/m*(ns1+np));
    k= k1*m%2!=0 ? k1+1 : k1;
    ns=k*m/2-np; //actual number of teeth on the sun
    echo(ns);
    nr=ns+2*np; //number of teeth on the inside of the ring gear
    pitchD=0.9*D/(1+min(PI/(2*nr*tan(P)),PI*DR/nr));
    pitch=pitchD*PI/nr;
    //echo(pitch);
    helix_angle=atan(2*nTwist*pitch/T);
    //echo(helix_angle);
    phi=$t*360/m;
    
    //%translate([0,0,-50]) cylinder(r=gear_rad, h=50);
    
        if(drive_gear==true){
            //motor drive gear - just a planet with a motor attachment.
            translate([0,0,T/2]) difference(){
                union(){
                    //%cylinder(r=18, h=40);
                    herringbone(11,pitch,P,DR,tol,helix_angle,T);
                }
            
                //d shaft
                translate([0,0,-30]) d_slot(shaft=shaft, height=60, dflat=dflat);
            }
        }
    
    if(bearing==true)
    translate([0,0,T/2]){
        //ring gear
        difference(){
            mirror([0,1,0])
            herringbone(ring_outer_teeth,pitch,P,DR,tol,helix_angle,T);
            //inner ring
            herringbone(nr,pitch,P,DR,-tol,helix_angle,T+0.2);
            
            //ball holes
            for(i=[0:360/num_balls:359]) rotate([0,0,i]) translate([lift_rad,0,0]) hull(){
                translate([0,0,-wall/2]) sphere(r=ball_rad+wall);
                //translate([0,0,-T/2-.1]) cylinder(r=ball_rad, h=5);
                translate([-in/4,0,ball_rad+wall/2]) sphere(r=ball_rad+wall/2);
            }
        }
        

        
        //sun gear
        rotate([0,0,(np+1)*180/ns+phi*(ns+np)*2/ns])
        difference(){
            mirror([0,1,0])
                herringbone(ns,pitch,P,DR,tol,helix_angle,T);
            //cylinder(r=w/sqrt(3),h=T+1,center=true,$fn=6);
            translate([0,0,-T/2-.1]) cylinder(r1=hole_rad, r2=hole_rad-slop*2, h = in+1, $fn=6);
        }
        
        //planets
        for(i=[1:m])rotate([0,0,i*360/m+phi])translate([pitchD/2*(ns+np)/nr,0,0])
            rotate([0,0,i*ns/m*360/np-phi*(ns+np)/np-phi]){
                herringbone(np,pitch,P,DR,tol,helix_angle,T);
            }
        }
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
%translate([in*9,0,in]) inlet(height=5);