in = 25.4;

hole_rad = 6.5/2;
hole_sep = 25.4;

%cube([in,in,in], center=true);

%cube([in*1.5,in*1.5,in/2], center=true);

part = 0;

if(part == 0)
    handle();

width = 4.5;
height = 3;

module handle(){
    min_rad = in/8;
    
    thick = in/2 - min_rad*2;
    
    difference(){
        minkowski(){
            difference(){
                hull(){
                    cube([width*in, (height-.5)*in, thick], center=true);
                    translate([0,-.5*in,0]) cube([.125*in, (height-.5)*in, thick], center=true);
                }
                
                //hanging holes
                for(i=[-1:.5:1]){
                    translate([(width/2*in-in/2)*i,-(height/2-.25)*in+.333*in*abs(i), 0]) cylinder(r=9, h=200, center=true);
                    echo(.5*abs(i));
                    echo(.333*abs(i));
                }
                
                
                hull(){
                    translate([.5*in,.5*in,0]) rotate([0,0,45/2]) cylinder(r=(height-.5)*in/2, h=200, center=true, $fn=8);
                    translate([-.5*in,.5*in,0]) rotate([0,0,45/2]) cylinder(r=(height-.5)*in/2, h=200, center=true, $fn=8);
                }
            }
            sphere(r=min_rad, $fn=8);
        }
        
        translate([0,(height-1)/2*in,1/2*in]) cube([6*in, 1*in, 1*in], center=true);
        
        //pegboard holes
        for(i=[width%2*in:hole_sep:500]) translate([5.5*in-i,(height/2-.5)*in,0]) cylinder(r=hole_rad, h=200, center=true);
    }
}