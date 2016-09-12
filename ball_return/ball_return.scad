include<configuration.scad>
use <base.scad> 
use <pins.scad>

part = 10;

if(part == 0)
    rotate([0,90,0]) rear_ball_return_inlet();

if(part == 2)
    rotate([0,90,0]) rear_ball_return_inlet(width=3);

if(part == 1)
    rotate([0,270,0]) rear_ball_return_outlet();

if(part == 10){
    translate([in*8, 0, -in*4]) offset_slope_module();
    translate([in*9+.1, 0, -in*7]) offset_slope_module();

    translate([in*13,0,-in*3]) rear_ball_return_inlet();
    translate([in*9,0,-in*4]) rear_ball_return_outlet();
}


module rear_ball_return_inlet(width=2){
    inset = .75;
    %translate([-in*12,wall,-in*5]) pegboard([12,12]);
    difference(){
        union(){
            //inlet catcher - extends to the back, to deposit balls there.
            inlet(length=1, hanger_height=0, outlet=REVERSE, height=1, width=1+width+inset, board_inset = in*1.75);
            
            //base stiffener
            hull(){
                translate([in-.1,-(width)*in,0]) cube([wall,in*(1+width)+inset*in,in]);
                translate([in-.1,-wall,-in/2]) cube([wall,wall,in/4]);
            }
            
            //false bottom, to make a better channel
            difference(){
                translate([wall/4,-(width)*in,0]) cube([in,in*(1+width)+inset*in,wall*4]);
                
                //exit slope
                hull(){
                    translate([in/2,inset*in+in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([-in/2,inset*in+in/2,in/2]) sphere(r=ball_rad+wall);
                }
                
                //horizontal slope
                hull(){
                    translate([in/2,inset*in+in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    #translate([in/2,-in*(width-.5),in*.8]) sphere(r=ball_rad+wall);
                }
            }
            
            
            //attach it to the pegboard
            translate([0,0,0]) difference(){
                hull(){
                    hanger(solid=1, hole=[0,0], drop = in*2.5, rot=245);
                    hanger(solid=1, hole=[-1,0], drop = in*3.25, rot=230);
                    //cylinder(r=in, h=wall);
                }
                
                hanger(solid=-1, hole=[0,0]);
                hanger(solid=-1, hole=[-1,0]);
                
                //ball hole
                hull(){
                    translate([in/2,0,in*.45]) sphere(r=ball_rad+wall);
                    translate([in/2,0,in*2]) sphere(r=ball_rad+wall);
                }
            }
            
            //back nub
            translate([0,wall*2+in*.25,0]) difference(){
                difference(){
                    translate([in*.025,0,in/2]) rotate([90,0,0]) cylinder(r=in/4, h=wall);
                    translate([in*.025,-in/2,0]) cube([in,in,in]);
                }
            }
            
            //hold a couple dowels underneath, to run the balls to the outlet
            translate([in,in*1.25,-in*.66666]) dowel_holder();
        }
        
        translate([in,in*1.25,-in*.66666]) dowel_holes();
        
        
        
        //flatten the far side for printing on
        translate([100+in+wall/2,0,0]) cube([200,200,200], center=true);
    }
}

module rear_ball_return_outlet(){
    inset = .75;
    %translate([-in*12,wall,-in*5]) pegboard([12,12]);
    difference(){
        union(){
            //inlet catcher - extends to the back, to deposit balls there.
            translate([0,in/2,0]) rotate([0,0,180]) inlet(length=1, hanger_height=0, outlet=REVERSE, height=1, width=2+inset, board_inset = in*1.5);
            
            mirror([1,0,0]) hull(){
                translate([in-.1,-1*in,0]) cube([wall,in*2.75,in]);
                translate([in-.1,wall*2+in*.25,-in/2]) cube([wall,wall,in/4]);
            }
            
            //false bottom, to make a better channel
            difference(){
                translate([-in-wall/4,-1*in,0]) cube([in,in*2+inset*in,wall*4]);
                
                //exit slope
                hull(){
                    translate([-in/2,-in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([in/2,-in/2,in/2]) sphere(r=ball_rad+wall);
                }
                
                //horizontal slope
                hull(){
                    translate([-in/2,-in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([-in/2,in/2+inset*in,in*.7]) sphere(r=ball_rad+wall);
                }
                
                //inlet slope
                hull(){
                    //translate([-in/2,-in/2,in/2+wall]) sphere(r=ball_rad+wall);
                    translate([-in/2,in/2+inset*in,in*.7]) sphere(r=ball_rad+wall);
                    translate([in/2,in/2+inset*in,in*.75]) sphere(r=ball_rad+wall);
                }
            }
                   
            //attach it to the pegboard
            translate([0,wall*3+in*.25,0]) mirror([1,0,0]) difference(){
                hull(){
                    hanger(solid=1, hole=[0,0], drop = in*2.5, rot=245);
                    hanger(solid=1, hole=[-1,0], drop = in*3.25, rot=230);
                    
                    //translate([in*.025,0,-in*.75-in*.125]) rotate([90,0,0]) cylinder(r=in, h=wall);
                }
                
                hanger(solid=-1, hole=[0,0]);
                hanger(solid=-1, hole=[-1,0]);
                //translate([-in*2+1,-wall-.5,-in-1]) cube([in*2,wall+1,in*2]);
                
                //ball hole
                hull(){
                    translate([in/2,0,in*.45]) sphere(r=ball_rad+wall);
                    translate([in/2,0,in*2]) sphere(r=ball_rad+wall);
                }
            }
            
            //front nub
            translate([0,wall,0]) mirror([1,0,0]) difference(){
                difference(){
                    translate([in*.025,0,in/2]) rotate([90,0,0]) cylinder(r=in/4, h=wall);
                    translate([in*.025,-in/2,0]) cube([in,in,in]);
                }
            }
            
            //hold a couple dowels underneath, to run the balls to the outlet
            mirror([0,0,1]) translate([wall,in*1.25,-in*.75+in*0]) dowel_holder();
        }
        
        //rods coming in :-)
        mirror([0,0,1]) translate([wall,in*1.25,-in*.75+in*0]) dowel_holes(dowel_hole=wall*3+.1);
        
        //ball entrance
        hull(){
            translate([wall/2,in*1.25,in*.6]) sphere(r=ball_rad+wall);
            translate([wall/2,in*1.25,in]) sphere(r=ball_rad+wall);
        }
        
        //flatten the far side for printing on
        mirror([1,0,0]) translate([100+in+wall/2,0,0]) cube([200,200,200], center=true);
    }
}

module dowel_holder(){
    separation = 16;
    
    insert_angle = 30;
    
    difference(){
        union(){
            //the rod holders
            for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
                rotate([0,90,0]) cylinder(r=dowel_rad+wall, h=wall*2, center=true);
            }
            
        }
        
        //the rods
        for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
            rotate([0,90,0]) cylinder(r=dowel_rad, h=200, center=true);
            translate([wall*.75,0,0]) rotate([0,90,0]) cylinder(r1=dowel_rad, r2=dowel_rad*1.25, h=wall, center=true);
            translate([-wall*.75,0,0]) rotate([0,90,0]) cylinder(r2=dowel_rad, r1=dowel_rad*1.25, h=wall, center=true);
        }
        
        //rod insert area
        //%translate([0-wall/2,-wall*3/4-dowel_rad+separation/2,in/2+2-dowel_rad-wall]) rotate([0,90,0]) cylinder(r=dowel_rad, h=wall*30, center=true);
        translate([0-wall/2,0,in/2+1-separation/2]) difference(){
            translate([0,0,3]) cube([separation, separation, separation], center=true);
            translate([0,0,separation/2+3]) rotate([0,90,0]) scale([1,1,1.25]) sphere(r=4, h=40, center=true);
            
            for(i=[0,1]) mirror([0,i,0]) translate([0,separation/2,separation/2-dowel_rad-wall/2]) rotate([0,90,0]) cylinder(r=wall/2, h=40, center=true);
            
        }
    }
}

module dowel_holes(dowel_hole=50){
        separation = 16;
    
    insert_angle = 30;
    
    union(){
        
        //the rods
        for(i=[-separation/2,separation/2]) translate([0-wall/2,i,in/2+1]){
            #rotate([0,90,0]) cylinder(r=dowel_rad, h=dowel_hole, center=true);
            translate([wall*.75,0,0]) rotate([0,90,0]) cylinder(r1=dowel_rad, r2=dowel_rad*1.25, h=wall, center=true);
            translate([-wall*.75,0,0]) rotate([0,90,0]) cylinder(r2=dowel_rad, r1=dowel_rad*1.25, h=wall, center=true);
        }
        
        //rod insert area
        //%translate([0-wall/2,-wall*3/4-dowel_rad+separation/2,in/2+2-dowel_rad-wall]) rotate([0,90,0]) cylinder(r=dowel_rad, h=wall*30, center=true);
        *translate([0-wall/2,0,in/2+1-separation/2]) difference(){
            translate([0,0,3]) cube([separation, separation, separation], center=true);
            translate([0,0,separation/2+3]) rotate([0,90,0]) scale([1,1,1.25]) sphere(r=4, h=40, center=true);
            
            for(i=[0,1]) mirror([0,i,0]) translate([0,separation/2,separation/2-dowel_rad-wall/2]) rotate([0,90,0]) cylinder(r=wall/2, h=40, center=true);
            
        }
    }
}