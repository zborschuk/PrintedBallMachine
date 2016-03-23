in = 25.4;

hole_rad = 6.5/2;
hole_sep = 25.4;


handle();

module handle(){
    min_rad = 4;
    
    difference(){
        minkowski(){
            difference(){
                hull(){
                    cube([5.5*in, 3*in, .5*in], center=true);
                    translate([0,-.5*in,0]) cube([.125*in, 3*in, .5*in], center=true);
                }
                
                //hanging holes
                for(i=[-1:1/2:1]){
                    translate([2.25*in*i,-1.5*in+.5*in*abs(i), 0]) cylinder(r=9, h=200, center=true);
                    echo(.5*abs(i));
                    echo(.333*abs(i));
                }
                
                
                translate([.5*in,.5*in,0]) rotate([0,0,45/2]) cylinder(r=3*in/2, h=200, center=true, $fn=8);
                translate([-.5*in,.5*in,0]) rotate([0,0,45/2]) cylinder(r=3*in/2, h=200, center=true, $fn=8);
            }
            sphere(r=min_rad, $fn=8);
        }
        
        #translate([0,1.25*in-2,1*in-.35*in]) cube([6*in, 1*in, 1*in], center=true);
        
        //pegboard holes
        for(i=[0:hole_sep:500]) translate([5.5*in-i,1.125*in,0]) cylinder(r=hole_rad, h=200, center=true);
    }
}